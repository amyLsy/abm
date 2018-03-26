//
//  YZGRequestManager.m
//  sisitv_ios
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//
#import "YZGRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+MD5.h"
#import "YZGRequest.h"
#import <pthread/pthread.h>
#import "RootTool.h"
#import "AlertTool.h"
#import "Account.h"
#import <SVProgressHUD/SVProgressHUD.h>


#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

#define kYZGNetworkIncompleteDownloadFolderName @"Incomplete"

@interface YZGRequestManagerConfiguration ()


@end

@implementation YZGRequestManagerConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseURL = @"http://to.deerlive.com/Api/SiSi/";
//        _baseURL = @"http://91yeyan.com/Api/SiSi/";
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _debugLogEnabled = NO;
    }
    return self;
}



@end


#pragma mark - YZGRequestManager

@interface YZGRequestManager ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@property (nonatomic , strong) NSIndexSet *allStatusCodes;

@property (nonatomic , strong) NSMutableDictionary<NSNumber *, YZGRequest *> *requestsRecord;

@end

@implementation YZGRequestManager{
    pthread_mutex_t _lock;
    dispatch_queue_t _processingQueue;
}

+ (instancetype)sharedInstance
{
    static YZGRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.networkStatus = YZGNetworkReachabilityStatusUnknown;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];

        self.allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        self.requestsRecord = [[NSMutableDictionary alloc] init];

        _processingQueue = dispatch_queue_create("com.sisi.networkRequestManager.yzgprocess", DISPATCH_QUEUE_CONCURRENT);
        pthread_mutex_init(&_lock, NULL);
        
        self.configuration = [[YZGRequestManagerConfiguration alloc]init];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:self.configuration.sessionConfiguration];
        self.sessionManager.securityPolicy = self.configuration.securityPolicy;
        self.sessionManager.completionQueue = _processingQueue;
    }
    return self;
}
- (void)reachabilityChanged:(NSNotification *)notification
{
    self.networkStatus = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
}


-(void)addRequest:(YZGRequest *)request{
    NSParameterAssert(request != nil);

    NSError * __autoreleasing requestSerializationError = nil;
    
    request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];

    if (requestSerializationError) {
        [self requestDidFailWithRequest:request error:requestSerializationError];
        return;
    }
    
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    
    // Set request task priority
    // !!Available on iOS 8 +
    if ([request.requestTask respondsToSelector:@selector(priority)]) {
//        switch (request.requestPriority) {
//            case YZGRequestPriorityHigh:
//                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
//                break;
//            case YZGRequestPriorityLow:
//                request.requestTask.priority = NSURLSessionTaskPriorityLow;
//                break;
//            case YZGRequestPriorityDefault:
//                /*!!fall through*/
//            default:
//                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
//                break;
//        }
    }
    
    // Retain request
    YZGLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (NSURLSessionTask *)sessionTaskForRequest:(YZGRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    YZGRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    
    NSMutableDictionary *param;
    if ([request.requestParam isKindOfClass:[BaseParam class]]) {
        param = [request.requestParam mj_keyValues];
    }else{
        param = [NSMutableDictionary dictionaryWithDictionary:request.requestParam];
    }
    
    [param setObject:[[NSString getSignatureaAndTimeStamp] firstObject] forKey:@"sign"];
    [param setObject:[[NSString getSignatureaAndTimeStamp] lastObject] forKey:@"timestamp"];
    
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
   
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:request];
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    switch (method) {
        case YZGRequestMethodGET:
            if (request.isDownload) {
                return [self downloadTaskWithDownloadPath:request.resumableDownloadPath URLString:url parameters:param progress:request.resumableDownloadProgressBlock error:error];
            } else {
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer responseSerializer:responseSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
            }
        case YZGRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer responseSerializer:responseSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
 
    }
}

- (NSString *)buildRequestUrl:(YZGRequest *)request {
    NSParameterAssert(request != nil);
    
    NSString *detailUrl = [request requestUrl];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    // If detailUrl is valid URL
    if (temp && temp.host && temp.scheme) {
        return detailUrl;
    }
    NSString *baseUrl;
    
    if ([request baseUrl].length > 0) {
        baseUrl = [request baseUrl];
    } else {
        baseUrl = [self.configuration baseURL];
    }
    // URL slash compability
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

-(AFHTTPResponseSerializer *)responseSerializerForRequest:(YZGRequest *)request{
    AFHTTPResponseSerializer *responseSerializer = nil;
    if (request.responseSerializerType == YZGResponseSerializerTypeHTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    } else if (request.responseSerializerType == YZGResponseSerializerTypeJSON) {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }else if (request.responseSerializerType == YZGResponseSerializerTypeXMLParser) {
        responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = [request acceptableContentTypes];
    responseSerializer.acceptableStatusCodes = self.allStatusCodes;
    return responseSerializer;
}


- (AFHTTPRequestSerializer *)requestSerializerForRequest:(YZGRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == YZGRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == YZGRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    
    // If api needs server username and password
    NSArray<NSString *> *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
                                                          password:authorizationHeaderFieldArray.lastObject];
    }
    
    // If api needs to add custom value to HTTPHeaderField
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error {
    NSParameterAssert(downloadPath);
    // add parameters to URL;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // If targetPath is a directory, use the file name we got from the urlRequest.
    // Make sure downloadTargetPath is always a file, not directory.
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    // AFN use `moveItemAtURL` to move downloaded file to target path,
    // this method aborts the move attempt if a file already exist at the path.
    // So we remove the exist file before we start the download task.
    // https://github.com/AFNetworking/AFNetworking/issues/3775
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    __block NSURLSessionDownloadTask *downloadTask = nil;
    
    downloadTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            downloadProgressBlock(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self handleRequestResult:downloadTask responseObject:filePath error:error];
    }];
    return downloadTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                             responseSerializer :(AFHTTPResponseSerializer *)responseSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        for (NSString *key in parameters) {
            if ([key isEqualToString:@"ID"]) {
                [parameters setObject:parameters[key] forKey:@"id"];
                [parameters removeObjectForKey:key];
                break;
            }
        }
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    self.sessionManager.responseSerializer = responseSerializer;
    
    __block NSURLSessionDataTask *dataTask = nil;

    dataTask = [self.sessionManager dataTaskWithRequest:request
                           completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
                               [self handleRequestResult:dataTask responseObject:responseObject error:_error];
                           }];
    
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    YZGRequest *request = self.requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    if (!request) {
        return;
    }
    
    NSError * __autoreleasing validationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
   
    if (error) {
        succeed = NO;
        requestError = error;
        request.networkError = YES;
    }else if(![responseObject isKindOfClass:[NSDictionary class]]){
        request.networkError = NO;
        succeed = NO;
        requestError  = [NSError errorWithDomain:YZGRequestValidationErrorDomain code:YZGRequestValidationErrorInvalidJSONFormat userInfo:@{NSLocalizedDescriptionKey:@"Invalid JSON format"}];
    }else {
        request.networkError = NO;
        succeed = [self validateResult:request error:&validationError];
        requestError = validationError;
    }
    if (succeed) {
        //转化为Model模型
        [request serializedResponseObjectToModel];
        
        [self requestDidSucceedWithRequest:request];
        
        YZGLog(@"Finished Request: %@", NSStringFromClass([request class]));
    }
    else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}

- (BOOL)validateResult:(YZGRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    BOOL result = [request statusCodeValidator];
    if (!result) {
        if (error) {
            NSString *localizedErrorString = request.responseObject[@"descrp"];
            *error = [NSError errorWithDomain:YZGRequestValidationErrorDomain code:YZGRequestValidationErrorInvalidStatusCode userInfo:@{NSLocalizedDescriptionKey:localizedErrorString}];
        }
        return result;
    }
    if ([request jsonValidator]) {
        return YES;
    }else{
        *error = [NSError errorWithDomain:YZGRequestValidationErrorDomain code:YZGRequestValidationErrorInvalidJSONFormat userInfo:@{NSLocalizedDescriptionKey:@"Invalid JSON format"}];
        return NO;
    }
}

- (void)requestDidSucceedWithRequest:(YZGRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

- (void)requestDidFailWithRequest:(YZGRequest *)request error:(NSError *)error {
    request.error = error;
    
    if (request.responseStatusCode == 504) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD showInfoWithStatus:@"登录信息无效请重新登录"];
            [Account shareInstance].token = nil;
            //进行重新登
            [[RootTool sharedInstance] chooseRootController];
        });
    }
    YZGLog(@"Request %@ failed, urlString:%@ status code = %ld, error = %@, param = %@",
           NSStringFromClass([request class]),request.requestUrl, (long)request.responseStatusCode, error.localizedDescription,[request.requestParam mj_keyValues]);
    //登录信息错误进行从新登录
 
    
    
    request.responseObject = nil;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}

- (void)addRequestToRecord:(YZGRequest *)request {
    Lock();
    self.requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(YZGRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    YZGLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}

#pragma mark - Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kYZGNetworkIncompleteDownloadFolderName];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        YZGLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:downloadPath];
    return [NSURL fileURLWithPath:tempPath];
}

#pragma mark - Cancel Request

- (void)cancelRequest:(YZGRequest *)request {
    NSParameterAssert(request != nil);
    
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            YZGRequest *request = _requestsRecord[key];
            Unlock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}

@end

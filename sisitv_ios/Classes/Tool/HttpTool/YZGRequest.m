//
//  YZGRequest.m
//  sisitv_ios
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGRequest.h"
#import "YZGRequestManager.h"
#import "YZGAppSettingUtilits.h"

NSString *const YZGRequestValidationErrorDomain = @"com.sisi.request.validation";

@implementation YZGRequest

-(instancetype)init{
    if (self = [super init]) {
        self.requestMethod = YZGRequestMethodPOST;
    }
    return self;
}

-(instancetype)initWithRequestUrl:(NSString *)requestUrl{
    if (self = [super init]) {
        self.requestUrl = requestUrl;
        self.requestMethod = YZGRequestMethodPOST;
    }
    return self;
}

-(instancetype)initWithRequestParam:(id)requestParam{
    if (self = [super init]) {
        self.requestParam = requestParam;
        self.requestMethod = YZGRequestMethodPOST;
    }
    return self;
}

-(instancetype)initWithRequestUrl:(NSString *)requestUrl withRequestParam:(nullable id)requestParam{
    if (self = [super init]) {
        self.requestUrl = requestUrl;
        self.requestParam = requestParam;
        self.requestMethod = YZGRequestMethodPOST;
    }
    return self;
}


#pragma mark - Request Configuration

- (YZGRequestSerializerType)requestSerializerType {
    return YZGRequestSerializerTypeHTTP;
}


- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Response Information

- (YZGResponseSerializerType)responseSerializerType {
    return YZGResponseSerializerTypeJSON;
}

-(NSSet<NSString *> *)acceptableContentTypes{
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",@"audio/mpeg",nil];
}

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return [self.responseObject[@"code"] integerValue];
}
-(NSDictionary *)responseHeaders{
    return self.response.allHeaderFields;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

-(BOOL)jsonValidator{
    return YES;
}

#pragma mark - Request Action

- (void)start {
    [[YZGRequestManager sharedInstance] addRequest:self];
}
- (void)startWithCompletionBlockWithSuccess:(YZGRequestCompletionBlock)success
                                    failure:(YZGRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(YZGRequestCompletionBlock)success
                              failure:(YZGRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)stop {
    [[YZGRequestManager sharedInstance] cancelRequest:self];
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.constructingBodyBlock = nil;
    self.resumableDownloadProgressBlock = nil;
}

- (NSString *)baseUrl{
    return AppApi;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

-(void)serializedResponseObjectToModel{
    //子类实现
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, [self.requestParam mj_keyValues]];
}

-(void)dealloc{
    if (self.error) {
        YZGLog(@"Request error %@-=-",self);
    }else{
        YZGLog(@"%@ -=- dealloc",NSStringFromClass([self class]));
    }
}

@end

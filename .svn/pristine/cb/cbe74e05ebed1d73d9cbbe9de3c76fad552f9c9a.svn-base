//
//  YZGBatchRequest.m
//  sisitv_ios
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGBatchRequest.h"
#import "YZGRequest.h"

@interface YZGBatchRequestManager ()

@property (strong, nonatomic) NSMutableArray<YZGBatchRequest *> *requestArray;

@end

@implementation YZGBatchRequestManager

+(instancetype)sharedInstance{
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addBatchRequest:(YZGBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(YZGBatchRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end

@interface YZGBatchRequest ()<YZGRequestDelegate>

@property (nonatomic) NSInteger finishedCount;

@end

@implementation YZGBatchRequest

-(instancetype)initWithRequestArray:(NSArray<YZGRequest *> *)requestArray{
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (YZGRequest * request in _requestArray) {
            if (![request isKindOfClass:[YZGRequest class]]) {
                YZGLog(@"Error, request item must be YZGRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    if (_finishedCount > 0) {
        YZGLog(@"Error! Batch request has already started.");
        return;
    }
    _failedRequest = nil;
    [[YZGBatchRequestManager sharedInstance] addBatchRequest:self];
    for (YZGRequest * request in _requestArray) {
        request.delegate = self;
        [request clearCompletionBlock];
        [request start];
    }
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(YZGBatchRequest *batchRequest))success
                                    failure:(void (^)(YZGBatchRequest *batchRequest))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(YZGBatchRequest *batchRequest))success
                              failure:(void (^)(YZGBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}
- (void)stop {
    [self clearRequest];
    [[YZGBatchRequestManager sharedInstance] removeBatchRequest:self];
}

- (void)clearRequest {
    for (YZGRequest * request in _requestArray) {
        [request stop];
    }
    [self clearCompletionBlock];
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - Network Request Delegate

- (void)requestFinished:(__kindof YZGRequest *)request{
    @synchronized(self) {
        _finishedCount++;
    }
    if (_finishedCount == _requestArray.count) {

        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        // Clear
        [self clearCompletionBlock];
        [[YZGBatchRequestManager sharedInstance] removeBatchRequest:self];
    }
}

- (void)requestFailed:(YZGRequest *)request {
    @synchronized(self) {
        _finishedCount++;
    }
    if (_finishedCount == _requestArray.count) {
        // Callback
        if (_failureCompletionBlock) {
            _failureCompletionBlock(self);
        }
        // Clear
        [self clearCompletionBlock];
        [[YZGBatchRequestManager sharedInstance] removeBatchRequest:self];
    }
}

- (void)dealloc {
    [self clearRequest];
}

@end

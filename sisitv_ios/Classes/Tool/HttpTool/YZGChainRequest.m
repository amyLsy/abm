//
//  YZGChainRequest.m
//  sisitv_ios
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGChainRequest.h"
#import "YZGRequest.h"

@interface YZGChainRequestManager()

@property (strong, nonatomic) NSMutableArray<YZGChainRequest *> *requestArray;

@end
@implementation YZGChainRequestManager

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

- (void)addChainRequest:(YZGChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(YZGChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end

@interface YZGChainRequest()<YZGRequestDelegate>

@property (strong, nonatomic) NSMutableArray<YZGRequest *> *requestArray;
@property (strong, nonatomic) NSMutableArray<YZGChainCallback> *requestCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) YZGChainCallback emptyCallback;

@end

@implementation YZGChainRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(YZGChainRequest *chainRequest, YZGRequest *baseRequest) {
            // do nothing
        };
    }
    return self;
}

- (void)addRequest:(YZGRequest *)request callback:(YZGChainCallback)callback {
    [_requestArray addObject:request];
    if (callback != nil) {
        [_requestCallbackArray addObject:callback];
    } else {
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (void)start {
    if (_nextRequestIndex > 0) {
        YZGLog(@"Error! Chain request has already started.");
        return;
    }
    
    if ([_requestArray count] > 0) {
        [self startNextRequest];
        [[YZGChainRequestManager sharedInstance] addChainRequest:self];
    } else {
        YZGLog(@"Error! Chain request array is empty.");
    }
}

- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArray count]) {
        YZGRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.delegate = self;
        [request clearCompletionBlock];
        [request start];
        return YES;
    } else {
        return NO;
    }
}

- (void)stop {
    [self clearRequest];
    [[YZGChainRequestManager sharedInstance] removeChainRequest:self];
}

- (NSArray<YZGRequest *> *)requestArray {
    return _requestArray;
}

#pragma mark - Network Request Delegate

- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        YZGRequest *request = _requestArray[currentRequestIndex];
        [request stop];
    }
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
}
-(void)requestFinished:(__kindof YZGRequest *)request{
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    YZGChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if (![self startNextRequest]) {
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
        }
        [[YZGChainRequestManager sharedInstance] removeChainRequest:self];
    }
}

- (void)requestFailed:(YZGRequest *)request {
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
    }
    [[YZGChainRequestManager sharedInstance] removeChainRequest:self];

}
@end

//
//  YZGBatchRequest.h
//  sisitv_ios
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class YZGRequest;
@class YZGBatchRequest;

///  YZGBatchRequestManager handles batch request management. It keeps track of all
///  the batch requests.
@interface YZGBatchRequestManager : NSObject


///  Get the shared batch request agent.
+ (instancetype )sharedInstance;

///  Add a batch request.
- (void)addBatchRequest:(YZGBatchRequest *)request;

///  Remove a previously added batch request.
- (void)removeBatchRequest:(YZGBatchRequest *)request;

@end


//  YZGBatchRequest can be used to batch several YZGRequest. Note that when used inside YZGBatchRequest, a single
///  YZGRequest will have its own callback and delegate cleared, in favor of the batch request callback.
@interface YZGBatchRequest : NSObject

///  All the requests are stored in this array.
@property (nonatomic, strong, readonly) NSArray<YZGRequest *> *requestArray;

///  The success callback. Note this will be called only if all the requests are finished.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^successCompletionBlock)(YZGBatchRequest *);

///  The failure callback. Note this will be called if one of the requests fails.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^failureCompletionBlock)(YZGBatchRequest *);

///  Tag can be used to identify batch request. Default value is 0.
@property (nonatomic) NSInteger tag;

///  The first request that failed (and causing the batch request to fail).
@property (nonatomic, strong, readonly, nullable) YZGRequest *failedRequest;

///  Creates a `YZGBatchRequest` with a bunch of requests.
///
///  @param requestArray requests useds to create batch request.
///
- (instancetype)initWithRequestArray:(NSArray<YZGRequest *> *)requestArray;

///  Convenience method to start the batch request with block callbacks.
- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(YZGBatchRequest *batchRequest))success
                                    failure:(nullable void (^)(YZGBatchRequest *batchRequest))failure;

///  Stop all the requests of the batch request.
- (void)stop;

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;

@end

NS_ASSUME_NONNULL_END

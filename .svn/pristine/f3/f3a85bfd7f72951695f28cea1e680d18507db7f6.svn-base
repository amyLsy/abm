//
//  YZGChainRequest.h
//  sisitv_ios
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YZGRequest,YZGChainRequest;

///  The YZGChainRequestDelegate protocol defines several optional methods you can use
///  to receive network-related messages. All the delegate methods will be called
///  on the main queue. Note the delegate methods will be called when all the requests
///  of chain request finishes.
@protocol YZGChainRequestDelegate <NSObject>

@optional
///  Tell the delegate that the chain request has finished successfully.
///
///  @param chainRequest The corresponding chain request.
- (void)chainRequestFinished:(YZGChainRequest *)chainRequest;

///  Tell the delegate that the chain request has failed.
///
///  @param chainRequest The corresponding chain request.
///  @param request      First failed request that causes the whole request to fail.
- (void)chainRequestFailed:(YZGChainRequest *)chainRequest failedBaseRequest:(YZGRequest*)request;

@end

///  YZGChainRequestManager handles chain request management. It keeps track of all
///  the chain requests.
@interface YZGChainRequestManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared chain request Manager.
+ (instancetype)sharedInstance;

///  Add a chain request.
- (void)addChainRequest:(YZGChainRequest *)request;

///  Remove a previously added chain request.
- (void)removeChainRequest:(YZGChainRequest *)request;

@end

typedef void (^YZGChainCallback)(YZGChainRequest *chainRequest, YZGRequest *request);

///  YZGChainRequest can be used to chain several YZGRequest so that one will only starts after another finishes.
///  Note that when used inside YZGChainRequest, a single YZGRequest will have its own callback and delegate
///  cleared, in favor of the batch request callback.
@interface YZGChainRequest : NSObject

///  All the requests are stored in this array.
- (NSArray<YZGRequest *> *)requestArray;

///  The delegate object of the chain request. Default is nil.
@property (nonatomic, weak, nullable) id<YZGChainRequestDelegate> delegate;

///  Start the chain request, adding first request in the chain to request queue.
- (void)start;

///  Stop the chain request. Remaining request in chain will be cancelled.
- (void)stop;

///  Add request to request chain.
///
///  @param request  The request to be chained.
///  @param callback The finish callback
- (void)addRequest:(YZGRequest *)request callback:(nullable YZGChainCallback)callback;


@end
NS_ASSUME_NONNULL_END

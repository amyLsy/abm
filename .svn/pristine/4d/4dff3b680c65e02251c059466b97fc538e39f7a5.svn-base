//
//  YZGRequestManager.h
//  sisitv_ios
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, YZGNetworkReachabilityStatus) {
    YZGNetworkReachabilityStatusUnknown          = -1,
    YZGNetworkReachabilityStatusNotReachable     = 0,
    YZGNetworkReachabilityStatusReachableViaWWAN = 1,
    YZGNetworkReachabilityStatusReachableViaWiFi = 2,
};

@class YZGRequest;
@class AFSecurityPolicy;

@interface YZGRequestManagerConfiguration : NSObject

@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

/**
 *  如 http://api.mogujie.com
 */
@property (nonatomic, copy) NSString *baseURL;

///  Security policy will be used by AFNetworking. See also `AFSecurityPolicy`.
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
///  Whether to log debug info. Default is NO;
@property (nonatomic) BOOL debugLogEnabled;

@end

@interface YZGRequestManager : NSObject


+ (instancetype)sharedInstance;

/**
 *  当前的网络状态
 */
@property (nonatomic) YZGNetworkReachabilityStatus networkStatus;

/**
 *  拿到 sharedInstance 后，可以设置这个 property，当 configuration 中的某几项有变动，
 *  并且要对全局做更改时，可以再次设置这个 property
 */
@property(nonatomic) YZGRequestManagerConfiguration *configuration;

/**
 *  正在发送的请求们，里面是一些 NSURLSessionDataTask
 */
@property (nonatomic, readonly) NSArray *runningTasks;


/**
 Add request to session and start request.

 @param request 网络请求的接口和请求方式等的包装
 */
- (void)addRequest:(YZGRequest *)request ;


///  Cancel a request that was previously added.
- (void)cancelRequest:(YZGRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;


@end

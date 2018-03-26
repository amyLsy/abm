//
//  YZGListModel.h
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"
#import "YZGRequest.h"
#import "YZGBatchRequest.h"
#import "YZGListParam.h"
@protocol YZGListModelProtocol <NSObject>

@required
- (void)refreshNewDidSuccess;
- (void)loadMoreDidSuccess;
- (void)didLoadLastPage;
/**
  请求结束后的操作，刷新tableview或关闭动画等。
 */
- (void)handleAfterRequestFinish;
/**
 请求失败后的操作
 */
- (void)handleAfterRequestFaile;

@optional
- (void)didLoadFirstPage;
@end

@interface YZGListModel : NSObject

@property (nonatomic, weak) id<YZGListModelProtocol> delegate;

/**
 参数,若有值,则会覆盖netRequest的requestParam参数
 */
@property (nonatomic , strong) YZGListParam *listParam;
/**
 网络请求
 */
@property (nonatomic,strong) YZGRequest *netRequest;
/**
 多个网络请求的数组,网络请求成功(失败)后,统一处理回调(代理)事件
 如果batchRequests的个数不为0,则netRequest 失效
 */
@property (nonatomic , strong) NSArray< YZGRequest *> *batchRequests;
/**
 如果为是，表示刷新，否则为加载更多。
 */
@property (nonatomic, assign) BOOL isRefresh;
/**
 是否需要加载更多选项
 */
@property (nonatomic, assign) BOOL isNeedLoadMore;

/**
 下拉刷新
 */
- (void)pullDownToRefresh;
/**
 加载更多
 */
- (void)pullUpToLoadMore;
/**
 如果请求出错,若为服务器出错,或者当前网络有问题导致的超时,则为YES
 */
@property (nonatomic, getter=isNetworkError) BOOL networkError;
/**
 netRequest请求获得的模型数组(baseItem及其子类)
 */
@property (nonatomic , strong) NSMutableArray *responseObject;
/**
 处理netRequset请求,从服务器获得的数据,转为模型

 @param responseObject responseObject
 */
-(void)parseServerData:(NSDictionary *)responseObject;
/**
 处理batchRequests请求,从服务器获得的数据,转为模型
 
 @param batchesResponseObject responseObject
 */
-(void)parseBatchServerData:(NSDictionary *)batchesResponseObject;
/**
 初始化

 @param delegate delegate
 @return 返回实例
 */
-(instancetype)initWithDelegate:(id<YZGListModelProtocol>)delegate;

-(void)loadData;
-(void)refreshData;
@end

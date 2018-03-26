//
//  YZGListModel.m
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGListModel.h"
#import "YZGListParam.h"

@interface YZGListModel ()

//limit_begin：从第几条开始取(默认从第0条开始取)
@property (nonatomic , copy) NSString *limit_begin;

//limit_num：需要取几条(默认取20条)
@property (nonatomic , copy) NSString *limit_num;

@end

@implementation YZGListModel

-(instancetype)initWithDelegate:(id<YZGListModelProtocol>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        self.responseObject = [NSMutableArray array];
    }
    return self;
}

-(void)pullDownToRefresh{
    self.limit_begin = @"0";
    self.isRefresh = YES;
    [self loadData];
}

-(void)pullUpToLoadMore{
    int limit_begin = self.limit_begin.intValue;
    limit_begin = limit_begin + 20;
    self.limit_begin= [NSString stringWithFormat:@"%d",limit_begin];
    self.isRefresh = NO;
    [self loadData];
}

-(void)loadData{
    self.networkError = NO;
    [self.responseObject removeAllObjects];
    
    BOOL isHadBatchRequests = self.batchRequests.count>0;
    if (!isHadBatchRequests) {
        [self startNetRequest];
    }else{
        YZGBatchRequest *batchRequest = [[YZGBatchRequest alloc] initWithRequestArray:self.batchRequests];
        [batchRequest startWithCompletionBlockWithSuccess:^(YZGBatchRequest *batchRequest) {
            YZGRequest *request = batchRequest.requestArray[0];
            [self handelBatchServerData:request.responseObject];
        } failure:^(YZGBatchRequest * _Nonnull batchRequest) {
            [self handleError:batchRequest.failedRequest];
        }];
    }
}

- (void)refreshData{
    
    [self pullDownToRefresh];
    
    
}

-(void)handelBatchServerData:(NSDictionary *)responseObject{
    if (responseObject) {
        [self parseBatchServerData:responseObject];
    }
}

-(void)startNetRequest{
    if (self.listParam) {
        self.netRequest.requestParam = self.listParam;
    }
    YZGListParam *listParam = (YZGListParam *)self.netRequest.requestParam;
    listParam.limit_begin = self.limit_begin;
    
     __weak typeof(self) weakSelf = self;
    [self.netRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleServerData:request.responseObject];
    } failure:^(__kindof YZGRequest * _Nonnull request) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleError:request];
    }];
}

-(void)handleServerData:(NSDictionary *)responseObject{
   
    [self parseServerData:responseObject];
    
    if (self.isRefresh && [self.delegate respondsToSelector:@selector(refreshNewDidSuccess)]) {
 
        [self isNeedLoadMoreForRefreshLimit_end:[responseObject[@"limit_end"] integerValue]];
        
        [self.delegate refreshNewDidSuccess];
    }
    else if (!self.isRefresh && [self.delegate respondsToSelector:@selector(loadMoreDidSuccess)]) {
        [self.delegate loadMoreDidSuccess];
    }
    [self.delegate handleAfterRequestFinish];
}
-(void)handleError:(YZGRequest *)request{
    
    self.networkError = request.isNetworkError;
 
    [self.delegate handleAfterRequestFaile];
}

-(void)parseBatchServerData:(NSDictionary *)responseObject{
    //子类可以实现,也可以不实现
}

-(void)parseServerData:(NSDictionary *)responseObject{
    @throw @"You Must implement This Mehtod ";
}

-(void)isNeedLoadMoreForRefreshLimit_end:(NSInteger )limit_end{
    self.isNeedLoadMore = NO;
    self.isNeedLoadMore = limit_end >= 20;
}
@end

//
//  YZGRefreshCollectionController.m
//  sisitv_ios
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGRefreshCollectionController.h"
#import "AlertTool.h"
@interface YZGRefreshCollectionController ()

@end

@implementation YZGRefreshCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createModel];
    self.collectionView.isHadRefreshAction = YES;
}

-(void)createModel{
    @throw @"You Must implement This Mehtod";
}
-(void)requestDidSuccess{
    //子类做实际处理
    @throw @"You Must implement This Mehtod";
}
-(void)configForRequest{
    @throw @"You Must implement This Mehtod";
}
-(void)requestFaileAlert{
    //子类可以不处理,则默认不显示错误信息
    if (!self.listModel.isNetworkError) {
//        NSString *errorString = [self.listModel.netRequest.error localizedDescription];
//        [AlertTool ShowErrorInView:KKeyWindow withTitle:errorString];
    }else{
        [AlertTool Hidden];
    }
}

#pragma mark YZGCollectionViewDelegate方法
-(void)pullDownToRefresh{
    [self configForRequest];
    [self.collectionView yzgResetFooter];
    [self.listModel pullDownToRefresh];
}

-(void)pullUpToLoadMore{
    [self configForRequest];
    [self.listModel pullUpToLoadMore];
}

#pragma mark YZGListModelProtocol方法

-(void)refreshNewDidSuccess{
    if (self.listModel.isNeedLoadMore) {
        self.collectionView.isHadLoadMoreAction = YES;
    }
    [self.dataSource clearAllItems];
    [self requestDidSuccess];
}

-(void)loadMoreDidSuccess{
    [self requestDidSuccess];
}

-(void)didLoadLastPage{
    [self.collectionView endLoadWithNoMoreData];
}

-(void)handleAfterRequestFinish{
    [self removeNodataView];
    [self.collectionView yzgStopRefreshing];
    [self.collectionView reloadData];
}

-(void)handleAfterRequestFaile{
    [self.collectionView yzgStopRefreshing];
    if (self.listModel.isRefresh) {
        [self.dataSource clearAllItems];
        [self.collectionView reloadData];
        [self addNodataViewInView:self.collectionView];
    }else{
        [self.collectionView endLoadWithNoMoreData];
    }
    [self requestFaileAlert];
}


@end

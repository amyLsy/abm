//
//  YZGRefreshTableViewController.m
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGRefreshTableViewController.h"
#import "AlertTool.h"
@interface YZGRefreshTableViewController ()

@end

@implementation YZGRefreshTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self createModel];
    self.tableView.isHadRefreshAction = YES;
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
#pragma mark YZGTableViewDelegate方法
-(void)pullDownToRefresh{
    [self configForRequest];
    [self.tableView yzgResetFooter];;
    [self.listModel pullDownToRefresh];
}

-(void)pullUpToLoadMore{
    [self configForRequest];
    [self.listModel pullUpToLoadMore];
}

#pragma mark YZGListModelProtocol方法

-(void)refreshNewDidSuccess{
    if (self.listModel.isNeedLoadMore) {
        self.tableView.isHadLoadMoreAction = YES;
    }
    [self.dataSource clearAllItems];
    [self requestDidSuccess];
}

-(void)loadMoreDidSuccess{
    [self requestDidSuccess];
}

-(void)didLoadLastPage{
    [self.tableView endLoadWithNoMoreData];
}

-(void)handleAfterRequestFinish{
    [self removeNodataView];
    [self.tableView yzgStopRefreshing];
    [self.tableView reloadData];
}

-(void)handleAfterRequestFaile{
    [self.tableView yzgStopRefreshing];
    if (self.listModel.isRefresh) {
        [self.dataSource clearAllItems];
        [self.tableView reloadData];
        [self addNodataViewInView:self.tableView];
    }else{
        [self.tableView endLoadWithNoMoreData];
    }
    [self requestFaileAlert];
}

@end

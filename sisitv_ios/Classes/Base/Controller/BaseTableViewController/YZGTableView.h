//
//  YZGTableView.h
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGTableViewDataSource.h"


// 这个协议继承了UITableViewDelegate ，所以自己做一层中转，VC 依然需要实现某些代理方法。
@protocol YZGTableViewDelegate<UITableViewDelegate>

@optional

/**  选择一个cell的回调，并返回被选择cell的数据结构和indexPath */
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath*)indexPath;

- (UIView *)headerViewForSectionObject:(YZGTableViewSectionItem *)sectionObject atSection:(NSInteger)section;

// 下拉刷新触发的方法
- (void)pullDownToRefresh;

// 上拉加载触发的方法
- (void)pullUpToLoadMore;

// 将来可以有 cell 的编辑，交换，左滑等回调
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableViewHeaderView:(YZGHeaderView *)headerView scrollToOffset:(CGPoint )offset;
@end

@interface YZGTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<YZGTableViewDataSource> yzgDataSource;

@property (nonatomic, weak) id<YZGTableViewDelegate> yzgDelegate;

// 是否需要下拉刷新和上拉加载
@property (nonatomic, assign) BOOL isHadRefreshAction;
@property (nonatomic, assign) BOOL isHadLoadMoreAction;

- (void)yzgResetFooter;

/**
 停止下拉刷新或者上拉加载
 */
- (void)yzgStopRefreshing;

/**
 开始下拉刷新
 */
- (void)yzgStartRefreshing;

/**
 没有更多了
 */
- (void)endLoadWithNoMoreData;

@end

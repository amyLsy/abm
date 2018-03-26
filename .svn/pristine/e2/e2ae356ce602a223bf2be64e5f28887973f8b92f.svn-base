//
//  YZGTableView.m
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGTableView.h"
#import <MJRefresh/MJRefresh.h>

@interface YZGTableView ()

@property (nonatomic , strong) NSMutableDictionary *headerViewDictionary;

@end

@implementation YZGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle =  UITableViewCellSeparatorStyleNone;
//        self.sectionHeaderHeight = 10;
//        self.sectionFooterHeight = 0;
        self.delegate = self;
        self.isHadRefreshAction = NO;
        self.isHadLoadMoreAction = NO;
    }
    return self;
}

-(void)setYzgDataSource:(id<YZGTableViewDataSource>)yzgDataSource{
    if(_yzgDataSource != yzgDataSource) {
        _yzgDataSource = yzgDataSource;
        self.dataSource = yzgDataSource;
    }
}

#pragma mark - 上拉加载和下拉刷新
- (void)setIsHadRefreshAction:(BOOL)isHadRefreshAction{
    if (_isHadRefreshAction == isHadRefreshAction) {
        return;
    }
    _isHadRefreshAction = isHadRefreshAction;
//    __block typeof(self) weakSelf = self;
    KWeakSelf;
    if (_isHadRefreshAction) {
//        // 设置自动切换透明度(在导航栏下面自动隐藏)
//        header.automaticallyChangeAlpha = YES;
//        // 隐藏时间
//        header.lastUpdatedTimeLabel.hidden = YES;
        // 马上进入刷新状态
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([ws.yzgDelegate respondsToSelector:@selector(pullDownToRefresh)]) {
                [ws.yzgDelegate pullDownToRefresh];
            }
        }];
        self.mj_header = mjHeader;
    }
}

- (void)setIsHadLoadMoreAction:(BOOL)isHadLoadMoreAction
{
    if (_isHadLoadMoreAction == isHadLoadMoreAction) {
        return;
    }
    _isHadLoadMoreAction = isHadLoadMoreAction;
    KWeakSelf;
    if (_isHadLoadMoreAction) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if ([ws.yzgDelegate respondsToSelector:@selector(pullUpToLoadMore)]) {
                [ws.yzgDelegate pullUpToLoadMore];
            }
        }];
    }
}

-(void)yzgResetFooter{
    self.isHadLoadMoreAction = NO;
    if (self.mj_footer) {
        self.mj_footer = nil;
    }
}

//开始刷新
- (void)yzgStartRefreshing{
    [self.mj_header beginRefreshing];
}

//停止刷新
- (void)yzgStopRefreshing{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}

-(void)endLoadWithNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    id<YZGTableViewDataSource> dataSource = (id<YZGTableViewDataSource>)tableView.dataSource;
    id item = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cellClass;
    if ([dataSource respondsToSelector:@selector(tableView:cellClassForItem:)]) {
        cellClass = [ dataSource tableView:tableView cellClassForItem:item];
    }else{
        cellClass = [dataSource tableView:tableView cellClassForSection:indexPath.section];
    }
    CGFloat rowHeight = [cellClass tableView:tableView rowHeightForIndexPath:indexPath];
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YZGTableViewDataSource * dataSource = (YZGTableViewDataSource *)tableView.dataSource;
    id sectionHeaderItem = [[[dataSource sectionItems] objectAtIndex:section] sectionHeaderItem];
    Class cellClass;
    if ([dataSource respondsToSelector:@selector(tableView:cellClassForSection:)]) {
        cellClass = [dataSource tableView:tableView cellClassForSection:section];
    }
    return [cellClass tableView:tableView sectionHeaderHeightForSectionHeaderItem:sectionHeaderItem];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YZGHeaderView *headerView = [self.headerViewDictionary objectForKey:[NSNumber numberWithInteger:section]];
    YZGTableViewDataSource *dataSource = (YZGTableViewDataSource *)tableView.dataSource;
    id sectionHeaderItem = [[[dataSource sectionItems] objectAtIndex:section] headerItem];
    if (!headerView) {
        headerView = [dataSource tableView:tableView sectionHeaderViewForHeaderItem:sectionHeaderItem];
        if(headerView){
            [self.headerViewDictionary setObject:headerView forKey:[NSNumber numberWithInteger:section]];
        }
    }
    [headerView setInfomation:sectionHeaderItem];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.yzgDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.yzgDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else if ([self.yzgDelegate respondsToSelector:@selector(didSelectItem:atIndexPath:)]) {
        id<YZGTableViewDataSource> dataSource = (id<YZGTableViewDataSource>)tableView.dataSource;
        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        [self.yzgDelegate didSelectItem:object atIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.yzgDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [self.yzgDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }else{
        
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    YZGHeaderView *headerView = [self.headerViewDictionary objectForKey:@"headerView"];
    if (headerView) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if ( contentOffsetY < 0) {//向下拖动到,头部保持顶部一直置顶，并垂直放大
            CGRect headerViewframe = self.tableHeaderView.frame;
            CGFloat zoomHeight = - contentOffsetY + headerViewframe.size.height;
            headerViewframe.origin.y = contentOffsetY;
            headerViewframe.size.height = zoomHeight;
            headerView.needAmplificationView.frame = headerViewframe;
        }else{
            return;
        }
    }
}
-(void)reloadData{
    YZGHeaderView *headerView = [self.headerViewDictionary objectForKey:@"headerView"];
    YZGTableViewDataSource *dataSource = (YZGTableViewDataSource *)self.dataSource;
    id headerItem = [dataSource headerItem];
    if (!headerView) {
        headerView = [dataSource headerViewForTableView:self];
        if(headerView){
            [self.headerViewDictionary setObject:headerView forKey:@"headerView"];
            self.tableHeaderView = headerView;
        }
    }
    CGFloat headerHeight = [headerView headerHeightForTableView:self];
    headerView.frame = CGRectMake(headerView.x, headerView.y, headerView.width, headerHeight);
    [headerView setInfomation:headerItem];
    [super reloadData];
}

-(NSMutableDictionary *)headerViewDictionary{
    if (!_headerViewDictionary) {
        _headerViewDictionary = [NSMutableDictionary dictionary];
    }
    return _headerViewDictionary;
}

-(void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
}

@end

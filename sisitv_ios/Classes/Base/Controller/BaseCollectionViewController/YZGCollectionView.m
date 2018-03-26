//
//  YZGCollectionView.m
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGCollectionView.h"
#import <MJRefresh/MJRefresh.h>

@implementation YZGCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.showsVerticalScrollIndicator = YES;
        self.delegate = self;
    }
    return self;}

#pragma mark - 上拉加载和下拉刷新
- (void)setIsHadRefreshAction:(BOOL)isHadRefreshAction{
    if (_isHadRefreshAction == isHadRefreshAction) {
        return;
    }
    _isHadRefreshAction = isHadRefreshAction;
    //    __block typeof(self) weakSelf = self;
    KWeakSelf;
    if (_isHadRefreshAction) {
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
    //    __block typeof(self) weakSelf = self;
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

- (void)yzgTriggerRefreshing{
    [self.mj_header beginRefreshing];
}

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

-(void)setYzgDataSource:(id<YZGCollectionDataSource>)yzgDataSource{
    if(_yzgDataSource != yzgDataSource) {
        _yzgDataSource = yzgDataSource;
        self.dataSource = yzgDataSource;
    }
}

#pragma mark 代理方法
//这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    id<YZGCollectionDataSource> dataSource = (id<YZGCollectionDataSource>)collectionView.dataSource;
    Class cls = [dataSource collectionView:collectionView cellClassForSection:section];
    CGSize headSize = [cls collectionView: collectionView headerSizeForSection:section];
    return headSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.yzgDelegate respondsToSelector:@selector(didSelectItem:atIndexPath:)]) {
        id<YZGCollectionDataSource> dataSource = (id<YZGCollectionDataSource>)collectionView.dataSource;
        id object = [dataSource collectionView:collectionView itemForRowAtIndexPath:indexPath];
        [self.yzgDelegate didSelectItem:object atIndexPath:indexPath];
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else if ([self.yzgDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.yzgDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    
}

#pragma mark - return UICollectionViewDelegateFlowLayout or CustomLayout itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<YZGCollectionDataSource> dataSource = (id<YZGCollectionDataSource>)collectionView.dataSource;
    id item = [dataSource collectionView:collectionView itemForRowAtIndexPath:indexPath];
    Class cls = [dataSource collectionView:collectionView cellClassForItem:item];
    return [cls collectionView: collectionView itemSizeForItem:item];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.yzgDelegate respondsToSelector:@selector(scrollViewScrollToPage:)]) {
        NSInteger currentPage = (scrollView.contentOffset.x / CGRectGetWidth(self.frame));
        [self.yzgDelegate scrollViewScrollToPage:currentPage];
    }
    //        if (currentPage < 0)
    //        {
    //            self.pageControl.currentPage = self.dataSource.count - 1;
    //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //            return;
    //        }
    //        else if (currentPage == self.dataSource.count)
    //        {
    //            self.pageControl.currentPage = 0;
    //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //            return;
    //        }
}

@end

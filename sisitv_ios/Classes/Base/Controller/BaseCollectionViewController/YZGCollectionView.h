//
//  YZGCollectionView.h
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGCollectionDataSource.h"
#import "YZGCollectionViewLayout.h"
#import "YZGCollectionViewFlowLayout.h"

// 这个协议继承了UICollectionViewDelegate ，所以自己做一层中转，VC 依然需要实现某些代理方法。
@protocol YZGCollectionViewDelegate<UICollectionViewDelegate>

@optional

/**  选择一个cell的回调，并返回被选择cell的数据结构和indexPath */
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath*)indexPath;

// 下拉刷新触发的方法
- (void)pullDownToRefresh;

// 上拉加载触发的方法
- (void)pullUpToLoadMore;

// 将来可以有 cell 的编辑，交换，左滑等回调
-(void)scrollViewScrollToPage:(NSInteger )page;

@end


@interface YZGCollectionView : UICollectionView<UICollectionViewDelegate>

@property (nonatomic, weak) id<YZGCollectionDataSource> yzgDataSource;

@property (nonatomic, weak) id<YZGCollectionViewDelegate> yzgDelegate;

// 是否需要下拉刷新和上拉加载
@property (nonatomic, assign) BOOL isHadRefreshAction;
@property (nonatomic, assign) BOOL isHadLoadMoreAction;

//手动触发下拉刷新
- (void)yzgTriggerRefreshing;
//每次下来刷新后重新设置footerView
-(void)yzgResetFooter;
//停止刷新
- (void)yzgStopRefreshing;
/**
 没有更多了
 */
- (void)endLoadWithNoMoreData;
@end

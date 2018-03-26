//
//  PageContentView.m
//  sisitv_ios
//
//  Created by Apple on 17/4/13.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "PageContentView.h"
#import "BaseViewController.h"
#import "MainViewController.h"

static NSString * const ContentCellID = @"ContentCellID";

@interface PageContentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic , strong) NSMutableArray *childVcs;
@property (nonatomic , weak) MainViewController *parentViewController;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , assign) BOOL isForbidScrollDelegate;
@property (nonatomic , assign) CGFloat startOffsetX;

@end

@implementation PageContentView

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSMutableArray *)childVcs parentViewController:(MainViewController *)parentViewController{
    if (self = [super initWithFrame:frame]) {
        self.childVcs = childVcs;
        self.parentViewController = parentViewController;
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    for (BaseViewController *VC in self.childVcs) {
        [self.parentViewController addChildViewController:VC];
    }
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ContentCellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    BaseViewController *VC = self.childVcs[indexPath.row];
    VC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:VC.view];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isForbidScrollDelegate) return;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    NSInteger index = (currentOffsetX / scrollViewW + 0.5);
    if ([self.delegate respondsToSelector:@selector(pageContentViewWithContentView:index:)]) {
        [self.delegate pageContentViewWithContentView:self index:index];
    }
//    CGFloat progress = 0.0;
//    NSInteger sourceIndex = 0;
//    NSInteger targetIndex = 0;
//    
//    CGFloat currentOffsetX = scrollView.contentOffset.x;
//    CGFloat scrollViewW = scrollView.bounds.size.width;
//    if (currentOffsetX > self.startOffsetX) {
//        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
//        sourceIndex = currentOffsetX / scrollViewW;
////        targetIndex = (currentOffsetX / scrollViewW + 0.5);
//        targetIndex = sourceIndex + 1;
//        if (targetIndex >= self.childVcs.count) {
//            targetIndex = self.childVcs.count - 1;
//        }
//        if (currentOffsetX - self.startOffsetX == scrollViewW) {
//            progress = 1;
//            targetIndex = sourceIndex;
//        }
//    }else{
//        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
//        targetIndex = currentOffsetX / scrollViewW;
////        sourceIndex = self.startOffsetX / scrollViewW;
//        sourceIndex = targetIndex + 1;
//        if (sourceIndex >= self.childVcs.count) {
//            sourceIndex = self.childVcs.count - 1;
//        }
//    }
//    NSLog(@"progress----%f----sourceIndex----%ld----targetIndex----%ld",progress, sourceIndex, targetIndex);
//    if ([self.delegate respondsToSelector:@selector(pageContentViewWithContentView:progress:sourceIndex:targetIndex:)]) {
//        //        [self.delegate pageContentViewWithContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
//        [self.delegate pageContentViewWithContentView:self progress:currentOffsetX/scrollViewW sourceIndex:0 targetIndex:0];
//    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    self.isForbidScrollDelegate = YES;
    
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
}


#pragma mark - 懒加载
- (NSMutableArray *)childVcs{
    if (!_childVcs) {
        _childVcs = [NSMutableArray array];
    }
    return _childVcs;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ContentCellID];
    }
    return _collectionView;
}

@end

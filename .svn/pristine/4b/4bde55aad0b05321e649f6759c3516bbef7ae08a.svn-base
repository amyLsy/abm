//
//  CollectionDataSource.m
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGCollectionDataSource.h"


@implementation YZGCollectionDataSource

- (instancetype)initWithSectionItems:(NSArray<YZGCollectionSectionItem *> *)sectionItems
{
    self = [super init];
    if (self) {
        if (sectionItems) {
            self.sectionItems = [[NSMutableArray alloc]initWithArray:sectionItems];
        }else{
            YZGCollectionSectionItem *sectionItem = [[YZGCollectionSectionItem alloc]init];
            [self.sectionItems addObject:sectionItem];
        }
    }
    return self;
}

-(instancetype)initWithController:(UIViewController<NSObject> *)viewController{
    self = [super init];
    if (self) {
        self.sectionItems = [NSMutableArray array];
        self.delegateController = viewController;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionItems = [NSMutableArray array];
    }
    return self;
}

-(void)clearAllItems{
    for (YZGCollectionSectionItem *sectionItem in self.sectionItems) {
        [sectionItem.rowItems  removeAllObjects];
    }
}

-(YZGCollectionRowItem *)collectionView:(UICollectionView *)collectionView itemForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sectionItems.count > indexPath.section) {
        YZGCollectionSectionItem *sectionItem = [self.sectionItems objectAtIndex:indexPath.section];
        if (sectionItem.rowItems.count >indexPath.row) {
            return [sectionItem.rowItems objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

-(Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(id )item{
    return [YZGCollectionCell class];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionItems.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.sectionItems.count >0) {
        YZGCollectionSectionItem * sectionItem = [self.sectionItems objectAtIndex:section];
        return sectionItem.rowItems.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id rowItem = [self collectionView:collectionView itemForRowAtIndexPath:indexPath];
    Class cellClass = [self collectionView:collectionView cellClassForItem:rowItem];
    NSString *className = NSStringFromClass(cellClass);
    YZGCollectionCell *cell = (YZGCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    [cell setItem:rowItem forIndexPath:indexPath];
    if (cell) {
        
        if (self.delegateController) {
            cell.delegate = self.delegateController;
        }else{
            YZGLog(@"not set delegateController!!!!!!!!!");
        }
    }
    return cell;
}


-(Class)collectionView:(UICollectionView *)collectionView cellClassForSection:(NSInteger )section{
    return [YZGCollectionCell class];
}

//获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YZGCollectionReusableView" forIndexPath:indexPath];
    id sectionItem = [self.sectionItems objectAtIndex:indexPath.section];
    UIView *headerView = [self collectionView:collectionView headerViewForHeaderItem: [sectionItem headerItem]];
    [headerView removeFromSuperview];
    headerView.frame =  reusableView.bounds;
    [reusableView addSubview: headerView];
    return reusableView;
}

@end

//
//  CollectionDataSource.h
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZGCollectionSectionItem.h"
#import "YZGCollectionCell.h"
#import "YZGTableViewCellDelegate.h"
//#import "YZGCollectionReusableView.h"
@protocol YZGCollectionDataSource <UICollectionViewDataSource,YZGTableViewCellDelegate>

@optional

- (YZGCollectionRowItem *)collectionView:(UICollectionView *)collectionView itemForRowAtIndexPath:(NSIndexPath *)indexPath;

-(Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(id)item;

-(Class)collectionView:(UICollectionView *)collectionView cellClassForSection:(NSInteger )section;

-(UIView *)collectionView:(UICollectionView *)collectionView headerViewForHeaderItem:(id)headerItem;

@end

@interface YZGCollectionDataSource : NSObject<YZGCollectionDataSource>

@property (nonatomic , strong) NSMutableArray *sectionItems;

@property (nonatomic , weak) UIViewController<NSObject> *delegateController;

-(instancetype)initWithController:(UIViewController<NSObject> *)viewController;

-(void)clearAllItems;

@end

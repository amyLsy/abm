//
//  YZGCollectionCell.h
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGCollectionRowItem.h"
#import "YZGTableViewCellDelegate.h"

@interface YZGCollectionCell : UICollectionViewCell


@property (nonatomic , weak) id<YZGTableViewCellDelegate> delegate;

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath;


+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id )item;


+(CGSize)collectionView:(UICollectionView *)collectionView headerSizeForSection:(NSInteger )section;

@end

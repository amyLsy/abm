//
//  MainNewSepCollectionCell.m
//  xiuPai
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MainNewSepCollectionCell.h"

@implementation MainNewSepCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id )item{
    return CGSizeMake(KScreenWidth , 1);
}
@end

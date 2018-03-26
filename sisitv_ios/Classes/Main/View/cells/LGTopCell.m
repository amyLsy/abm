//
//  LGTopCell.m
//  sisitv_ios
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGTopCell.h"

@implementation LGTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    _termsTypeView.typeStrArray = item;
    
}

+ (CGSize)collectionView:(UICollectionView *)collectionView headerSizeForSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 0);//lsy
}

+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    return CGSizeMake(KScreenWidth , 36);//lsy
}
@end

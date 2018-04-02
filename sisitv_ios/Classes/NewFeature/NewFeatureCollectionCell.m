//
//  NewFeatureCollectionCell.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "NewFeatureCollectionCell.h"

@interface NewFeatureCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *feature;

@end

@implementation NewFeatureCollectionCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    NewFeatureRowItem *rowItem = ( NewFeatureRowItem *)item;
    self.feature.image = [UIImage imageNamed:rowItem.imageName];
    //启动滚动页图片 lsy
    self.feature.contentMode = UIViewContentModeScaleToFill;
}
+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id )item{
    return CGSizeMake(KScreenWidth, KScreenHeight);
}


@end

//
//  GiftCell.m
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "GiftCell.h"
#import "MYGiftModel.h"

@implementation GiftCell


+ (CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    
    CGFloat width = (KScreenWidth - 1) * 0.5;
    CGSize size = CGSizeMake(width, width + 50);
    
    return size;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.statusBgView.layer.cornerRadius = self.statusBgView.height * 0.5;
    self.statusBgView.layer.masksToBounds = YES;
    
}


- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    MYGiftModel *model = (MYGiftModel *)item;
    
    [self.giftImage sd_setImageWithURL:[NSURL URLWithString:model.gifticon]];
    [self.giftName setTitle:model.giftname forState:UIControlStateNormal];
    //0 未兑换 1  待发货  2 已发货  3完成
    if ([model.status integerValue] == 0) {
        self.stateLabel.text = @"未兑换";
    }else if([model.status integerValue] == 1){
        self.stateLabel.text = @"待发货";
    }else if([model.status integerValue] == 2){
        self.stateLabel.text = @"已发货";
    }else{
        self.stateLabel.text = @"完成";
    }
    
    
    
}

@end

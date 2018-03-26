//
//  GameGiftListCell.m
//  sisitv_ios
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "GameGiftListCell.h"
#import "GameModelList.h"

@implementation GameGiftListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    RankPresentModel *rankItem = (RankPresentModel *)item;

    [self.gitIcon sd_setImageWithURL:[NSURL URLWithString:rankItem.gifticon]];
    self.giftName.text = rankItem.giftname;
    self.rank.text = [NSString stringWithFormat:@"奖励名次:游戏排名第%@名",rankItem.rank];
    self.needCoine.text = [NSString stringWithFormat:@"价值:%@活力",rankItem.needcoin];
    
    
}


@end

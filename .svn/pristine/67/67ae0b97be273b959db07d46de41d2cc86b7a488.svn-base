//
//  GiftListInvitaView.m
//  sisitv_ios
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "GiftListInvitaView.h"


@interface GiftListInvitaView()



@end


@implementation GiftListInvitaView


- (void)awakeFromNib{

    [super awakeFromNib];
    self.giftListView = [LGSelectGameView viewFromeNib];
    self.giftListView.backButton.hidden = YES;
    self.giftListView.titleLabel.text = @"当前游戏奖励说明";
    self.giftListView.frame = self.giftListBgView.bounds;
    
    [self.giftListBgView addSubview:self.giftListView];
    
}

- (void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    
    self.giftListView.dataArray = dataArray;
    
    
}


- (IBAction)cancel:(id)sender {
    
    if (_joinBlock) {
        _joinBlock(NO);
    }
    
}
- (IBAction)join:(id)sender {
    
    if (_joinBlock) {
        _joinBlock(YES);
    }
}
- (IBAction)cancelListViewButton:(id)sender {
    
    self.hidden = YES;
}


@end

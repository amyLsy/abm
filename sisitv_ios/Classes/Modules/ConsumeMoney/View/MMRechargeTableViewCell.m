//
//  MMRechargeTableViewCell.m
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MMRechargeTableViewCell.h"

@interface MMRechargeTableViewCell()

@end

@implementation MMRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectedBtnAction:(id)sender {
    UIButton *btn = sender;
    if (_btnAction) {
        _btnAction(btn.tag);
    }
}

@end

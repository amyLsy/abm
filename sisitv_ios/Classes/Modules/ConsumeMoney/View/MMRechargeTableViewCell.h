//
//  MMRechargeTableViewCell.h
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBtnAction)(NSInteger selectIndex);

@interface MMRechargeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *rechargeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (copy, nonatomic) SelectBtnAction btnAction;

@end

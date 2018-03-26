//
//  GiftCell.h
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionCell.h"

@interface GiftCell : YZGCollectionCell
@property (weak, nonatomic) IBOutlet UIView *statusBgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UIButton *giftName;

@end

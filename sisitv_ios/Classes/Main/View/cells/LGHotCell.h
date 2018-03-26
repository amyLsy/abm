//
//  LGHotCell.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/8.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionCell.h"

@interface LGHotCell : YZGCollectionCell
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *avtar ;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location ;
@property (weak, nonatomic) IBOutlet UILabel *people;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelHeightCons;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIView *gimeTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *gameTimeLabel;



@end

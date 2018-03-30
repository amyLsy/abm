//
//  RankTitleView.m
//  xiuPai
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "RankTitleView.h"

@interface RankTitleView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *xibButtonArray;

@end
@implementation RankTitleView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self layoutSubviews];
    self.buttonArray = self.xibButtonArray;
//    self.selectedColor = RGBToColor(158, 128, 120);
    self.selectedColor = rgba(158, 128, 120, 1);
}

@end

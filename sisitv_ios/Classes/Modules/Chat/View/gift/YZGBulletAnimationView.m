//
//  YZGBulletAnimationView.m
//  xiuPai
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGBulletAnimationView.h"
#import "UIImageView+Rouding.h"



@interface YZGBulletAnimationView ()
 
@end

@implementation YZGBulletAnimationView

+(instancetype)bulletAnimationView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.avatar roundingImage];
}
-(void)dealloc{
    YZGLog(@"%@",self);
}

@end

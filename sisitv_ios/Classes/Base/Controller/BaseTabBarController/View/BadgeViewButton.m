//
//  BadgeViewButton.m
//  JLZhiBo
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BadgeViewButton.h"


#define BadgeViewFont [UIFont systemFontOfSize:10]



@implementation BadgeViewButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        // 设置字体大小
        self.titleLabel.font = BadgeViewFont;
        
        
        [self sizeToFit];
        
    }
    
    return self;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    if (badgeValue.length ==0 || [badgeValue integerValue] <=0)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
    }
    CGSize size;
//    
//    if (([NSString respondsToSelector:@selector(sizeWithFont:)])||([UIDevice currentDevice].systemVersion.floatValue<8.0))
//    {
//        size = [badgeValue sizeWithFont:BadgeViewFont];
//    }
//    else
//    {
//        
        size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:BadgeViewFont}];
//    }
    
    
    if (size.width > self.width) { // 文字的尺寸大于控件的宽度
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
    
    
}

@end

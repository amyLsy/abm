//
//  UIView+Frame.m
//  
//
//  Created by apple on 15-3-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)setYzgCenterX:(CGFloat)yzgCenterX{
    CGPoint center = self.center;
    center.x = yzgCenterX;
    self.center = center;
}
-(CGFloat)yzgCenterX{
    return self.center.x;
}
-(void)setYzgCenterY:(CGFloat)yzgCenterY{
    
    CGPoint center = self.center;
    center.y = yzgCenterY;
    self.center = center;
}
-(CGFloat)yzgCenterY{
    return self.center.y;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

+(instancetype)viewFromeNib{
    
    
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
}
@end

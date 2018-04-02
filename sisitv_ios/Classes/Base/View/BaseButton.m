//
//  BaseButton.m
//  sisitv
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseButton.h"

@interface BaseButton()

@property (nonatomic , assign) BOOL titleBlowImageView;

@property (nonatomic , assign) BOOL titleAtImageViewLeft;


@end

@implementation BaseButton


-(void)adjustTitleBlowImageView{
    self.titleBlowImageView = YES;
}

-(void)adjustTitleAtImageViewLeft{
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self layoutIfNeeded];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,self.titleLabel.width, 0, -self.titleLabel.width)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-self.imageView.width-1.0, 0, self.imageView.width)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.titleBlowImageView) {
        //1.imageView
        CGFloat imageW = self.imageView.width;
        CGFloat imageX = (self.width - self.imageView.width)/2.0;
        CGFloat imageY = 0;
        CGFloat imageH = self.imageView.height;
        self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        // 2.title
        CGFloat titleW = self.width;
        CGFloat titleX = (self.width - self.titleLabel.width)/2.0;
        CGFloat titleY = imageH + 3;
        CGFloat titleH = self.titleLabel.height;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
        self.titleLabel.numberOfLines = 0;
    }
}

@end

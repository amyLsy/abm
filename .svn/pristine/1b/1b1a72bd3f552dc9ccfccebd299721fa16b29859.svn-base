//
//  TabBar.h
//  JLZhiBo
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGTabBar,TabBarButton;

@protocol YZGTabBarDelegate <NSObject>

@optional

-(void)yzgTabBar:(YZGTabBar *)tabBar didClickCenterButton:(UIButton *)button;
-(void)yzgTabBar:(YZGTabBar *)tabBar didClickCzButton:(UIButton *)button;
-(void)yzgTabBar:(YZGTabBar *)tabBar didClickDhButton:(UIButton *)button;

@end


@interface YZGTabBar : UITabBar

@property (nonatomic , weak) id<YZGTabBarDelegate> yzgDelegate;

@end

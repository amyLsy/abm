//
//  RootTool.h
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "YZGSingleton.h"

@class RootTool;

@protocol RootToolDelegate <NSObject>


/**
 登录成功,或者本地的token刷新token成功

 @param rootTool rootTool
 */
-(void)rootToolLoginSuccess:(RootTool*)rootTool;
/**
 退出登录成功,或者刷新token成功
 
 @param rootTool rootTool
 */
-(void)rootToolExitSuccess:(RootTool*)rootTool;

@end

@interface RootTool : YZGSingleton

@property (nonatomic , strong) UIWindow *rootWindow;

@property (nonatomic , weak) id<RootToolDelegate> delegate;

/**
 根据是否已经登录,选择根控制器
 */
-(void)chooseRootController;

/**
 根据是否有缓存的广告图片选择进入广告页面
 
 @param ti 广告时间
 @param disappearHandler 广告界面消失回调
 */
-(void)showAdvertWithTimeInterval:(NSTimeInterval)ti disappearHandler:(void(^)(void))disappearHandler;

@end

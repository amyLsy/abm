//
//  UIView+ViewController.h
//  UI09-task-04
//
//  Created by keyZhang on 14-5-14.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)

- (UIViewController *)viewController;

// 获取当前屏幕显示的viewcontroller
- (UIViewController *)topViewController;

@end

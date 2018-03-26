//
//  UIView+ViewController.m
//  UI09-task-04
//
//  Created by keyZhang on 14-5-14.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    do {
        //判断响应者对象是否为视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
}

// 获取当前屏幕显示的viewcontroller
- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController)
    {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else
    {
        return vc;
    }
    return nil;
}

@end

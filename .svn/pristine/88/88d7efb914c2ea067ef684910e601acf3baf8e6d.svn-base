//
//  BaseNavgationController.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseNavgationController.h"
#import "SisiConversationListController.h"
@interface BaseNavgationController ()

@end

@implementation BaseNavgationController

+ (void)initialize
{
    if (self == [BaseNavgationController class]) {
        
        UINavigationBar *bar = [UINavigationBar appearance];
        [bar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
//        [bar setShadowImage:[[UIImage alloc]init]];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count>0 && self.yzgDefaultInteractive) {
        [self.view removeGestureRecognizer:self.yzgDefaultInteractive];
    }
    
    if (self.childViewControllers.count)
    { // 隐藏底部导航栏
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 2 && self.yzgDefaultInteractive) {
        [self.view addGestureRecognizer:self.yzgDefaultInteractive];
    }
    return [super popViewControllerAnimated:animated];
}
- (void)back
{
    // 判断两种情况: push 和 present
//    if ((self.presentedViewController || self.presentingViewController) )
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else
        [self popViewControllerAnimated:YES];
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{

    if (self.presentedViewController)
    {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

-(void)dealloc{
    YZGLog(@"%@",self);
}
@end

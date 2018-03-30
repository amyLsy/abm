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
        // 自定义返回按钮  lsy
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        bgView.backgroundColor = [UIColor redColor];
//        [bgView sizeToFit];
        UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回箭头"]];
        [bgView addSubview:backImgView];
//        backImgView.frame = CGRectMake(0, 0, 40, 40);
        [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView);
            make.left.mas_equalTo(bgView);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
//        [backImgView sizeToFit];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        [bgView addSubview:btn];
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

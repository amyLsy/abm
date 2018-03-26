//
//  BaseViewController.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavgationController.h"
#import "YZGDefaultTransitionAnimator.h"
#import "YZGDefaultInteractiveTransition.h"
#import "NoDataView.h"

@interface BaseViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic , weak) NoDataView *noDataView;


@property (nonatomic , strong) id<UIViewControllerAnimatedTransitioning> customAnimatedTransitioning;

@property (nonatomic , strong) YZGDefaultTransitionAnimator *defaultAnimatedTransitioning;

@property (nonatomic , strong) YZGDefaultInteractiveTransition *defaultInteractiveTransition;

@property (nonatomic , weak) UIViewController *yzgPresentedController;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.needInteractive = YES;
    self.view.backgroundColor = RGB_COLOR(250,250,250,1);
}

-(UIView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _noNetView.backgroundColor = [UIColor greenColor];
    }
    return _noNetView;
}

-(NoDataView *)noDataView{
    if (!_noDataView) {
        NoDataView *noDataView = [NoDataView noDataView];
        _noDataView = noDataView;
    }
    return _noDataView;
 
}
-(void)addNodataViewInView:(UIView *)view{
    [self addNodataViewInView:view withNodataString:nil];
}

-(void)addNodataViewInView:(UIView *)view withNodataString:(NSString *)string{
    [self noDataInView:view withNoDataImageName:nil withNoDataString:string];
}

-(void)noDataInView:(UIView *)view withNoDataImageName:(NSString *)imageName withNoDataString:(NSString *)string{
    [view layoutIfNeeded];
    self.noDataView.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    if (imageName) {
        self.noDataView.imageName = imageName;
    }
    
    [view addSubview:self.noDataView];
    [view bringSubviewToFront:self.noDataView];
}

-(void)removeNodataView{
    [self.noDataView removeFromSuperview];
}


-(void)presentNeedNavgation:(BOOL)need presentendViewController:(UIViewController *)viewControllerToPresent{
    
    [self presentNeedNavgation:need hadLeftBackButton:NO presentendViewController:viewControllerToPresent];
    
}

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had presentendViewController:(UIViewController *)viewControllerToPresent{
    
    [self presentNeedNavgation:need hadLeftBackButton:had isCustomPresentStyle:NO presentendViewController:viewControllerToPresent];
}

-(void)customPresentWithCustomAnimatedTransitioning:(id<UIViewControllerAnimatedTransitioning>)customAnimatedTransitioning presentendViewController:(UIViewController *)viewControllerToPresent{
    [self presentNeedNavgation:NO hadLeftBackButton:NO isCustomPresentStyle:YES customAnimatedTransitioning:customAnimatedTransitioning presentendViewController:viewControllerToPresent];
}

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had isCustomPresentStyle:(BOOL)isCoustomStyle presentendViewController:(UIViewController *)viewControllerToPresent{
   
    [self presentNeedNavgation:need hadLeftBackButton:had isCustomPresentStyle:isCoustomStyle customAnimatedTransitioning:nil presentendViewController:viewControllerToPresent];
}

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had isCustomPresentStyle:(BOOL)isCoustomStyle customAnimatedTransitioning:(id<UIViewControllerAnimatedTransitioning>)customAnimatedTransitioning presentendViewController:(UIViewController *)viewControllerToPresent{
    self.yzgPresentedController = viewControllerToPresent;
    if (need) {
        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:viewControllerToPresent];
        if (had){
            // 定义返回按钮
            UIButton *backButton = [[UIButton alloc] init];
            [backButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [backButton sizeToFit];
            viewControllerToPresent.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
        [self configPresentedController:nav isCustomPresentStyle:isCoustomStyle customAnimatedTransitioning:customAnimatedTransitioning];
    }else{
        [self configPresentedController:viewControllerToPresent isCustomPresentStyle:isCoustomStyle customAnimatedTransitioning:customAnimatedTransitioning];
    }
}

-(void)configPresentedController:(UIViewController *)viewControllerToPresent isCustomPresentStyle:(BOOL)isCustom customAnimatedTransitioning:(id<UIViewControllerAnimatedTransitioning>)customAnimatedTransitioning{
    if (isCustom) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    }else{
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    viewControllerToPresent.transitioningDelegate =  self;
    
    if ([viewControllerToPresent isKindOfClass:[BaseViewController class]]) {
        BaseViewController *viewController = (BaseViewController *)viewControllerToPresent;
        if (viewController.needInteractive) {
            [self.defaultInteractiveTransition addInteractiveToViewController:viewControllerToPresent];
        }
    }else if (self.needInteractive) {
        [self.defaultInteractiveTransition addInteractiveToViewController:viewControllerToPresent];
    }
    
    self.customAnimatedTransitioning = customAnimatedTransitioning;
    
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

-(void)back{
    if ([self.yzgPresentedController isKindOfClass:[BaseViewController class]]) {
        BaseViewController * yzgPresentedController = (BaseViewController *)self.yzgPresentedController;
        if (yzgPresentedController.yzgDismissToPresenting) {
            yzgPresentedController.yzgDismissToPresenting();
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

//转场代理对象协议
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (self.customAnimatedTransitioning) {
        return self.customAnimatedTransitioning;
    }else{
        return self.defaultAnimatedTransitioning;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.customAnimatedTransitioning) {
        return self.customAnimatedTransitioning;
    }else{
        return self.defaultAnimatedTransitioning;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.needInteractive) {
        return self.defaultInteractiveTransition.interacting ? self.defaultInteractiveTransition : nil;
    }else{
        return nil;
    }
}


-(YZGDefaultInteractiveTransition *)defaultInteractiveTransition{
    if (!_defaultInteractiveTransition) {
        _defaultInteractiveTransition = [[YZGDefaultInteractiveTransition alloc] init];
    }
    return _defaultInteractiveTransition;
}

-(YZGDefaultTransitionAnimator *)defaultAnimatedTransitioning
{
    if (!_defaultAnimatedTransitioning)
    {
        _defaultAnimatedTransitioning = [[YZGDefaultTransitionAnimator alloc]init];
    }
    return _defaultAnimatedTransitioning;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)dealloc{
    [self.view endEditing:YES];
    self.customAnimatedTransitioning = nil;
    NSLog(@"%@--%@",self,NSStringFromSelector(_cmd));
}

@end

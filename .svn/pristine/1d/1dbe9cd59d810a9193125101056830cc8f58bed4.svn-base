//
//  BaseViewController.h
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic , strong) UIView *noNetView;

-(void)addNodataViewInView:(UIView *)view;

-(void)addNodataViewInView:(UIView *)view withNodataString:(NSString *)string;

-(void)noDataInView:(UIView *)view withNoDataImageName:(NSString *)imageName withNoDataString:(NSString *)string;

-(void)removeNodataView;

/**
 *如果是present出去的视图,如果modalPresentationStyle = UIModalPresentationCustom,
 *则dismiss时,前一个页面的viewWillApear不会调用,因为这个模式,仍然会显示Presentating页面(也就是前一个页面);
 *所以调用次block代替,来做想要在viewWillApear做的事情
 */
@property (nonatomic , copy) void(^yzgDismissToPresenting)(void);

/**
 *PRESENT后,是否需要手势返回操作
 *默认YES
 */
@property (nonatomic , assign) BOOL needInteractive;

-(void)presentNeedNavgation:(BOOL)need presentendViewController:(UIViewController *)viewControllerToPresent;

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had presentendViewController:(UIViewController *)viewControllerToPresent;

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had isCustomPresentStyle:(BOOL)isCoustomStyle presentendViewController:(UIViewController *)viewControllerToPresent;

-(void)customPresentWithCustomAnimatedTransitioning:(id<UIViewControllerAnimatedTransitioning>)customAnimatedTransitioning presentendViewController:(UIViewController *)viewControllerToPresent;

-(void)presentNeedNavgation:(BOOL)need hadLeftBackButton:(BOOL)had isCustomPresentStyle:(BOOL)isCoustomStyle customAnimatedTransitioning:(id<UIViewControllerAnimatedTransitioning>)customAnimatedTransitioning presentendViewController:(UIViewController *)viewControllerToPresent;
- (void)back;
@end

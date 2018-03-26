//
//  CrossPresent.m
//  xiuPai
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGCustomCrossPresent.h"

@implementation YZGCustomCrossPresent
//动画

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView addSubview:toView];
    BOOL wasCancelled = [transitionContext transitionWasCancelled];
    [transitionContext completeTransition:!wasCancelled];
}

-(void)dealloc{
    NSLog(@"%@--%@",self,NSStringFromSelector(_cmd));
}

@end

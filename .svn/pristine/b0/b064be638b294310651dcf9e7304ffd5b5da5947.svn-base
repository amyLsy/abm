//
//  YZGDefaultInteractiveTransition.m
//  testPresent
//
//  Created by apple on 17/1/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGDefaultInteractiveTransition.h"
#import "BaseNavgationController.h"
@interface YZGDefaultInteractiveTransition ()

@property (nonatomic, weak) UIViewController *presentendController;

@property (nonatomic, assign) BOOL shouldComplete;

@end

@implementation YZGDefaultInteractiveTransition

-(void)addInteractiveToViewController:(UIViewController *)prestendViewController{
    
    self.presentendController = prestendViewController;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [prestendViewController.view addGestureRecognizer:gesture];
    if ([prestendViewController isKindOfClass:[BaseNavgationController class]]) {
        BaseNavgationController *nav = (BaseNavgationController*)prestendViewController;
        nav.yzgDefaultInteractive = gesture;
    }
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            self.interacting = YES;
            [self.presentendController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. Calculate the percentage of guesture
            CGFloat fraction = translation.x /CGRectGetWidth(gestureRecognizer.view.superview.frame);
            //Limit it between 0 and 1
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.5);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.interacting = NO;
            // 3. Gesture over. Check if the transition should happen or not
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}
-(void)dealloc{
    YZGLog(@"%@--%@",self,NSStringFromSelector(_cmd));
}
@end

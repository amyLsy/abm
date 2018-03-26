//
//  AlertTool.m
//  liveFrame
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlertTool.h"
#import "MBProgressHUD.h"

@interface AlertTool ()

@end
static MBProgressHUD  *hud;
@implementation AlertTool

+(void)ShowInView:(UIView *)view{
    [self ShowInView:view withTitle:nil];
}
+(void)ShowInView:(UIView *)view withTitle:(NSString *)title
{
    [self ShowInView:view withMode:MBProgressHUDModeIndeterminate withTitle:title];
}

+(void)ShowInView:(UIView *)view onlyWithTitle:(NSString *)title hiddenAfter:(NSInteger)delety{
    [self ShowInView:view withMode:MBProgressHUDModeText withTitle:title];
    [self HiddenAfterDelyte:delety];
}

+(void)ShowErrorInView:(UIView *)view withTitle:(NSString *)title{
    [self ShowInView:view withMode:MBProgressHUDModeText withTitle:title];
    [self HiddenAfterDelyte:1.0];
}

+(void)showWithCustomModeInView:(UIView *)view {
    [self showWithCustomModeInView:view withTitle:nil];
}
+(void)showWithCustomModeInView:(UIView *)view withTitle:(NSString *)title{
    [self ShowInView:view withMode:MBProgressHUDModeIndeterminate withTitle:title];
}

+(void)ShowInView:(UIView *)view withMode:(MBProgressHUDMode)hudMode withTitle:(NSString *)title
{
    [hud removeFromSuperview];
    hud = nil;
    if (!view) return;
    hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    hud.mode = hudMode;
//    if (hudMode == MBProgressHUDModeCustomView) {
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSInteger i =1; i<2; i++) {
////            NSString *imageString = [NSString stringWithFormat:@"sf_progress_%lu",i];
//            NSString *imageString = [NSString stringWithFormat:@""];
//            [arr addObject:[UIImage imageNamed:imageString]];
//        }
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        imageView.animationImages  = arr;
//        imageView.animationDuration = 1.0;
//        imageView.animationRepeatCount = 0;
//        [imageView startAnimating];
//        hud.customView = imageView;
//        hud.color = [UIColor clearColor];
//    }else{
        hud.customView = nil;
//    }
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

+(void)Hidden{
    [self HiddenAfterDelyte:0.0];
}
+(void)HiddenAfterDelyte:(NSTimeInterval)delyte
{
    [hud hide:YES afterDelay:delyte];
    hud = nil;
}
+(void)HiddenAfterDelyte:(NSTimeInterval)delyte withTitle:(NSString *)title{
    
}

+(UIAlertController *)alertWithControllerTitle:(NSString *)title alertMessage:(NSString *)alertMessage withActionTitle:(NSString *)alertTitle handler:(void (^)(UIAlertAction * _Nullable))handler
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:alertTitle style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    return alertController;
}


//有取消按钮的
+(UIAlertController *)alertWithControllerTitle:(NSString *)title alertMessage:(NSString *)alertMessage preferredStyle:(UIAlertControllerStyle )preferredStyle  confirmHandler:(void(^)(UIAlertAction *))confirmHandler cancleHandler:(void(^)(UIAlertAction *))cancleHandler viewController:(UIViewController *)fromController
{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:alertMessage preferredStyle:preferredStyle];
    
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmHandler];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    [fromController presentViewController:alertController animated:YES completion:nil];
    return alertController;
    
}
+(void)alertWithTitle:(NSString *)title message:(NSString *)message callbackBlock:(AlertToolCallBack)block cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle needTextFiled:(BOOL)need presentingController:(UIViewController *)presentingController otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (need) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
    }
    __weak typeof(alertController) weakAlertController= alertController;
    //添加取消按钮
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            !need ?block(0,nil) :block(0,weakAlertController.textFields.firstObject);
        }];
        [alertController addAction:cancelAction];
    }
    if (destructiveTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (cancelTitle) {
                !need ?block(1,nil) :block(1,weakAlertController.textFields.firstObject);
            }else {
                !need ?block(0,nil) :block(0,weakAlertController.textFields.firstObject);
            }
        }];
        [alertController addAction:destructiveAction];
    }
    if (otherButtonTitles)
    {
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (!cancelTitle && !destructiveTitle) {
                !need ?block(0,nil) :block(0,weakAlertController.textFields.firstObject);
            }
            else if ((cancelTitle && !destructiveTitle) || (!cancelTitle && destructiveTitle)) {
                !need ?block(1,nil) :block(1,weakAlertController.textFields.firstObject);
            }
            else if (cancelTitle && destructiveTitle) {
                !need ?block(2,nil) :block(2,weakAlertController.textFields.firstObject);
            }
        }];
        [alertController addAction:otherActions];
        
        va_list args;//定义一个指向个数可变的参数列表指针;
        va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
        NSString *title = nil;
        
        int count = 2;
        if (!cancelTitle && !destructiveTitle) {
            count = 0;
        }
        else if ((cancelTitle && !destructiveTitle) || (!cancelTitle && destructiveTitle)) {
            count = 1;
        }
        else if (cancelTitle && destructiveTitle) {
            count = 2;
        }
        while ((title = va_arg(args, NSString *)))//指向下一个参数地址
        {
            count ++;
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                !need ?block(count,nil) :block(count,weakAlertController.textFields.firstObject);
            }];
            [alertController addAction:otherAction];
        }
        va_end(args);//置空指针
    }
    [presentingController presentViewController:alertController animated:YES completion:nil];
}
@end

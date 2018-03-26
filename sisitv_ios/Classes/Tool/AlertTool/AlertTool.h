//
//  AlertTool.h
//  liveFrame
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  回调block
 */
typedef void (^AlertToolCallBack) (NSInteger index ,UITextField * __nullable textField);

@interface AlertTool : NSObject

+(void)ShowInView:(UIView *_Nonnull)view;

+(void)ShowInView:(UIView *_Nonnull)view withTitle:(NSString *_Nullable)title;

+(void)ShowInView:(UIView *_Nonnull)view onlyWithTitle:(NSString *_Nonnull)title hiddenAfter:(NSInteger)delety;

+(void)ShowErrorInView:(UIView *_Nonnull)view withTitle:(NSString *_Nonnull)title;

+(void)showWithCustomModeInView:(UIView * _Nonnull)view;

+(void)showWithCustomModeInView:(UIView *_Nonnull)view withTitle:(NSString *__nullable)title;

+(void)Hidden;

+(void)HiddenAfterDelyte:(NSTimeInterval)delyte;


+(UIAlertController * _Nullable )alertWithControllerTitle:(NSString * __nullable)title alertMessage:(NSString *__nullable)alertMessage withActionTitle:(NSString *__nullable)alertTitle handler:(void (^ __nullable)(UIAlertAction * __nullable action))handler;

+(UIAlertController *_Nullable)alertWithControllerTitle:(NSString *__nullable)title alertMessage:(NSString *__nullable)alertMessage preferredStyle:(UIAlertControllerStyle )preferredStyle  confirmHandler:(void(^__nullable)(UIAlertAction *__nullable action))confirmHandler cancleHandler:(void(^__nullable)(UIAlertAction *__nullable action))cancleHandler viewController:(UIViewController *__nullable)fromController;


/**
 普通alert定义alertController

 @param title 标题
 @param message 详细信息
 @param block 用于执行方法的回调block
 @param cancelTitle 取消按钮
 @param destructiveTitle alertController的特殊按钮类型
 @param need 是否需要textFiled
 @param presentingController 当前视图，alertController模态弹出的指针
 @param otherButtonTitles 其他按钮 变参量 但是按钮类型的相对位置是固定的
 
 NS_REQUIRES_NIL_TERMINATION 是一个宏，用于编译时非nil结尾的检查 自动添加结尾的nil
 ***注意1***
 block方法序列号和按钮名称相同，按钮类型排列顺序固定
 如果取消为nil，则index0为特殊，以此往后类推，以第一个有效按钮为0开始累加
 取消有的话默认为0
 
 */
+ (void)alertWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message callbackBlock:(__nullable AlertToolCallBack)block cancelButtonTitle:(NSString *__nullable)cancelTitle destructiveButtonTitle:(NSString *__nullable)destructiveTitle needTextFiled:(BOOL)need presentingController:(UIViewController *__nullable)presentingController otherButtonTitles:(NSString *__nullable)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end

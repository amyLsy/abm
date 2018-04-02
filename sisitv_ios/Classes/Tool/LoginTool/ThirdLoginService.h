//
//  ThirdLoginService.h
//  sisitv_ios
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>



@class ShareParam;
@interface ThirdLoginService : NSObject

+(instancetype)sharedInstance;

/**
 微信登录

 @param userParam 回参，用户信息
 @return NO：用户未安装微信
 */
-(BOOL)wechatLogin:(void(^)(BOOL success, ShareParam *reqParam))userParam;

/**
 QQ登录

 @param userParam 回参，用户信息
 */
- (void)qqlogin:(void(^)(BOOL success, ShareParam *reqParam))userParam;


/**
 此方法必须要在AppDelegate的openURL方法中实现
 
 @param url AppDelegate的openURL方法中
 @return 处理结果
 */
-(BOOL)handleOpenURL:(NSURL *)url;

@end

//
//  Account.h
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "BaseUser.h"
#import "AccountParam.h"

@interface Account : BaseUser

+ (Account *)isLogined;

+(void)storeAccount;

+(void)firstRegister;

+(void)removeAccount;

+(void)changeAccountTableValue:(NSString *)value forKey:(NSString *)key;


+(Account *)shareInstance;

-(void)loginWithParam:(AccountParam *)param success:(requestSuccess)success ;

-(void)regeistWithParam:(AccountParam *)param success:(requestSuccess)success ;

-(void)forgetPasswordWithParam:(AccountParam *)param success:(requestSuccess)success ;


-(void)changePasswordWithParam:(AccountParam *)param success:(requestSuccess)success ;
/**
 * 获取验证码
 */
-(void)getVarcodeWithParam:(AccountParam *)param success:(requestSuccess)success ;

/**
 * 关注或者取消关注
 */
-(void)attentionOrCancelAttentionWithCurrentButtonTitle:(NSString *)buttonTitle WithParam:(AccountParam *)param success:(requestSuccess)success;

-(void)zanWithParam:(AccountParam *)param success:(requestSuccess)success;

/**
 * 修改头像
 */
-(void)changeAvtar:(UIImage *)avatar success:(requestSuccess)success;

/**
 * 修改个人中心背景图片
 */
-(void)changeUserBackground:(UIImage *)background success:(requestSuccess)success;

/**
 * 发送礼物
 * responseObj:赠送成功后,数据为一个account信息,否则则返回错误信息
 */
-(void)sendGiftWithParam:(AccountParam *)param success:(requestSuccess)success;

-(void)getAccountInfoSuccess:(void(^)(void))success faile:(void(^)(void))faile;

-(void)getMyLiveRecordListWithParam:(AccountParam *)param success:(requestSuccess)success;
/** 绑定手机号 */
-(void)bindingMobileWithParam:(AccountParam *)param success:(requestSuccess)success;
/** 发送弹幕*/
-(void)sendDanmuToAnchorWithParam:(AccountParam *)param success:(requestSuccess)success;

@end

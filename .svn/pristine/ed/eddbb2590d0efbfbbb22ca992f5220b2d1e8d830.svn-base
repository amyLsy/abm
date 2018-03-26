//
//  AccountParam.h
//  sisitv
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseParam.h"

@interface AccountParam : BaseParam


+(instancetype)accountParam;


//旧密码：
@property (nonatomic , strong) NSString *oldpassword;

//密码：
@property (nonatomic , strong) NSString *password;
///确认密码：repassword
@property (nonatomic , strong) NSString *repassword;

@property (nonatomic , strong) NSString *userid;

/****登录param****/
//手机号：
@property (nonatomic , strong) NSString * mobile_num;

//更换绑定时的旧手机号
@property (nonatomic , strong) NSString *old_mobile_num;

/****注册param****/
///昵称：user_nicename
@property (nonatomic , strong) NSString *user_nicename;

///验证码：varcode
@property (nonatomic , strong) NSString *varcode;

///获取手机验证码  status（固定值，注册时标识为register0，忘记密码时forgetPassword0，绑定时binding0） 默认是注册
@property (nonatomic , strong) NSString *status;

@property (nonatomic , strong) NSString *uid;



/****修改头像****/
@property (nonatomic , copy)  NSString  *avatar;

/****个人中心头像****/
@property (nonatomic , copy)  NSString  *background;

/****赠送礼物param****/
@property (nonatomic , strong) NSString *giftid;

@property (nonatomic , strong) NSString *number;

@property (nonatomic , strong) NSString *room_id;

@end

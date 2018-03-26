//
//  BaseUser.h
//  sisitv_ios
//
//  Created by apple on 17/1/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseItem.h"

@interface BaseUser : BaseItem


/**
 * token
 */
@property (nonatomic , copy) NSString *token;
/** 个性签名 */
@property (nonatomic , copy) NSString *signature;
/** 手机 */
@property (nonatomic , copy) NSString *mobile;
/** 手机绑定状态 */
@property (nonatomic , copy) NSString *mobile_status;
/** 手机绑定状态颜色 */
@property (nonatomic , strong) UIColor *mobileStatusColor;


/** channel_status:直播状态 */
@property (nonatomic , strong) NSString *channel_status;
/** room_id:房间号 */
@property (nonatomic , copy) NSString *room_id;

/** 是否认证*/
@property (nonatomic , copy) NSString *is_truename;


/** 位置(地理信息) */
@property (nonatomic , copy) NSString *location;

/** 钻石(余额) */
@property (nonatomic , copy) NSString *balance;

/**我的思豆*/
@property (nonatomic , copy) NSString *sidou;

/** 花掉的钱 */
@property (nonatomic , copy) NSString *total_spend;

@property (nonatomic , strong) NSString *attention_num;

@property (nonatomic , strong) NSString *fans_num;

/**
 大于0,直播间是分钟付费房间
 */
@property (nonatomic , copy) NSString *minute_charge;
/**
 0不是,1是密码房间
 */
@property (nonatomic , copy) NSString *need_password;

/**
 大于0,直播间是付费房间
 */
@property (nonatomic , copy) NSString *price;
/**
 0不是,1是私密房间
 */
@property (nonatomic , copy) NSString *privacy;
//视频
@property (nonatomic , copy) NSString *video_num;
//图片
@property (nonatomic , copy) NSString *photo_num;
//推广码
@property (nonatomic , copy) NSString *promote_code;

//是否首次注册
@property (nonatomic , assign) BOOL firstRegister;

@end

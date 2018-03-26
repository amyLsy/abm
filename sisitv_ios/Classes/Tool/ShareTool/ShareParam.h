//
//  ShareParam.h
//  sisitv
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseParam.h"

@interface ShareParam : BaseParam

/**********************分享***************************/

/**
 * 房间id
 */
@property (nonatomic , copy) NSString *room_id;


/**********************第三方登录***************************/

/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *from;

/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *sex;

/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *head_img;
/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *name;

/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *access_token;


/**
 * 从哪个平台登录的
 */
@property (nonatomic , copy) NSString *expires_date;

/**
 * openid
 */
@property (nonatomic , copy) NSString *openid;



+(instancetype)shareParam;

@end

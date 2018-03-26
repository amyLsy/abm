//
//  RoomParam.h
//  sisitv
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseParam.h"

@interface RoomParam : BaseParam

-(instancetype)initWithToken:(NSString *)token withRoomId:(NSString *)room_id;

+(instancetype)roomParam;

/**
 是否是私密直播(1:是,0:不是)
 */
@property (nonatomic , copy) NSString *privacy;
/**
 房间的密码
 */
@property (nonatomic , copy) NSString *room_password;
/**
 付费房间的价格
 */
@property (nonatomic , copy) NSString *price;
/**
 话题类型(1:所有)
 */
@property (nonatomic , copy) NSString *term_id;
/**
 房间id
 */
@property (nonatomic , copy) NSString *room_id;
/**
 开始直播的标题
 */
@property (nonatomic , copy) NSString *title;
/**
 order：( 默认1:最新,按开播时间排序,2:最热,按在线人数排序)
 */
@property (nonatomic , strong) NSNumber *order;
/**
 类型：1:获取直播间时type(默认1热门，2最新）
      2:超管时type(断流中断直播1000、封禁2000、推热门3000、取消热门4000)
 */
@property (nonatomic , strong) NSNumber *type;
/**
 text:举报内容
 */
@property (nonatomic , copy) NSString *text;
/**
 开始直播推流成功后的回调
 */
@property (nonatomic , copy) NSString *action;

@property (nonatomic , copy) NSString *location;

@property (nonatomic , copy) NSString *latitude;

@property (nonatomic , copy) NSString *longitude;

@end

//
//  RoomInfo.h
//  sisitv
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseUser.h"

@interface RoomInfo : BaseUser

@property (nonatomic , strong) NSString *match_id;

/**  channel_creater:房间创建者(主播id) */
@property (nonatomic , strong) NSString *channel_creater;

@property (nonatomic , strong) NSString *channel_location;

/**  channel_source:直播视频地址 */
@property (nonatomic , strong) NSString *channel_source;

/**  online_num:在线人数 */
@property (nonatomic , strong) NSString *online_num;

/**  all_time:直播时长  */
@property (nonatomic , strong) NSString *all_time;

/** match_authority:判断主播是事有权限发起竞猜，值为0表示不具备，1表示具备 */
@property (nonatomic , strong) NSString *match_authority;

/** match_authority:判断主播是否开启游戏 0:未开始， 1:已开始， 2:进行中 */
@property (nonatomic , strong) NSString *is_start_match;

/**  guard_status:根据打开本直播间的token,判断该account是不是房管(1是，0不是) */
@property (nonatomic , copy) NSString *guard_status;

/**  advanced_administrator:是否是超管(1是，0不是) */
@property (nonatomic , copy) NSString *advanced_administrator;

/** channel_title:直播标题 */
@property (nonatomic , strong) NSString *channel_title;

/** 观看价格 */
@property (nonatomic , copy) NSString *price;

/** 观看密码 */
//@property (nonatomic , assign) BOOL need_password;

/** 分钟付费价格 */
@property (nonatomic , copy) NSString *minute_charge;

@property (nonatomic , strong) NSURL *smeta;

/**  total_earn:总收入 */
@property (nonatomic , copy) NSString *total_earn;

/** earn:本次直播的收入 */
@property (nonatomic , copy) NSString *earn;

/**  channel_like:点赞数 */
@property (nonatomic , copy) NSString *channel_like;


/**  leancloud_room:leenColud聊天室 */
@property (nonatomic , copy) NSString *leancloud_room;

/**  push_rtmp:推流地址 */
@property (nonatomic , copy) NSString *push_rtmp;

@property (nonatomic , copy) NSString *shop_url;
// 秒（比赛开始时间）
@property (nonatomic , copy) NSString *match_time;

//比赛分类
@property (nonatomic , copy) NSString *term_name;

//比赛类型
@property (nonatomic , copy) NSString *type_name;
//游戏区域ID
@property (nonatomic , copy) NSString *area_id;



@end

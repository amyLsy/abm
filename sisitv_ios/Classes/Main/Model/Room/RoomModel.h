//
//  RoomModel.h
//  sisitv
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomParam.h"
#import "RoomInfo.h"
#import "AudienceInfo.h"
#import "RoomSystemMessage.h"

/**
 * responseObj :需要返回的数据
 * successGetInfo 是否成功获得数据
 */
typedef void(^requestSuccessBlock)(id responseObj ,BOOL successGetInfo);


@interface RoomModel : NSObject

///一个房间的信息
@property (nonatomic , strong) RoomInfo *data;

//房间系统消息
@property (nonatomic , copy) NSArray *msg;

//房间信息列表数组
@property (nonatomic , strong) NSArray *info;
 

/**
 * 开始直播
 *
 */
+(void)startLiveWithParam:(RoomParam *)param success:(requestSuccessBlock)success ;
/**
 * 开始直播成功回调
 *
 */
+(void)startLivePushCallback:(RoomParam *)param success:(requestSuccessBlock)success faile:(void(^)(void))faile;

/**
 * 结束直播
 *
 */
+(void)stopLiveWithParam:(RoomParam *)param success:(requestSuccessBlock)success ;


/**
 * 获取直播间列表
 *
 */
+(void)loadLiveRoomListWithParam:(RoomParam *)param success:(requestSuccessBlock)success;


/**
 * 判断直播间密码
 *
 */
+(void)checkRoomPassword:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 获取关注的直播间列表
 *
 */
+(void)loadAttentionRoomListWithParam:(RoomParam *)param success:(requestSuccessBlock)success;


/**
 * 举报
 *
 */
+(void)reportTheRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 设置或者取消房管
 *
 */
+(void)managerLiveGuard:(RoomParam *)param withTitle:(NSString *)title success:(requestSuccessBlock)success;
/**
 * 禁言
 *
 */
+(void)forbiddenWithParam:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 我的房管
 *
 */
+(void)getGuardListWithParam:(RoomParam *)param success:(requestSuccessBlock)success;


/**
 * 进入直播间
 *
 */
+(void)enterRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success;


/**
 * 获取直播间在线列表
 *
 */
+(void)getLiveRoomOnlineList:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 离开直播间
 *
 */
+(void)leaveRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 更新直播间信息
 *
 */
+(void)loadLiveRoomOnlineNumEarn:(RoomParam *)param success:(requestSuccessBlock)success;

/**
 * 获取活动
 *
 */
+(void)getActivityinfoWithParam:(RoomParam *)param success:(requestSuccessBlock)success;
 
/**
 * 超管操作
 *
 */
+(void)administartorManageWithParam:(RoomParam *)param success:(requestSuccessBlock)success;


@end

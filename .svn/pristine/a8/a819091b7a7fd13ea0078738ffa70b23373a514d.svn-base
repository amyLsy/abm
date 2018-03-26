//
//  ChatMessage.h
//  liveFrame
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseItem.h"
#import "ChatMessageOther.h"

typedef NS_ENUM(NSUInteger, ChatMessageType) {
    ChatNomalMessage = 1,
    ///礼物消息
    ChatGiftMessage,
    ///系统消息
    ChatSystemMessage,
    ///赞
    ChatCommendMessage,
    ///离开房间
    ChatExitMessage,
    ///进入房间
    ChatEnterMessage,
    ///弹幕
    ChatDanMuMessage,
    //禁言
    ChatForbidden = 11,
    //主播正常结束直播(正常是相对于闪退,强行杀死等操作,服务器结束也属正常结束)
    ChatHostFinishShowingNormal = 20,
    //主播设置场控
    ChatHostSetGuard = 21,
    //主播取消场控
    ChatHostCancelGuard = 22,
    //申请连麦
    ChatHadCallComing = 100,
    //接受连麦
    ChatLianMaiAccept,
    //拒绝连麦
    ChatRejectComingCall,
    ///可以发起连麦
    ChatLianMaiAvailable,
    ///不可以连麦
    ChatLianMaiDiable,
    ///观众取消申请连麦
    ChatLianMaiCancel,
    //公告
    ChatAnnouncement,
    
    // 开启游戏准备
    ChatGameWait = 200,
    // 游戏进行中
    ChatGameStart,
    // 游戏结束
    ChatGameEnd,
    // 游戏加入
    ChatGameAdd,
    // 游戏被终止(主播突然离开直播间)
    ChatGameStop,
    // 开启游戏失败(游戏人数不足)
    ChatGameFail,
    // 游戏押注中
    ChatGameStake,
    // 游戏显示排名
    ChatGameRanking,
    // 玩家退出游戏
    ChatGameQuit,
    // 押注结束
    ChatGameStakeEnd,
    
    //向用户发送隐藏答题框
    ChatGameShowQuest = 211,
    //开始音乐类型
    ChatGameShowMusic,
    // 游戏实时排行榜
    ChatGameList
    
    
    
    
};


typedef NS_ENUM(NSUInteger, ChatMessageStatusType) {
    ChatReceivedMessage = 1,
    ChatSendedMessage,
    ChatGameMessage // 游戏消息
};


@interface ChatMessage : BaseItem

/**
 * 消息状态类型:1:收到的消息(默认);2:发送的消息
 */
@property (nonatomic , assign) ChatMessageStatusType statusType;
/**
 * 消息类型:1普通消息;2礼物消息;3系统消息;4点赞;5离开房间;11禁言
 */
@property (nonatomic , assign) ChatMessageType type;

/**
 * 发送消息者名字
 */
@property (nonatomic , copy) NSString *userName;

/** 发送消息者等级*/
@property (nonatomic , copy) NSString *userLevel;

/**
 * 发送消息者id
 */
@property (nonatomic , copy) NSString *userId;

/**
 * 消息携带的other信息(json字符串)
 */
@property (nonatomic , strong) ChatMessageOther *other;

/**
 * 消息信息
 */
@property (nonatomic , copy) NSString *content;

/**
 * 是否认证
 */
@property (nonatomic , copy) NSString *verify;


-(instancetype)initWithUserName:(NSString *)userName content:(NSString *)content userId:(NSString *)userId userLevel:(NSString *)userLevel avatar:(NSString *)avatar;

+(instancetype)chatMessage;

@end

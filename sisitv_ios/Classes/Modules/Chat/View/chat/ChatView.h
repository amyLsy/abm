//
//  ChatView.h
//  Zhibo
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewUtilits.h"
#import "ChatFucView.h"
#import "ChatConversationView.h"
#import "ChatBottomView.h"

@class RoomInfo,ChatMessage;


@class ChatMessageModel,HostInfo,ChatView,GiftInfo;

@protocol ChatViewDelegate <NSObject>


@optional



-(void)chatView:(ChatView *)chatView clickGameButton:(UIButton *)button;

-(void)chatView:(ChatView *)chatView clickButton:(UIButton *)button withEventType:(ChatViewTouchEventType)evenType;
/**
 *超管相关操作
 */
-(void)chatView:(ChatView *)chatView clickButton:(UIButton *)button withAdministratorType:(ChatAdministratorType)administratorType;
/**
 *moreOpitionViewType
 */
-(void)chatView:(ChatView *)chatView clickMoreOpitionViewButtonType:(ChatMoreOpitionViewType)moreOpitionViewType;

/** 点击icon头像 */
-(void)chatView:(ChatView *)chatView touchIconImageViewWithId:(NSString *)ID;

/** 送礼物 */
-(void)chatView:(ChatView *)chatView sendGiftInfo:(GiftInfo *)giftInfo;
/**
 聊天
 */
-(void)chatView:(ChatView *)chatView sendMessageString:(NSString *)messageString isBroadcast:(BOOL)isBroadcast;

/** income */
-(void)chatView:(ChatView *)chatView touchIncomeWithId:(NSString *)ID;

/** 点击cell */
-(void)chatView:(ChatView *)chatView  clickConversationCellWithChatMessage:(ChatMessage *)chatMessage;
/**
 主播正常结束主播
 */
-(void)hostFinishShowingNormal;
/**
 主播设置和取消房管
 */
-(void)hostSetGuard;
-(void)hostCancelGuard;


/**
 申请连麦
 */
-(void)joinUser:(ChatMessage *)userMessage;

/**
 同意连麦
 */
-(void)answerCall;

/**
 拒绝连麦
 */
-(void)rejectCall;

/**
 改变背景音乐音量
 */
-(void)changeVoice:(float)voice;

@end

@interface ChatView : UIView


@property (nonatomic , weak) id<ChatViewDelegate> delegate;

/**
 聊天view
 */
@property (nonatomic , strong) ChatConversationView *chatConversationView;

/**
 礼物数组
 */
@property (nonatomic , strong) NSArray *giftDataArray;
/**
 活动信息
 */
@property (nonatomic , strong) NSDictionary *activityinfo;
/**
 直播间信息
 */
@property (nonatomic , strong) RoomInfo *roomInfo;
/**
 循环获取主播收到的礼物,房管状态等的信息
 */
@property (nonatomic , strong) RoomInfo *loopUpdateInfo;

/**
 是否有未读消息
 */
@property (nonatomic , assign) BOOL hadUnReadMessage;

/**
 右边中部的view
 */
@property (nonatomic , weak) ChatFucView *chatFucView;
/**
 底部view
 */
@property (nonatomic , weak) ChatBottomView *chatBottomView;

-(instancetype)initWithStyle:(ChatViewStyle) chatViewStyle;

/**
 进入房间后更新头像列表
 
 @param audiences 一个包含着观众信息的数组
 */
-(void)startShowAudiences:(NSMutableArray *)audiences;
/**
 当第一次进入直播建的时候,清空聊天数据,
 因为可能是从上一个直播间直接跳转过来的.
 */
-(void)clearChatConversionData;

/**
 收到聊天消息,或者发送消息后,显示到聊天列表上
 
 @param chatMessage 消息
 */
-(void)startShowChatMessage:(ChatMessage *)chatMessage;
/**
 背景音乐是否正在播放
 
 @param isPlying 是否正在播放
 */
-(void)bgmPlayerIsPlying:(BOOL)isPlying;
/**
 当开始播放歌曲的时候,显示歌词视图,加载歌词
 
 @param lyrics 歌词
 */
-(void)startLoadLyrics:(NSArray *)lyrics;
/**
 从0开始，最大为bgmDuration长度
 
 @param bgmPlayTime 背景音的已经播放长度 (单位:秒)
 */
-(void)currentBgmPlayTime:(float)bgmPlayTime;

/**
 停止加载歌词
 */
-(void)stopLoadLyrics;

-(void)giftSendSuccess:(BOOL)success;

- (void)showGift;

- (void)hiddenGiftButton;

- (void)showingGiftButton;


@end


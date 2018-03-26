//
//  ChatTopInfoView.h.h
//  liveFrame
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewUtilits.h"

@class RoomInfo,AudienceInfo;


typedef void(^ClickUserIcon)(NSString *ID);
typedef void(^ClickClose)(void);
typedef void(^ClickAttention)(NSString *ID,UIButton *attentionButton);
typedef void(^ClickIncome)(NSString *ID);
typedef void(^ClickCancelLianMai)(void);
typedef void(^ClickActivity)(void);
typedef void(^ChatTopClickStopBgm)(void);
typedef void(^ChatTopClickChangeVoice)(void);

@interface ChatTopInfoView : UIView

/**
 活动按钮信息
 */
@property (nonatomic , strong) NSDictionary *activityinfo;

@property (nonatomic , strong) RoomInfo *roomInfo;

@property (nonatomic , copy) ClickUserIcon clickUserIconImageview;
@property (nonatomic , copy) ClickAttention clickAttention;
@property (nonatomic , copy) ClickIncome clickIncome;
@property (nonatomic , copy) ClickCancelLianMai clickCancelLianMai;
@property (nonatomic , copy) ClickActivity clickActivity;
@property (nonatomic , copy) ChatTopClickStopBgm stopPlayBgm;
@property (nonatomic , copy) ChatTopClickChangeVoice changeVoice;

@property (nonatomic , assign)  ChatViewStyle chatViewStyle;


/**
 进入直播间,开始显示从服务器获取到的房间列表

 @param audiences 观众列表
 */
-(void)startShowAudiences:(NSMutableArray *)audiences;
/**
 有别人进入直播间,从添加到头像列表
 
 @param audienceInfo userId
 */
-(void)addAudience:(AudienceInfo *)audienceInfo;
/**
 有人离开直播间,从头像列表移除ta

 @param userId userId
 */
-(void)removeAudienceForUserId:(NSString *)userId;
/**
 当有人送礼物和弹幕消息后,改变totalEarn
 
 @param totalEarn totalEarn
 */
-(void)changeTotalEarn:(NSString *)totalEarn;
/**
 背景音乐是否正在播放
 
 @param isPlying 是否正在播放
 */
-(void)bgmPlayerIsPlying:(BOOL)isPlying;

@end

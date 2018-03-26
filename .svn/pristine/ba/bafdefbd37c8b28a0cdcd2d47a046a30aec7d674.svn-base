//
//  LeanColudTool.h
//  liveFrame
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanCloudToolUtilits.h"
#import "ChatMessage.h"

typedef void (^LeanCloudBooleanResultBlock)(BOOL succeeded, NSError *error);

typedef void (^LeanCloudJoinConversationResultBlock)(BOOL success ,NSString *errorMessage);

typedef void (^LeanCloudSendChatMessageResultBlock)(BOOL success ,NSString *errorMessage);

@interface LeanCloudTool : NSObject

/**
 *  获取单例
 */
+ (LeanCloudTool *)leanCloudTool;
/*!
 * 当前的直播间的消息所属对话的 id
 */
@property (nonatomic, copy) NSString *currentConversationId;
/**
 *获取未读数
 */
@property (nonatomic , copy) void(^unreadCountBlock)(NSInteger totalUnreadCount);

-(void)regeistRemoteNotificationWithDeviceToken:(NSData *)deviceToken;

/**
 *  注册leadCloud
 */
- (void)regeistLeanCould;

/**
 *  打开一个聊天终端，登录服务器
 */
-(void)openLeanCloudWithcallback:(LeanCloudBooleanResultBlock)callbac;

-(void)addBlackListWithUserId:(NSString *)userId;

-(BOOL)isUserIdInBlackList:(NSString *)userId;

/**
 *退出房间
 */
-(void)quitWithCallback:(void(^)(BOOL succeeded, NSError *error))callBack;

/**
 *  关闭一个聊天终端，注销的时候使用
 */
- (void)closeWithCallback:(LeanCloudBooleanResultBlock)callback;

/**
 *  根据 conversationId 进入对话
 *  @param conversationId   对话的 id
 *
 */
- (void)joinConversationWithConversationId:(NSString *)conversationId callback:(LeanCloudJoinConversationResultBlock)callback;

/**
 3333

 @param chatMessage 消息
 @param callback callback
 */
-(void)sendChatMessage:(ChatMessage *)chatMessage callback:(LeanCloudSendChatMessageResultBlock)callback;

@end

//
//  LearnColudTool.m
//  liveFrame
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LeanCloudTool.h"
#import "BaseUserRequset.h"
#import "Account.h"
#import <ChatKit/LCChatKit.h>
#import "LCCKContact.h"


typedef void (^FecthConversationResultBlock)(AVIMConversation *conversation , NSString *errorMessage);

@interface LeanCloudTool ()


/*!
 * AVIMClient 实例
 */
@property (nonatomic, strong) AVIMClient *client;

/**
 当前的会话
 */
@property (nonatomic , strong) AVIMConversation *conversation;

/**
 拉黑后的黑名单列表
 */
@property (nonatomic , strong) NSMutableSet *blackListSet;

/**
 打开client失败后,重连的次数
 */
@property (nonatomic , assign) NSInteger reconnectCount;

@property (nonatomic , strong) NSMutableArray *repeatContent;


@end

@implementation LeanCloudTool


+ (LeanCloudTool *)leanCloudTool {
    
    static LeanCloudTool *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[LeanCloudTool alloc] init];
    });
    return instance;
}

-(void)regeistRemoteNotificationWithDeviceToken:(NSData *)deviceToken{
    
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

-(void)regeistLeanCould
{
    NSString *leanCouldAppId = LeanCouldAppId;
    NSString *leanCouldAppKey = LeanCouldAppKey;
    [LCChatKit setAppId:leanCouldAppId appKey:leanCouldAppKey] ;
    [LCCKSettingService setAllLogsEnabled:NO];
    [AVOSCloud setAllLogsEnabled:NO];
    //设置用户信息
    [[LCChatKit sharedInstance] setFetchProfilesBlock:^(NSArray<NSString *> *userIds, LCCKFetchProfilesCompletionHandler completionHandler) {
        NSMutableArray *arr =[NSMutableArray array];
        for (NSString *ID in userIds) {
            BaseParam *userParam = [[BaseParam alloc]initWithUserId:ID];
            BaseUserRequset *userRequset = [[BaseUserRequset  alloc] initWithRequestParam:userParam];
            [userRequset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
                BaseUser *accounts = (BaseUser *)request.item;
                LCCKContact *user = [[LCCKContact alloc]initWithUserId:ID name:accounts.user_nicename avatarURL:[NSURL URLWithString:accounts.avatar] clientId:ID];
                [arr addObject:user];
                completionHandler(arr,nil);
            } failure:nil];
        }
    }];
    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(NSIndexPath *indexPath, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        LCCKConversationViewController *conversationVC = [[LCCKConversationViewController alloc] initWithConversationId:conversation.conversationId];
        [controller.navigationController pushViewController:conversationVC animated:YES];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedUnreads) name:LCCKNotificationUnreadsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceivedMessage:) name:LCCKNotificationMessageReceived object:nil];
}

-(void)updatedUnreads{
    [[LCCKConversationListService sharedInstance] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        if (self.unreadCountBlock) {
            self.unreadCountBlock(totalUnreadCount);
        }
    }];
}
#pragma mark 收到消息的通知,回调
-(void)notificationReceivedMessage:(NSNotification *)noti
{
    NSDictionary *message = noti.object;
    AVIMConversation *conversation = message[@"conversation"];
    if ([conversation.conversationId isEqualToString:self.currentConversationId]) {
        AVIMTypedMessage *typeMessage = [message[@"receivedMessages"] firstObject];
        ChatMessage *chatMessage = [ChatMessage mj_objectWithKeyValues:typeMessage.text.mj_JSONObject];
        if (chatMessage) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KLeanCloudToolReceivedLeanColudMessage object:@{@"chatMessage":chatMessage,@"conversationid":conversation.conversationId}];
        }
    }else if (conversation.lcck_type == LCCKConversationTypeSingle) {
        if (self.unreadCountBlock) {
            self.unreadCountBlock(1);
        }
    }
}


-(void)addBlackListWithUserId:(NSString *)userId{
    [self.blackListSet addObject:userId];
}
-(BOOL)isUserIdInBlackList:(NSString *)userId{
    BOOL isExist = NO;
    if (self.blackListSet.count>0) {
        for (NSString *existUserId in self.blackListSet) {
            if ([userId isEqualToString:existUserId]) {
                isExist = YES;
                break;
            }
        }
    }
    return isExist;
}


-(void)openLeanCloudWithcallback:(LeanCloudBooleanResultBlock)callback{
    
    if (self.client.status == AVIMClientStatusOpened)  {
        if (callback) {
            callback(YES,nil);
        }
    }else{
        Account *account = [Account shareInstance];
        NSString *clientId = account.ID;
        [[LCChatKit sharedInstance] openWithClientId:clientId callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                self.client = [LCChatKit sharedInstance].client;
                [self fecthRecentConversations];
                if (callback) {
                    callback(succeeded,error);
                }
            }else{
                YZGLog(@"%@----error!!!!!! %@",NSStringFromSelector(_cmd),[error localizedDescription]);
                
                if (self.reconnectCount<=9) {
                    self.reconnectCount++;
                    [self openLeanCloudWithcallback:callback];
                }else{
                    self.reconnectCount = 0;
                    if (callback) {
                        callback(succeeded,error);
                    }
                }
            }
        }];
    }
}

-(void)fecthRecentConversations{
    AVIMConversationQuery *query = [self.client conversationQuery];
    query.cachePolicy = kAVCachePolicyIgnoreCache;
    [query whereKey:@"tr" equalTo:@(YES)];
    NSDate *today = [NSDate date];
    NSDate *aMinuteAgo = [today dateByAddingTimeInterval: -60.0];
    [query whereKey:@"updatedAt" greaterThan:aMinuteAgo];
    [query findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        for (AVIMConversation *conversation in objects) {
            [conversation quitWithCallback:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    YZGLog(@"%@-=-=-=-",[error localizedDescription]);
                }else{
                    YZGLog(@"quit ok -=-=-=-%@----%d",conversation.lastMessageAt,conversation.transient);
                }
            }];
            YZGLog(@"%@-=-=-=-=",conversation.conversationId);
        }
    }];
}

-(void)closeWithCallback:(LeanCloudBooleanResultBlock)callback
{
    if (self.client.status == AVIMClientStatusOpened) {
        [self.client closeWithCallback:callback];
    }
}

-(void)quitWithCallback:(void (^)(BOOL, NSError *))callBack{
    [self.conversation quitWithCallback:callBack];
}

/**
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 *
 */
-(void)fecthConversationWithConversationId:(NSString *)conversationId callback:(FecthConversationResultBlock)callback
{
    AVIMConversationQuery *query = [self.client conversationQuery];
    [query whereKey:@"objectId" equalTo:conversationId];
    [query whereKey:@"tr" equalTo:@(YES)];
    [query findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        if (error)
        {
            YZGLog(@"%@----error!!!!!! %@",NSStringFromSelector(_cmd),[error localizedDescription]);
            if (callback) {
                callback(nil, [error localizedDescription]);
            }
        }
        else
        {
            if (objects.count == 0)
            {
                callback(nil, @"会话id无效,找不到指定的直播间!");
            }
            else
            {
                AVIMConversation *conversation = [objects objectAtIndex:0];
                self.conversation = conversation;
                callback(conversation, [error localizedDescription]);
            }
        }
    }];
}

-(void)joinConversationWithConversationId:(NSString *)conversationId callback:(LeanCloudJoinConversationResultBlock)callback
{
    [self openLeanCloudWithcallback:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            callback(NO ,[error localizedDescription]);
        }else{
            [self fecthConversationWithConversationId:conversationId callback:^(AVIMConversation *conversation, NSString *errorMessage) {
                if (conversation)
                {
                    [self joinWithconversation:conversation callback:callback];
                    
                }else{
                    callback(NO,errorMessage);
                }
            }];
        }
    }];
}

-(void)joinWithconversation:(AVIMConversation *)conversation callback:(LeanCloudJoinConversationResultBlock)callback{
    [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self saveCurrentConversationIfExists];
            callback(YES,nil);
        }else{
            YZGLog(@"%@----error!!!!!! %@",NSStringFromSelector(_cmd),[error localizedDescription]);
            [self joinWithconversation:conversation callback:callback] ;
        }
    }];
}

-(void)saveCurrentConversationIfExists{
    if (self.conversation.conversationId) {
        [LCCKConversationService sharedInstance].currentConversationId = self.conversation.conversationId;
    }
    if (self.conversation) {
        [LCCKConversationService sharedInstance].currentConversation = self.conversation;
    }
    [self.conversation muteWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            YZGLog(@"mute ok");
        }
    }];
}

-(void)sendChatMessage:(ChatMessage *)chatMessage callback:(LeanCloudSendChatMessageResultBlock)callback{

    if (chatMessage.content.length > 0 && chatMessage.type == ChatNomalMessage) {
        BOOL isContentEqual = [[self.repeatContent firstObject] isEqualToString:chatMessage.content];
        NSInteger repeatCount = [self.repeatContent count];
        if (isContentEqual && repeatCount == 3){
            callback(NO,@"请勿发送重复内容!");
            return;
        }else if (!isContentEqual && repeatCount == 3){
            [self.repeatContent removeAllObjects];
            [self.repeatContent addObject:chatMessage.content];
        }else{
            [self.repeatContent addObject:chatMessage.content];
        }
    }
   
    NSString *aJsonMessage = chatMessage.mj_JSONString;
    AVIMTextMessage *messages = [AVIMTextMessage messageWithText:aJsonMessage attributes:nil];
    [self.conversation sendMessage:messages callback:^(BOOL succeeded, NSError *error) {
        if (callback) {
            if (succeeded) {
                callback(succeeded,nil);
            }else{
                callback(NO,@"消息发送失败,请重试");
            }
        }
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSMutableArray *)repeatContent{
    if (!_repeatContent) {
        _repeatContent = [NSMutableArray array];
    }
    return _repeatContent;
}

-(NSMutableSet *)blackListSet{
    if (!_blackListSet) {
        _blackListSet = [[NSMutableSet alloc]init];
    }
    return _blackListSet;
}



- (void)test{
    
//    [[AVIMClient alloc] initWithClientId:<#(nonnull NSString *)#>]
    
}






@end

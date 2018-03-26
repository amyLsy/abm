//
//  ChatViewController.h
//  liveFrame
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatView.h"
#import "GameListView.h"
#import "GameTheEndTableViewCell.h"
@class  RoomInfo,ShowControl;

typedef void(^CloseButtonClick)();
typedef void(^PlayOrShowError)(id info);
typedef void(^AnswerCallInvitation)(NSString *hostId);
typedef void(^OnCapture)(BOOL onCapture);


@interface ChatViewController : BaseViewController
{
    BOOL is_guard_status; //是否是主播自己
    BOOL is_game_add;//是否可以加入游戏
    BOOL is_game_addNo;//是否可以加入游戏
    NSInteger is_match_authority; //权限发起竞猜值为0表示不具备，1表示具备
    __block NSTimer *sysTimer;
    __block NSTimer *gzTimer;
    UIView *gameYzView;//押注
    BOOL isNoGameYzView;//不接受押注
    UIView *gameTheEndView;//游戏排名
    BOOL isNoGameTheEndView;//不接受游戏排名
}

/**该房间的roomInfo,由player或者showing 控制器界面获取 */
@property (nonatomic , strong) RoomInfo *roomInfo;
/**进入该房间,服务器返回的提示消息,由player或者showing 控制器界面获取  */
@property (nonatomic , strong) NSArray *roomSystemMsgArray;

@property (nonatomic , strong) ChatView *chatView;

@property (nonatomic , strong) ShowControl *showControl;
/**
 关闭直播或播放
 */
@property (nonatomic , copy) CloseButtonClick clickCloseButton;
/**
 播放或者直播错误
 */
@property (nonatomic , copy) PlayOrShowError playOrShowError;
/**
 同意连麦
 */
@property (nonatomic , copy) AnswerCallInvitation answerCallInvitation;

@property (nonatomic , strong) UIView *playerSuperView;
/**
    游戏实时排行榜的背景view
 */
@property (nonatomic , strong) GameListView *gameListView;//游戏排名
//实时排行榜的view
@property (nonatomic , strong) GameTheEndTableViewCell *gameTheEndCell;

//是否需要开启半屏推流
@property (nonatomic , copy) OnCapture onCapture;


-(instancetype)initWithChatViewStyle:(ChatViewStyle)chatViewStyle;

@end


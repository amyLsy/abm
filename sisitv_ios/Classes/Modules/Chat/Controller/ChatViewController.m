//
//  ChatViewController.m
//  liveFrame
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatViewController.h"
#import "BaseNavgationController.h"
#import "CostViewController.h"
#import "RankController.h"
#import "UtilityController.h"
#import "EndShowingController.h"
#import "PersonalContributionController.h"
#import "SisiConversationListController.h"
#import "SisiConversationViewController.h"
#import "BaseWebViewController.h"
#import "ChatAlertController.h"
#import "ChatGuardListController.h"
#import "ChatMusicController.h"
#import "ChatScrollView.h"
#import "ChagerViewController.h"


#import "YZGAppSetting.h"
#import "Account.h"
#import "AlertTool.h"
#import "LeanCloudTool.h"
#import "YZGShare.h"
#import "RoomInfo.h"
#import "RoomModel.h"
#import "ShowControl.h"
#import "YZGCustomCrossPresent.h"
#import "GameStartTableViewCell.h"
#import "GameYZTableViewCell.h"
#import "GameTheEndTableViewCell.h"
#import "VideoPlayView.h"
#import "KSYGPUStreamerKit.h"
#import <GPUImage/GPUImage.h>
#import <libksygpulive/KSYGPUPipStreamerKit.h>
#import "LGBgmVIew.h"
#import "LGShowListController.h"
#import "LGDoOrderShowView.h"
#import "HttpTool.h"
#import "LGShowListModel.h"
#import "KSYAgoraStreamerKit.h"
#import "KSYAgoraClient.h"
#import "LGUserLianMaiListView.h"
#import "IQKeyboardManager.h"
#import <MJExtension/MJExtension.h>
#import "GiftListInvitaView.h"
#import "GameModelList.h"





@interface ChatViewController ()<ChatViewDelegate,YZGShareViewDelegate,LGUserLianMaiListViewDelegate>
{
    UIAlertController *alertAddGame;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIView* _winRtcView;
    bool _ismaster;
    GiftListInvitaView  *giftListInvitaView;
    GiftListInvitaView *giftListView;

    
}

@property (nonatomic , strong) UIView *gameBgView;
@property (nonatomic , weak) GameStartTableViewCell *gameCell;

@property (nonatomic , weak) ChatScrollView *scrollView;

@property (nonatomic , assign) ChatViewStyle chatViewStyle;
/**
 粒子动画
 */
@property(nonatomic, strong) CAEmitterLayer *emitterLayer;
/**
 房管
 */
@property (nonatomic , copy) NSString *guardStatus;

/**
 定时器
 */
@property (nonatomic , strong) NSTimer *upDateRoomInfoTimer;
/**
 lyric定时器
 */
@property (nonatomic , strong) NSTimer *lyricTimer;
/**
 lyrics数组
 */
@property (nonatomic , strong) NSArray *lyricArray;
/*
 videoPlayView 播放视频View
 */
@property (strong, nonatomic)  VideoPlayView *playView;
@property (strong, nonatomic) LGBgmVIew *bgmView;


@property (nonatomic, strong) KSYGPUPipStreamerKit * pipKit;
//@property (nonatomic, retain) KSYGPUStreamerKit * kit;
//歌曲索引
@property (nonatomic, assign) NSInteger index;

//
@property (nonatomic, assign) NSInteger roomStatus;

// submodules
@property (nonatomic, retain) KSYStreamerBase*   streamerBase;

//申请连麦的用户
@property (nonatomic, strong) NSMutableArray * lianMaiUserArray;

//连麦邀请列表
@property (nonatomic , strong) LGUserLianMaiListView *lianmaiListView;

//敏感词词语
@property (nonatomic , strong) NSArray *sensitiveWords;

//本局游戏是否接受邀请
@property bool isInvitation;

//播放视频
@property (strong ,nonatomic) KSYMoviePlayerController *player;
@property KSYAgoraStreamerKit * kit;
@property bool beQuit;
//
@property NSString *matchId;
@property NSString *userMatchId;
//本局游戏是否已经从新连接
@property bool isReconnect;
@end

@implementation ChatViewController

-(instancetype)initWithChatViewStyle:(ChatViewStyle)chatViewStyle{
    
    if (self = [super init]) {
        self.chatViewStyle = chatViewStyle;
        
    }
    return self;
}

- (GameStartTableViewCell *)gameCell{
    
    if(_gameCell == nil){
        KWeakSelf;
    _gameCell = [[[NSBundle mainBundle] loadNibNamed:@"GameStartTableViewCell" owner:nil options:nil] firstObject];
    _gameCell.presenController = self;
    
        if (_chatViewStyle == ChatViewStyleHost) {
        //主播
            _gameCell.isTheHost = YES;
            
        }else{
        //观众
          _gameCell.isTheHost = NO;
            
        }
        
        _gameCell.gameStartMsgBlock = ^(id obj, ChatMessageType mType) {
            
            //等待加入游戏显示等待界面
            if(mType == ChatGameWait){// 等待加入游戏
                
                //加载礼品数据显示礼物列表
                [self showGiftListView:obj];
                
                //主播界面显示
                if (is_guard_status) {
                    
                    NSDictionary *dict = [obj mj_JSONObject];
                    // 60秒提示  // 人数限制
                    ws.gameCell.gameRenCount = [dict[@"join_num"] integerValue];
                    __block int numTimer=_gameCell.join_time;
                    __block int numCount=1;
                    
                    // 提示语
                    NSString *msg = [NSString stringWithFormat:@"[主播]发起了答题竞猜，如未加入的玩家请点击屏幕右上方“小游戏”按钮加入游戏！！！"];
                    ChatMessage *chatMessage = [ws systemMessageWithContent:msg messageType:ChatSystemMessage];
                    [ws.chatView startShowChatMessage:chatMessage];
                    
                    // 提示语
                    sysTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                        // 1.主播开始竞猜，将消息发送给直播间所有人，游戏开始匹配等待60s时间
                        numTimer-=1;
                        if (numTimer <= 0) {
                            [sysTimer invalidate],sysTimer = nil;
                            if (ws.gameCell.gameRenCount>=numCount){
                                //如果游戏中有人数那么就开启答题
                                ws.gameCell.gmTimerMsg.text = @"";
                                [ws.gameCell gamePays];//自动开始答题
                            }else{
                                
                               
                                ws.gameCell.headTitleLab.text=@"游戏人数不足，请重新开启游戏;";
                                [ws.gameCell.stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
                                ws.gameCell.colleView.hidden=NO;
                                ws.gameCell.stateBtn.hidden=NO;
                                ws.gameCell.gmTimerMsg.hidden=YES;
                                [ws.gameCell resSet];
                                // 主播主动关闭游戏
                                [ws gameMessageWithContent:msg messageType:ChatGameStop];
                            }
                            return ;
                        }
                        ws.gameCell.headTitleLab.text=[NSString stringWithFormat:@"* 正在等待玩家加入游戏，已加入%ld人; ",(long)_gameCell.gameRenCount];
                        ws.gameCell.gmTimerMsg.hidden=NO;
                        ws.gameCell.gmTimerMsg.text= [NSString stringWithFormat:@"等待玩家加入...%is",numTimer];
                        
                        [ws gameMessageWithContent:obj messageType:ChatGameWait];
                    }];
                }
                
                //                //如果有视频或者或者音乐则加载视频音乐
                //                _gameCell.GameUrlBlock = ^(NSString *urlStr){
                //
                //                    //开启画中画
                //                    if([urlStr isKindOfClass:[NSNull class]]) {
                //
                //                        return ;
                //                    }
                //                    if (urlStr.length) {
                //                        [AlertTool showWithCustomModeInView:self.view];
                //                        ws.gameCell.videoView.hidden = NO;
                //                    //开始播放视频
                //                        if (urlStr) {
                //                            if (!self.player) {
                //                                self.player  = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
                ////                                ws.player.scalingMode = MPMovieScalingModeAspectFill;
                //                                self.player.shouldAutoplay = YES;
                //                                self.player.view.frame = ws.gameCell.videoView.bounds;
                //
                //                                [self.gameCell.videoView addSubview:self.player.view];
                //                                [self.player prepareToPlay];
                //                            }else{
                //                                [self.player reset:NO];
                //                                [self.player setUrl:[NSURL URLWithString:urlStr]];
                //                                [self.player prepareToPlay];
                //                            }
                //                        }else{
                //
                //                            [self.player pause];
                //
                //                        }
                //
                //
                ////                        NSURL *url = [NSURL URLWithString:urlStr];
                //////                        self.showControl.streamerKit.pipRect = CGRectMake(0, 0, 0, 0);
                ////                        [self.showControl.streamerKit startPipWithPlayerUrl:url bgPic:nil];
                //
                //                    }else{
                //
                //
                //                        //结束播放视频
                //                        [self.player pause];
                //                        ws.gameCell.videoView.hidden = YES;
                ////                        [self.showControl.streamerKit stopPip];
                //                    }
                //
                //
                //
                //                };
                
                
            }else if(mType == ChatGameStart){// 游戏开始,主播发题
                _gameCell.left_button.hidden=YES;
                if (is_guard_status) {
                    //重连显示礼物列表
                    if (giftListView.dataArray == nil) {
                        [self requstGiftListForId:[obj mj_JSONObject][@"area_id"]];
                    }
                    
                    [ws gameMessageWithContent:obj messageType:mType];
                }
            }else if (mType==ChatGameRanking) {// 显示排名
                
                [ws gameMessageWithContent:obj messageType:mType];
                [ws showGameTheEndView:obj];
            }else if (mType==ChatGameStake) {// 等待押注
                [ws gameMessageWithContent:obj messageType:mType];
            }else if (mType==ChatGameStakeEnd) {// 押注结束
                [ws gameMessageWithContent:obj messageType:mType];
            }else if(mType == ChatGameList){
            
                NSDictionary *dict = [obj mj_JSONObject];
//                NSDictionary *dict = [NSdic];
                ws.gameListView.userList = dict[@"user_list"];
            }
        };
     //点击事件
        [_gameCell.sendMessageBtn addTarget:self action:@selector(showSendMessageView) forControlEvents:UIControlEventTouchUpInside];
        [_gameCell.showGiftBtn addTarget:self action:@selector(showSendGiftView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  _gameCell;
    
}

- (void)setRoomInfo:(RoomInfo *)roomInfo{
    _roomInfo = roomInfo;
    if ([_roomInfo.area_id integerValue] > 0) {
       
        self.chatView.chatFucView.gift.hidden = NO;
        self.chatView.chatFucView.giftLable.hidden = NO;
        //根据ID请求网络数据
        
        [self requstGiftListForId:roomInfo.area_id];
        
    }else{
        
        self.chatView.chatFucView.gift.hidden = YES;
        self.chatView.chatFucView.giftLable.hidden = YES;
    }
    
}

- (void)requstGiftListForId:(NSString *)areId{
    
    
        
    if (areId == nil) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"area_id"] = areId;
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetPresentAreaByid param:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self showGiftListView:responseObject[@"data"]];
            
        }
        
        
        
    } faile:^{
        
    }];
    
    
    
}



- (void)showGiftListView:(NSDictionary *)gameMsgDict{
    
    NSDictionary *dict = [gameMsgDict mj_JSONObject];
    GameArea *areaModel;
    areaModel = [GameArea mj_objectWithKeyValues:dict[@"gif"]];
    if (areaModel == nil) {
        areaModel = [GameArea mj_objectWithKeyValues:dict];
    }
    if ([areaModel.ID integerValue] > 0) {
        
        if (!giftListView) {
            giftListView = [GiftListInvitaView viewFromeNib];
            giftListView.frame = CGRectMake(0, 20, KScreenWidth * 0.75, KScreenHeight * 0.4);
            giftListView.cancelListViewButton.hidden = NO;
            giftListView.cancelButton.hidden = YES;
            giftListView.joinbutton.hidden = YES;
            giftListView.yzgCenterX = self.view.center.x;
            giftListView.hidden = YES;
            [self.view addSubview:giftListView];
        }
        self.chatView.chatFucView.giftLable.hidden = NO;
        self.chatView.chatFucView.gift.hidden = NO;
        giftListView.dataArray = areaModel.rank_present_list;
 
    }else{
        
        self.chatView.chatFucView.giftLable.hidden = YES;
        self.chatView.chatFucView.gift.hidden = YES;
    }
   
    
    
}


- (NSMutableArray *)lianMaiUserArray{
    if (_lianMaiUserArray == nil) {
        _lianMaiUserArray = [NSMutableArray array];
    }
    return _lianMaiUserArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // [self.kit startPreview:self.playerSuperView];
    
}

-(void)viewDidLoad
{
    [AlertTool Hidden];
    [super viewDidLoad];
    //设置rtc参数
    [self setAgoraStreamerKitCfg];
    self.view.backgroundColor = [UIColor clearColor];
    [self addScrollView];
    [self addChatView];
    [self addBgmView];
    [self addNotiAndObserver];
    //    [self tapAct];
    //保持屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _kit = [ShowControl shareInstance].streamerKit;
    
    self.streamerBase = _kit.streamerBase;
    // 采集相关设置初始化
    [self setCaptureCfg];
    
    
    
    _ismaster = NO;
    _beQuit = NO;
    //设置拖拽手势
    panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    CGRect rect;
    rect.origin.x = _kit.winRect.origin.x * self.view.frame.size.width;
    rect.origin.y = _kit.winRect.origin.y * self.view.frame.size.height;
    rect.size.height =_kit.winRect.size.height * self.view.frame.size.height;
    rect.size.width =_kit.winRect.size.width * self.view.frame.size.width;
    
    _winRtcView =  [[UIView alloc] initWithFrame:rect];
    _winRtcView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_winRtcView];
    [self.view bringSubviewToFront:_winRtcView];
    [self.gameListView addGestureRecognizer:panGestureRecognizer];
    
    
    //
    
    //    // 默认加载游戏界面
    //    [self showGameView];
    
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //
    //
    ////        [self.playerSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
    ////
    ////            make.top.mas_offset(0);
    ////            make.centerX.mas_offset(self.view.center.x);
    ////            make.width.mas_equalTo(self.view.width * 0.25);
    ////            make.height.mas_equalTo(self.view.height * 0.5);
    ////
    ////        }];
    //
    //
    //
    //    });
    //
    
    [self setAgoraStreamerKitCfg];
    [self addLianMaiListView];
    
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moviePlayBackDidFinish:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moviePlayBackStateDidChange:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    //默认先设置接受游戏
    _isInvitation = YES;
    //默认为未连接，暂时没有更严谨的方法
    _isReconnect = NO;
    //进入界面判断用户是否已经掉线
//    [self showGameView];
    [self gameReconnect];
   //获取敏感词
    [self  getsensitiveWords];
    
    
}


- (void)getsensitiveWords{
    
    KWeakSelf;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetSensitiveWords param:nil success:^(id responseObject) {
       
        NSLog(@"%@",responseObject);
        ws.sensitiveWords = responseObject[@"data"];
        
    } faile:^{
        
    }];
    
    
    
    
}







#pragma -mark *************每次进来进行游戏连接************

- (void)gameReconnect{
    
    if (_chatViewStyle != ChatViewStyleHost) {
        
        return;
    }
    //每次进来先判断是否在游戏中再进行重新连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        KWeakSelf;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagIsStartMatch param:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 500) {
                //            进行从新连接
                
                KWeakSelf;
                [ws.gameCell gameConnect:^(BOOL isSuccess ,NSString *matchId, NSString *area_id) {
                    
                    if([area_id integerValue] > 0){
                        
                        [self requstGiftListForId:area_id];
                    }
                    
                    
                    if (isSuccess) {
                        
                        [ws showGameView];
                        
                        ws.gameCell.selectGameView.hidden = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [ws showGameView];
//                            ws.gameCell.headTitleLab.text = @"你已经掉线请等待主播发题即可重新进入游戏答题";
                        });
                        
                    }
                }];
            }
                
            } faile:^{
                
            }];
            
    });
    
    
}


//加载状态改变
- (void)loadStateDidChange:(NSNotification*)notification
{
    if (self.player.loadState !=  (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK)) {
        //        [AlertTool showWithCustomModeInView:self.playScrollView.middleImageView];
    }else{
        [AlertTool Hidden];
    }
}



- (void)addLianMaiListView{
    self.lianmaiListView = [LGUserLianMaiListView viewFromeNib];
    self.lianmaiListView.frame = self.view.frame;
    self.lianmaiListView.hidden = YES;
    self.lianmaiListView.delegate = self;
    [self.view addSubview:self.lianmaiListView ];
    
}
- (void) setCaptureCfg {
    _kit.capPreset = AVCaptureSessionPreset640x480;
    _kit.previewDimension = CGSizeMake(640, 360);
    _kit.streamDimension  = CGSizeMake(640, 360);
    _kit.videoFPS       = 15;
    //    _kit.cameraPosition = cameraPosition;
}


- (void)loadLiveStatus{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"uid"] = self.roomInfo.channel_creater;
    KWeakSelf;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetShowStatus param:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            ws.roomStatus = [responseObject[@"data"] integerValue];
            
        }
        
        
    } faile:^{
        
    }];
    
}

- (void)addBgmView{
    
    self.bgmView = [LGBgmVIew viewFromeNib];
    self.bgmView.frame = self.view.bounds;
    self.bgmView.hidden = YES;
    [self.view addSubview:self.bgmView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_showControl.streamerKit stopPip];
    [gameYzView removeFromSuperview],gameYzView=nil;
    [gameTheEndView removeFromSuperview],gameTheEndView=nil;
    _gameListView.hidden = YES;
}

-(RoomParam *)configParam{
    RoomParam *roomParam = [[RoomParam alloc]init];
    roomParam.room_id = self.roomInfo.room_id;
    //    roomParam.room_password = self.roomInfo.need_password;
    return roomParam;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}


#pragma -mark ************player delegate******************
//播放结束隐藏
- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    if (is_guard_status) {
        self.gameCell.videoView.hidden = YES;
        _gameCell.hidden = NO;
        
    }
    
}

//播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
       
        [AlertTool Hidden];
    }else{
         [AlertTool Hidden];
    }
}

-(void)addScrollView{
    ChatScrollView *scrollView = [[ChatScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:scrollView];
    self.scrollView =scrollView;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(KScreenWidth *2, 0);
    scrollView.contentOffset = CGPointMake(KScreenWidth, 0);
}

-(void)addChatView{
    ChatView *chatView = [[ChatView alloc]initWithStyle:self.chatViewStyle];
    chatView.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight);
    self.chatView = chatView;
    [self.scrollView addSubview:chatView];
    chatView.delegate = self;
    
    KWeakSelf;
    [[LeanCloudTool leanCloudTool] setUnreadCountBlock:^(NSInteger totalUnreadCount) {
        if (totalUnreadCount <=0) {
            ws.chatView.hadUnReadMessage = NO;
        }else{
            ws.chatView.hadUnReadMessage = YES;
        }
    }];
    
    
    [RoomModel getActivityinfoWithParam:nil success:^(id responseObj, BOOL successGetInfo) {
        if (successGetInfo) {
            chatView.activityinfo = responseObj;
        }
    }];
}
-(void)addNotiAndObserver{
    if (self.chatViewStyle == ChatViewStyleHost) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hostAppResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hostAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hostBgmPlayerStateDidChange:) name:YZGBgmPlayStateChange object:nil];
    }else{
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceivedMessage:) name:KLeanCloudToolReceivedLeanColudMessage object:nil];
    
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"roomInfo" options:NSKeyValueObservingOptionNew context:nil];
    
    //更新在线人数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNum:) name:@"userNum" object:nil];
    
    
    
}


#pragma mark - 获取实时人数更新
- (void)changeNum:(NSNotification *)notif
{
    NSLog(@"%@",notif.userInfo);
    //    NSLog(@"%@-------%@-------%@",self.roomInfo.channel_creater,[Account shareInstance].ID, _chatView.loopUpdateInfo.match_authority);
    
    if ([self.roomInfo.channel_creater integerValue]== [[Account shareInstance].ID integerValue])
    {
        NSLog(@"是主播自己");
        is_guard_status = YES;
        self.gameCell.guard_status = is_guard_status;
    }else{
        int num = [notif.userInfo[@"userNum"] intValue];
//        [self.chatView.layer addSublayer:[self creatEmitter:num]];
        [self.chatView.layer insertSublayer:[self creatEmitter:num] atIndex:0];
    }
}

// 向聊天面板发送消息
-(void)hostAppResignActive{
    ChatMessage *systemChatMessage = [self systemMessageWithContent:@"主播离开一下，精彩不中断，不要走开哦" messageType:ChatSystemMessage];
    [self sendMessage:systemChatMessage];
}

-(void)hostAppBecomeActive{
    ChatMessage *systemChatMessage = [self systemMessageWithContent:@"主播回来啦，视频即将恢复" messageType:ChatSystemMessage];
    [self sendMessage:systemChatMessage];
}

-(void)hostBgmPlayerStateDidChange:(NSNotification *)noti{
    YZGBgmState bgmPlayStateState = [noti.userInfo[YZGBgmPlayStateKey] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (bgmPlayStateState == YZGBgmStatePlaying){
            [self.chatView bgmPlayerIsPlying:YES];
            [self addLyricTimerAndStartLoadLyrics];
        }else if(bgmPlayStateState != YZGBgmStateStarting){
            [self.chatView bgmPlayerIsPlying:NO];
            [self stopLyricTimerAndStopLoadLyrics];
            NSLog(@"音乐结束");
        }
    });
}

-(void)addLyricTimerAndStartLoadLyrics{
    if (!self.lyricArray || self.lyricArray.count<=0) {
        [self stopLyricTimerAndStopLoadLyrics];
        return;
    }
    //加载歌词
    [self.chatView startLoadLyrics:self.lyricArray];
    //初始化定时器
    self.lyricTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(bgmPlayerCurrentTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.lyricTimer forMode:NSRunLoopCommonModes];
    [self.lyricTimer fire];
}

-(void)bgmPlayerCurrentTime{
    [self.chatView currentBgmPlayTime:self.showControl.bgmPlayTime];
}

-(void)stopLyricTimerAndStopLoadLyrics{
    [self.lyricTimer invalidate];
    self.lyricTimer = nil;
    [self.chatView stopLoadLyrics];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"roomInfo"]) {
        
        //加载房间状态
        [self loadLiveStatus];
        //获得房间信息,加载chatView信息
        if (self.chatViewStyle == ChatViewStyleHost) {
            [self addUpDateRoomInfoTimerInterval:10.0];
        }else if(self.roomInfo.minute_charge.integerValue >0){
            [self addUpDateRoomInfoTimerInterval:60.0];
        }
        self.guardStatus = self.roomInfo.guard_status;
        self.chatView.roomInfo = self.roomInfo;
        [self.chatView clearChatConversionData];
        [self joinConversationWithConversationId:self.roomInfo.leancloud_room];
        [self getAudienceList];
    }else if ([keyPath isEqualToString:@"idleTimerDisabled"]){
        if ([change[NSKeyValueChangeNewKey] isEqualToNumber:@0]) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    }
}
-(void)addUpDateRoomInfoTimerInterval:(NSTimeInterval)ti{
    if (!self.upDateRoomInfoTimer) {
        //初始化定时器
        self.upDateRoomInfoTimer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(updateRoomInfo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.upDateRoomInfoTimer forMode:NSRunLoopCommonModes];
        [self.upDateRoomInfoTimer fire];
    }
}

// 实时更新直播间状态
-(void)updateRoomInfo{
    RoomParam *roomParam = [self configRoomParmWithUserId:nil withRoomId:self.roomInfo.room_id];
    KWeakSelf;
    [RoomModel loadLiveRoomOnlineNumEarn:roomParam success:^(id loopUpdateInfo, BOOL successGetInfo){
        if (successGetInfo) {
            ws.chatView.loopUpdateInfo = loopUpdateInfo;
            
            // 值为0表示不具备，1表示具备, 2.表示是否开始竞猜
            is_match_authority = [[(RoomInfo *)loopUpdateInfo match_authority] integerValue];
            
        }else{
            [ws hostSendEndShowingMessage];
            [ws endShowingOrPlayWithInfo:loopUpdateInfo];
        }
    }];
}

-(void)endShowingOrPlayWithInfo:(id)endInfo{
    if (self.playOrShowError) {
        [self removeSelfFromParentControllerAndStopTimer];
        self.playOrShowError(endInfo);
    }
    self.playOrShowError = nil;
}

-(void)stopPlayOrShow{
    
    [self removeSelfFromParentControllerAndStopTimer];
    if (self.clickCloseButton){
        self.clickCloseButton();
    }
}

-(void)removeSelfFromParentControllerAndStopTimer{
    [self.upDateRoomInfoTimer invalidate];
    self.upDateRoomInfoTimer = nil;
    _kit = nil;
    _showControl = nil;
    [[ShowControl shareInstance] stopPreviewAndPush];
    [[ShowControl shareInstance].streamerKit leaveChannel];
   
    [self willMoveToParentViewController:nil];

    [self removeFromParentViewController];
}



// 进入房间提醒下
-(void)joinConversationWithConversationId:(NSString *)conversationId{
    if (!conversationId) {
        [self leanCloudConnectedErrorMessage:@"conversationId为nil,无法加入聊天室!"];
        return;
    }
    KWeakSelf;
    [LeanCloudTool leanCloudTool].currentConversationId = conversationId;
    [[LeanCloudTool leanCloudTool] joinConversationWithConversationId:conversationId callback:^(BOOL success, NSString *errorMessage) {
        if (success && ws) {
            for (RoomSystemMessage *sysMessage in ws.roomSystemMsgArray) {
                ChatMessage *systemChatMessage = [ws announcementMessageForContent:sysMessage.msg userName:sysMessage.title];
                [ws.chatView startShowChatMessage:systemChatMessage];
            }
            if (ws.chatViewStyle == ChatViewStyleAudience) {
                NSString *content = [NSString stringWithFormat:@"欢迎%@进入房间",[Account shareInstance].user_nicename];
                ChatMessage *enterChatMessage = [ws systemMessageWithContent:content messageType:ChatEnterMessage];
                [ws sendMessage:enterChatMessage];
            }
        }else{
            [ws leanCloudConnectedErrorMessage:errorMessage];
        }
    }];
}
/**
 更新观众
 */

#pragma mark - 获取观众个数
-(void)getAudienceList{
    RoomParam *roomParam = [self configRoomParmWithUserId:nil withRoomId:_roomInfo.room_id];
    KWeakSelf;
    [RoomModel getLiveRoomOnlineList:roomParam success:^(id userList, BOOL successGetInfo) {
        if (successGetInfo) {
            [ws.chatView startShowAudiences:userList];
        }
    }];
}

-(void)leanCloudConnectedErrorMessage:(NSString *)errorMessage{
    ChatMessage *systemChatMessage = [self systemMessageWithContent:errorMessage messageType:ChatSystemMessage];
    [self.chatView startShowChatMessage:systemChatMessage];
}
#pragma mark ---chatViewDelegate

-(void)changeVoice:(float)voice{
    [self.showControl changeBgmVoice:voice];
}

-(void)hostFinishShowingNormal{
    if (self.chatViewStyle == ChatViewStyleAudience) {
        [self endShowingOrPlayWithInfo:nil];
    }
}

-(void)hostSetGuard{
    self.guardStatus = @"1";
}
-(void)hostCancelGuard{
    self.guardStatus = @"0";
}


#pragma mark - 接受连麦*******************************
-(void)answerCall{
    if(self.chatViewStyle == ChatViewStyleAudience){
        //用户端
        [AlertTool  ShowInView:self.chatView onlyWithTitle:@"对方同意连麦正在建立连接请等待" hiddenAfter:2.5];
        if (self.answerCallInvitation) {
            
            self.answerCallInvitation(_roomInfo.room_id);
        }
    }else{
        
        

        
        //主播端
         _kit.cameraRect = CGRectMake(0, 0, 0, 0);
        [_kit joinChannel:[NSString stringWithFormat:@"julelive_%@",_roomInfo.room_id]];
        
    }
    
    //    else{
    
    
    //    }
}
///申请连麦的用户

- (void)joinUser:(ChatMessage *)userMessage{
    
    if (is_guard_status == NO) {
        
        return;
    }
    
    self.chatView.chatFucView.lianMaiCountButton.hidden = NO;
    if (self.lianMaiUserArray.count >= 3) {
        //发送人数已经满人的消息
        ChatMessage *rejectCall = [self configMessageForContent:userMessage.userId messageType:ChatLianMaiDiable giftInfo:nil];
        [self sendMessage:rejectCall];
        [self.chatView.chatFucView.lianMaiCountButton setTitle:@"3" forState:UIControlStateNormal];
        return;
    }
    
    ChatMessage *rejectCall = [self configMessageForContent:userMessage.userId messageType:ChatLianMaiAvailable giftInfo:nil];
    [self sendMessage:rejectCall];
    [self.lianMaiUserArray addObject:userMessage];
    [self.chatView.chatFucView.lianMaiCountButton setTitle:[NSString stringWithFormat:@"%zd",self.lianMaiUserArray.count] forState:UIControlStateNormal];
    self.lianmaiListView.userJoinArray = self.lianMaiUserArray;
}

- (void)lianMaiView:(LGUserLianMaiListView *)lianMaiListView ationType:(NSInteger)type message:(ChatMessage *)message{
    
    [self.lianMaiUserArray removeObject:message];
    lianMaiListView.userJoinArray = self.lianMaiUserArray;
    if (type == 1) {
        //接受邀请
        [self answerCall];
        ChatMessage *rejectCall = [self configMessageForContent:message.userId messageType:ChatLianMaiAccept giftInfo:nil];
        [self sendMessage:rejectCall];
        
    }else{
        //拒绝邀请
        ChatMessage *rejectCall = [self configMessageForContent:message.userId messageType:ChatRejectComingCall giftInfo:nil];
        [self sendMessage:rejectCall];
        //        [self rejectCall];
    }
    [self.chatView.chatFucView.lianMaiCountButton setTitle:[NSString stringWithFormat:@"%zd",self.lianMaiUserArray.count] forState:UIControlStateNormal];
    self.lianmaiListView.userJoinArray = self.lianMaiUserArray;
    if (self.lianMaiUserArray.count == 0) {
        self.chatView.chatFucView.lianMaiCountButton.hidden = YES;
    }
    ChatMessage *rejectCall = [self configMessageForContent:message.userId messageType:ChatLianMaiAvailable giftInfo:nil];
    self.lianmaiListView.hidden = YES;
    
}


#pragma mark - 拒绝连麦
-(void)rejectCall{
    if (self.chatViewStyle == ChatViewStyleHost) {
        //如果调用此代理方法的为主播,为观众拒绝连麦后,给主播发的消息,alert提示
        
    }else{
        [AlertTool ShowErrorInView:self.chatView withTitle:@"主播拒绝连麦"];
        //如果调用此代理方法的为观众,为拒绝主播的连麦邀请,则发消息,消息content为主播id
        ChatMessage *rejectCall = [self configMessageForContent:self.roomInfo.channel_creater messageType:ChatRejectComingCall giftInfo:nil];
        [self sendMessage:rejectCall];
    }
}


#pragma mark  *********点击更多按钮*********

-(void)chatView:(ChatView *)chatView clickMoreOpitionViewButtonType:(ChatMoreOpitionViewType)moreOpitionViewType{
    switch (moreOpitionViewType) {
        case ChatMoreOpitionChangeCamera:
        {
            [self.showControl switchCamera];
        }
            break;
        case ChatMoreOpitionChangeBeauty:
        {
            [self.showControl startOrStopBeauty];
        }
            break;
        case ChatMoreOpitionChangeTorch:
        {
            [self.showControl toggleTorch];
        }
            break;
        case ChatMoreOpitionMyGuards:
        {
            ChatGuardListController *guardList = [[ChatGuardListController alloc]init];
            KWeakSelf;
            guardList.setGuardCallBack = ^(NSString *ID){
                ChatMessage *chatMessage = [ws systemMessageWithContent:ID messageType:ChatHostSetGuard];
                [ws sendMessage:chatMessage];
            };
            guardList.cancelGuardCallBack = ^(NSString *ID){
                ChatMessage *chatMessage = [ws systemMessageWithContent:ID messageType:ChatHostCancelGuard];
                [ws sendMessage:chatMessage];
            };
            YZGCustomCrossPresent *crossPresent = [[YZGCustomCrossPresent alloc]init];
            [self customPresentWithCustomAnimatedTransitioning:crossPresent presentendViewController:guardList];
        }
            break;
        case ChatMoreOpitionBgmMusic:{
            self.bgmView.hidden = NO;
            KWeakSelf;
            self.bgmView.bgmPlayCallBack = ^(NSString *url, LGBgmCell *cell, LGBgmVIew *bgmView ,NSArray *bgmArray,NSIndexPath *index) {
                bgmView.hidden = YES;
                [ws.showControl.streamerKit.bgmPlayer stopPlayBgm];
                [ws.showControl.streamerKit.bgmPlayer startPlayBgm:url isLoop:NO];
                //播放时结束回调
                _index = index.row;
                ws.showControl.streamerKit.bgmPlayer.bgmFinishBlock = ^{
                    //自动播放下一首歌
                    if (_index < (bgmArray.count - 1)) {
                        ws.index ++;
                    }else{
                        ws.index = 0;
                    }
                    NSDictionary *dict = bgmArray[ws.index];
                    NSString *uri = dict[@"uri"];
                    [ws.showControl.streamerKit.bgmPlayer startPlayBgm:uri isLoop:NO];
                };
            };
            
        }  break;
        default:
            break;
    }
}

// 发送游戏消息
-(void)gameMessageWithSecond:(int )s messageType:(ChatMessageType )chatMessageType{
    [self gameMessageWithContent:_gameCell.gameMatchId messageType:chatMessageType];
}

-(void)gameMessageWithContent:(NSString *)msg messageType:(ChatMessageType )chatMessageType{
    
    ChatMessage *chatMessage = [[ChatMessage alloc]initWithUserName:@"游戏消息" content:msg userId:[Account shareInstance].ID userLevel:[Account shareInstance].user_level avatar:[Account shareInstance].avatar];
    chatMessage.statusType = ChatGameMessage;
    chatMessage.type = chatMessageType;
    
    [self sendMessage:chatMessage];
    NSLog(@"%zd",_gameCell.gmTimerMsg.hidden);
    
}

///主播点击开弹出游戏界面
-(void)chatView:(ChatView *)chatView clickGameButton:(UIButton *)button
{
    
    if (_gameCell.isPlaying == YES) {
        
        return;
    }
    
    if(is_guard_status)
    {
        
        //开启屏幕推流
        
        
        // 是主播
        if (is_match_authority==0){
            [AlertTool ShowErrorInView:self.view withTitle:@"您当前等级无法发起竞猜！"];
            return;
        }
        //开启游戏界面
        [self showGameView];
    }
    else{
        //        if(!_gameCell && !is_game_add){
        if(!_gameCell && !is_game_add){
            [AlertTool ShowErrorInView:self.gameCell.videoView withTitle:@"当前主播未开启游戏或游戏已经中!"];
            return;
        }
        if(!_gameCell){
            [self showAddGameMsgView];
        }else{
            [self showGameView];
        }
    }
}


#pragma mark- ****************显示游戏UI*********************
// 显示游戏UI
-(void)showGameView
{
    
    
    KWeakSelf;
    if (!_gameBgView)
    {
        _gameBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_gameBgView setBackgroundColor:[UIColor clearColor]];
        _gameBgView.hidden = NO;
        [_gameBgView setCenter:self.view.center];
//        [self.view addSubview:_gameBgView];
        
//        _gameCell = [[[NSBundle mainBundle] loadNibNamed:@"GameStartTableViewCell" owner:nil options:nil] firstObject];
        self.gameCell.width = self.view.bounds.size.width;
        self.gameCell.y = self.view.bounds.size.height;
        if(_onCapture){
             _onCapture(NO);
        }
       
        // 主播开启游戏，观众玩游戏
        BOOL guard_status = NO;
        if (is_guard_status){// 是主播
            guard_status = YES;
        }else{
            _gameCell.stateBtn.hidden=YES;
        }
        _gameCell.guard_status = guard_status;
        
        
        //如果有视频或者或者音乐则加载视频音乐
        KWeakSelf;
        _gameCell.GameUrlBlock = ^(NSString *urlStr,NSInteger match_type){
            
//            _showControl.streamerKit.pipLayer = 6;
            if([urlStr isKindOfClass:[NSNull class]] || !urlStr.length) {
                
                return ;
            }
            ws.gameCell.isPlaying = YES;
            //当前为音乐模式
            if (match_type == 4) {
               
                //发送消息给用户表示当前正在播放音乐
                if (is_guard_status == YES) {
                    
                    ChatMessage *message = [ws configMessageForContent:nil messageType:ChatGameShowMusic giftInfo:nil];
                    [ws sendMessage:message];
                    NSURL *url = [NSURL URLWithString:urlStr];
//                    self.showControl.streamerKit.pipRect
                    [ws.showControl.streamerKit startPipWithPlayerUrl:url bgPic:nil];
                }
                
                return ;
            }
            
//开启画中画
                if (urlStr.length) {
//                    [AlertTool showWithCustomModeInView:self.view];
//                    ws.gameCell.videoView.hidden = NO;
//                    //开始播放视频
//                    if (urlStr) {
//                        if (!self.player) {
//                            self.player  = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
//                            //                                ws.player.scalingMode = MPMovieScalingModeAspectFill;
//                            self.player.shouldAutoplay = YES;
//                            self.player.view.frame = ws.gameCell.videoView.bounds;
//
//                            [self.gameCell.videoView addSubview:self.player.view];
//                            [self.player prepareToPlay];
//                        }else{
//                            [self.player reset:NO];
//                            [self.player setUrl:[NSURL URLWithString:urlStr]];
//                            [self.player prepareToPlay];
//                        }
//                    }else{
//
//                        [self.player pause];
//                  }
            
                    
                NSURL *url = [NSURL URLWithString:urlStr];
                    
                    if (is_guard_status == YES) {
                        
                        ChatMessage *message = [ws configMessageForContent:nil messageType:ChatGameShowQuest giftInfo:nil];
                        [ws sendMessage:message];
                        
                        //发送消息给客户端
                        [ws.showControl.streamerKit startPipWithPlayerUrl:url bgPic:nil];
                        _gameCell.hidden = YES;
//                        _gameBgView.hidden = YES;
                        
                    }
                    
                }else{
                    if (is_guard_status == YES) {
//                        ws.gameBgView.hidden = NO;
                    _gameCell.hidden = NO;
                    //结束播放视频
                    [self.player pause];
                    ws.gameCell.videoView.hidden = YES;
                }
//                    [self.showControl.streamerKit stopPip];
                }
            
            
            //开启画中画
//            if([urlStr isKindOfClass:[NSNull class]]) {
//
//                return ;
//            }
//            if (urlStr.length) {
//                [AlertTool showWithCustomModeInView:self.view];
//                ws.gameCell.videoView.hidden = NO;
//                //开始播放视频
//                if (urlStr) {
//                    if (!self.player) {
//                        self.player  = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
//                        //                                ws.player.scalingMode = MPMovieScalingModeAspectFill;
//                        self.player.shouldAutoplay = YES;
//                        self.player.view.frame = ws.gameCell.videoView.bounds;
//
//                        [self.gameCell.videoView addSubview:self.player.view];
//                        [self.player prepareToPlay];
//                    }else{
//                        [self.player reset:NO];
//                        [self.player setUrl:[NSURL URLWithString:urlStr]];
//                        [self.player prepareToPlay];
//                    }
//                }else{
//
//                    [self.player pause];
//
//                }
//
//
//                //                        NSURL *url = [NSURL URLWithString:urlStr];
//                ////                        self.showControl.streamerKit.pipRect = CGRectMake(0, 0, 0, 0);
//                //                        [self.showControl.streamerKit startPipWithPlayerUrl:url bgPic:nil];
//
//            }else{
//
//
//                //结束播放视频
//                [self.player pause];
//                ws.gameCell.videoView.hidden = YES;
//                //                        [self.showControl.streamerKit stopPip];
//            }
            
            
            
        };
        
        
        
        //主播选好游戏类目跟价格之后回调。游戏状态回调
        
        _gameCell.gameStartViewBlock = ^(NSDictionary *d, NSInteger btnTag) {
            
            if (btnTag==0) {
                // 帮助
                NSLog(@"帮助");
            }else if (btnTag==1) {
                // 缩放
                NSLog(@"缩放");
               
                
                
                [ws.chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    //                         _chatView.chatConversationView.y = _chatView.chatConversationView.y + _gameCell.bounds.size.height * 0.75;
                    
                    make.bottom.mas_equalTo(-53);
                    
                    
                }];
                
             
                    [UIView animateWithDuration:0.3 animations:^{
                        if (ws.kit.callstarted == YES) {
                            
                           ws.kit.cameraRect = CGRectMake(0, 0, 0, 0);
                        }
                        
                        ws.gameCell.y = self.view.bounds.size.height;
                        if (_onCapture) {
                            _onCapture(NO);
                        }
                        
                        [self.view layoutIfNeeded];
                        
                    } completion:^(BOOL finished) {
                        ws.gameBgView.hidden= YES;
                    }];

                
               
            }else if (btnTag==2) {
                // 开启游戏
                NSLog(@"开启游戏");
            }else if (btnTag==3) {
              
                // 关闭游戏
                NSLog(@"关闭游戏");
                //关闭画中画
                [ws.kit stopPip];
                [sysTimer invalidate],sysTimer = nil;
                if (is_guard_status) {
                    [self gameMessageWithContent:@"主播主动退出，答题游戏被终止！！！" messageType:ChatGameStop];//主播主动关闭游戏
                }else{
                    [self gameMessageWithContent:@"您退出了答题游戏" messageType:ChatGameQuit];//观众主动关闭游戏
                }
                
                [ws.chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-53);
                }];
                
                [UIView animateWithDuration:0.3 animations:^{
                    ws.gameCell.y = self.view.bounds.size.height;
                    if (_onCapture) {
                        
                        _onCapture(NO);
                    }
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [ws.gameBgView removeFromSuperview],ws.gameBgView=nil;
                }];
            }
        };
    
        [ws.chatView addSubview:ws.gameCell];
    }
    else
    {
         ws.gameCell.hidden = ws.gameCell.isPlaying;
//        _kit
//        if (_kit.is) {
//            <#statements#>
//        }
       
        //弹出界面
        [ws.chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            //                         _chatView.chatConversationView.y = _chatView.chatConversationView.y + _gameCell.bounds.size.height * 0.75;
            
            make.bottom.mas_equalTo(-ws.gameCell.bounds.size.height);
            
            
        }];
        [UIView animateWithDuration:0.3 animations:^{
            if (ws.kit.callstarted == YES) {
                
                ws.kit.cameraRect = CGRectMake(0, 0, 0.5, 0.5);
                
            }
            [ws.view layoutIfNeeded];
            ws.gameCell.y = ws.view.bounds.size.height - ws.gameCell.bounds.size.height;
            if (_onCapture) {
                _onCapture(YES);
            }
           
            
        }];
    }
}

#pragma -mark *************Action************

- (void)showSendMessageView{
    
    self.chatView.chatBottomView.clickMessage();
    
}

- (void)showSendGiftView{
    
    
    [self.chatView showGift];
    
    
    
}




int i = 0;
#pragma mark **************按钮点击事件***************
-(void)chatView:(ChatView *)chatView clickButton:(UIButton *)button withEventType:(ChatViewTouchEventType)evenType{
    switch (evenType) {
        case ChatViewEventClickConversationList:{
            
            SisiConversationListController *conversationList = [[SisiConversationListController alloc]init];
            conversationList.needLeftBackButon = YES;
            
            [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:conversationList];
        }
            break;
        case ChatViewEventClickChongZhi:{
#pragma mark - 充值
            //            NSString *exchangeUrl = [NSString stringWithFormat:@"%@/portal/Appweb/recharge?token=%@",[YZGAppSetting sharedInstance].appUrl,[[Account shareInstance] token]];
            //            ChagerViewController *chager = [[ChagerViewController alloc]init];
            //            chager.title = @"充值";
            //            chager.url = exchangeUrl;
            //            [self presentNeedNavgation:YES presentendViewController:chager];
            
            
            CostViewController *cost = [[CostViewController alloc]init];
            [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:cost];
        }
            break;
        case ChatViewEventClickClose:{
            if (self.chatViewStyle == ChatViewStyleAudience) {
                [self stopPlayOrShow];
            }else{
                
                [self checkShowOrder];
                
            }
        }
            break;
        case ChatViewEventClickShare:{
            YZGShareView *shareView = [YZGShare yzgShareView];
            shareView.delegate = self;
        }
            break;
        case ChatViewEventClickZan:{
            AccountParam *param = [[AccountParam alloc]init];
            param.room_id = self.roomInfo.room_id;
            KWeakSelf;
            [[Account shareInstance] zanWithParam:param success:^(BOOL isSuccess, id result) {
                if (isSuccess) {
                    [ws sendMessage:[ws configMessageForContent:@"点亮了❤️" messageType:ChatCommendMessage giftInfo:nil]];
                }
            }];
        }
            break;
        case ChatViewEventClickCancelLianMai:{
            [ShowControl shareInstance].streamerKit.cameraRect = CGRectMake(0, 0, 1, 1);
            [[ShowControl shareInstance].streamerKit leaveChannel];
        }
            break;
        case ChatViewEventClickStopBgm:{
            [self.showControl stopPlayBgm];
        }
            break;
        case ChatViewEventClickPlayBgm:{
            ChatMusicController *music = [[ChatMusicController alloc] init];
            music.playMusicButtonClick =^(NSString *musicPath,NSArray *lyrics){
                self.lyricArray = [NSArray arrayWithArray:lyrics];
                [self.showControl startPlayBgmWithUrlString:musicPath];
            };
            [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:music];
        }
            break;
        case ChatViewEventClickAttentionHost:{
            AccountParam *param = [AccountParam accountParam];
            param.userid = self.roomInfo.channel_creater;
            KWeakSelf;
            [[Account shareInstance] attentionOrCancelAttentionWithCurrentButtonTitle:button.titleLabel.text WithParam:param success:^(BOOL isSuccess, id result) {
                if (isSuccess) {
                    if ([result containsString:@"已关注"]) {
                        [ws addAttentionMessage];
                    }
                }else{
                    [AlertTool ShowErrorInView:chatView withTitle:result];
                }
            }];
        }
            break;
        case ChatViewEventClickActivity:
        {
            BaseWebViewController *web = [[BaseWebViewController alloc]init];
            NSString *urlString = chatView.activityinfo[@"url"];
            web.url = [NSURL URLWithString:urlString];
            [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:web];
        }
            break;
        //显示用户排行榜
        case ChatViewEventClickList:
        {
             
            self.gameListView.hidden = NO;
            
            
            
        }
            break;
            
#pragma mark- 与主播连麦 ******************************
        case ChatViewEventClickLianMai:
        {
            
            //            julelive_
            
            if(self.chatViewStyle == ChatViewStyleHost){
                if (self.lianMaiUserArray.count <= 0) {
                    
                    [AlertTool  ShowInView:self.chatView onlyWithTitle:@"没有连麦请求" hiddenAfter:1.0];
                 
                }else{
                    
                    self.lianmaiListView.hidden = NO;
                }
                
            }else{
                
                
                ChatMessage *callMessage = [self configMessageForContent:_roomInfo.channel_creater messageType:ChatHadCallComing giftInfo:nil];
                [self sendMessage:callMessage];
                [AlertTool  ShowInView:self.chatView onlyWithTitle:@"正在与对方连麦,请等待对方同意." hiddenAfter:1.0];
 
            }
            
            //用户加入通道
            
            //            [self onJoinChannelBtn];
            
            
        }
            break;
            
        case   ChatViewEventClickGift:{
            
            giftListView.hidden = NO;
            
            
        } break;
#pragma mark 主播节目
        case ChatViewEventClickShow:{
            
            [AlertTool ShowInView:self.view];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = [Account shareInstance].token;
            param[@"uid"] = self.roomInfo.channel_creater;
            KWeakSelf;
            [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetShowStatus param:param success:^(id responseObject) {
                [AlertTool Hidden];
                if ([responseObject[@"code"] integerValue] == 200) {
                    
                    ws.roomStatus = [responseObject[@"data"] integerValue];
                    if (is_guard_status == NO && ws.roomStatus == 0) {
                        
                        [AlertTool ShowErrorInView:ws.view withTitle:@"主播已关闭节目！"];
                        return ;
                    }
                    [ws addShowView];
                    
                }
                
                
            } faile:^{
                [AlertTool Hidden];
            }];
            
            
        }
            
    }
}


//检查主播节目是否处理
- (void)checkShowOrder{
    
    
    [AlertTool showWithCustomModeInView:self.view withTitle:@"正在关闭直播间.."];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    param[@"token"] = [Account shareInstance].token;
    KWeakSelf;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagCheckShowOrder param:param success:^(id responseObject) {
        [AlertTool Hidden];
        if([responseObject[@"code"] integerValue] == 200) {
            //可以退出房间
            [AlertTool alertWithControllerTitle:@"提示" alertMessage:@"确定要退出直播吗?" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction * _Nullable action) {
                
                //
                
                [ws hostSendEndShowingMessage];
                [ws stopPlayOrShow];
            } cancleHandler:nil viewController:ws];
        }else{
            
            
            [self presentViewController:[AlertTool alertWithControllerTitle:@"关闭失败" alertMessage:@"你还有节目单未处理完成,请处理完成才能关闭直播间" withActionTitle:@"确定" handler:^(UIAlertAction * _Nullable action) {
                
            }] animated:YES completion:nil];
            
        }
        
        
    } faile:^{
        
    }];
    
    
}




#pragma mark 显示节目界面
- (void)addShowView{
    
    
    //进入用户选择节目
    LGDoOrderShowView *ordeView = [LGDoOrderShowView viewFromeNib];
    ordeView.frame = self.view.bounds;
    
    //是否主播自己
    KWeakSelf;
    if (is_guard_status == YES) {
        //进入主播节目界面
        ordeView.showSwitchCallback = ^(UISwitch *swith) {
            //开启节目
            NSInteger type = 0;
            NSString *message = @"";
            NSString *showMessage = @"";
            if (swith.on == NO) {
                //关闭
                type = 0;
                message = @"你确定要关闭节目吗";
                showMessage = @"操作成功!当前当前状态已设置为休息";
                //关闭节目
            }else{
                
                //开启节目
                type = 1;
                message = @"你确定要开启节目吗";
                showMessage = @"操作成功!当前当前状态已设置为开启";
                
            }
            
            
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"其他");
                [swith setOn:!swith.state animated:YES];
            }]];
            [aler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
                param[@"token"] = [Account shareInstance].token;
                param[@"type"] = @(type);
                
                [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagShowSwitch param:param success:^(id responseObject) {
                    
                    if ([responseObject[@"code"] integerValue] == 200) {
                        
                        [AlertTool ShowErrorInView:ws.view withTitle:showMessage];
                        
                    }else{
                        [swith setOn:!swith.state];
                    }
                    
                } faile:^{
                    [swith setOn:!swith.state];
                }];
                
                
            }]];
            
            [ws presentViewController:aler animated:YES completion:nil];
            
        };
        
        //主播点击
        
        __weak LGDoOrderShowView* wsOrdeView = ordeView;
        KWeakSelf;
        ordeView.userDoOrderShowCallback = ^(LGShowListModel *model, UIView *view) {
            LGShowListController *showList = [[LGShowListController alloc] init];
            showList.backFinish = ^{
                [wsOrdeView refresh];
            };
            showList.title = @"节目";
            [ws presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:showList];
        };
        
        ordeView.userDohowCallback = ^(NSString *itemId, UIView *view) {
            
            
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleAlert];
            
            
            [aler addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self doShowType:1 item_id:itemId tableView:wsOrdeView];
            }]];
            [aler addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self doShowType:2 item_id:itemId tableView:wsOrdeView];
            }]];
            [aler addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self doShowType:3 item_id:itemId tableView:wsOrdeView];
            }]];
            [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"其他");
            }]];
            
            
            
            
            [ws presentViewController:aler animated:YES completion:^{
                
            }];
        };
        
    }else{
        //观众点击
        ordeView.showSwitch.hidden = YES;
        ordeView.userDoOrderShowCallback = ^(LGShowListModel *model, UIView *view) {
            
            NSString *message = [NSString stringWithFormat:@"您确定要点播该节目吗？\n价格为:%.2f金币",model.price];
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"其他");
            }]];
            [aler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"token"] = [Account shareInstance].token;
                param[@"item_id"] = model.id;
                
                [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagDoOrderOshow param:param success:^(id responseObject) {
                    if ([responseObject[@"code"] integerValue] == 200) {
                        
                        [AlertTool ShowErrorInView:ws.view withTitle:@"点播成功!"];
                    }else{
                        
                        [AlertTool ShowErrorInView:ws.view withTitle:responseObject[@"descrp"]];
                    }
                    
                } faile:^{
                    
                }];
                
            }]];
            
            [ws presentViewController:aler animated:YES completion:nil];
            
        };
        
        
    }
    
    
    [ordeView.showSwitch setOn:self.roomStatus];
    [self.view addSubview:ordeView];
    //                [ordeView.tableView.mj_footer be]
    
    ordeView.uid = self.roomInfo.channel_creater;
    
    
    
    
    
}


- (void)doShowType:(NSInteger)type item_id:(NSString *)item_id tableView:(LGDoOrderShowView *)doshowView{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"item_id"] = item_id;
    param[@"type"] = @(type);
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagDoShow param:param success:^(id responseObject) {
        [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
        [doshowView refreshDoShowList];
    } faile:^{
        
    }];
    
}

-(void)chatView:(ChatView *)chatView clickButton:(UIButton *)button withAdministratorType:(ChatAdministratorType)administratorType{
    RoomParam *param = [RoomParam roomParam];
    param.room_id = self.roomInfo.room_id;
    
    switch (administratorType) {
        case ChatAdministratorInterrupt:
        {
            param.type = @1000;
        }
            break;
        case ChatAdministratorBlock:
        {
            param.type = @2000;
        }
            break;
        case ChatAdministratorHot:
        {
            param.type = @3000;
        }
            break;
        default:
            break;
    }
    [RoomModel administartorManageWithParam:param success:^(id responseObj, BOOL successGetInfo) {
        [AlertTool ShowInView:chatView onlyWithTitle:responseObj hiddenAfter:1.0];
    }];
}
-(void)chatView:(ChatView *)chatView sendMessageString:(NSString *)messageString isBroadcast:(BOOL)isBroadcast{
    ChatMessage *chatMessage = [self configMessageForContent:messageString messageType:ChatNomalMessage giftInfo:nil];
    if (isBroadcast) {
        chatMessage.type = ChatDanMuMessage;
        AccountParam *param = [[AccountParam alloc]init];
        param.room_id = self.roomInfo.room_id;
        KWeakSelf;
        [[Account shareInstance] sendDanmuToAnchorWithParam:param success:^(BOOL isSuccess, NSString * result) {
            if (isSuccess) {
                [ws sendMessage:chatMessage];
            }else{
                [AlertTool ShowInView:chatView onlyWithTitle:result hiddenAfter:1.0];
            }
        }];
    }else{
        [self sendMessage:chatMessage];
    }
}
/**
 点击收入
 */
-(void)chatView:(ChatView *)chatView touchIncomeWithId:(NSString *)ID{
    PersonalContributionController *contribution  = [[PersonalContributionController alloc]initWithID:ID];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController :contribution];
}
/**
 点击头像
 */
-(void)chatView:(ChatView *)chatView touchIconImageViewWithId:(NSString *)ID{
    ChatAlertController *alertInfomation = [[ChatAlertController alloc] initWithRoomInfo:self.roomInfo];
    alertInfomation.guardStatus = self.guardStatus;
    alertInfomation.ID = ID;
    KWeakSelf;
    alertInfomation.atentionClick = ^(){
        [ws addAttentionMessage];
    };
    alertInfomation.setGuardCallBack = ^(){
        ChatMessage *chatMessage = [ws systemMessageWithContent:ID messageType:ChatHostSetGuard];
        [ws sendMessage:chatMessage];
    };
    
#pragma -mark 建立与主播的连麦
    
    alertInfomation.startLianMai = ^(){
        ChatMessage *callMessage = [ws configMessageForContent:ID messageType:ChatHadCallComing giftInfo:nil];
        [ws sendMessage:callMessage];
        [AlertTool  ShowInView:ws.chatView onlyWithTitle:@"正在与对方连麦,请等待对方同意." hiddenAfter:1.0];
    };
    YZGCustomCrossPresent *crossPresent = [[YZGCustomCrossPresent alloc]init];
    [self customPresentWithCustomAnimatedTransitioning:crossPresent presentendViewController:alertInfomation];
}
/**
 发送礼物消息
 */
-(void)chatView:(ChatView *)chatView sendGiftInfo:(GiftInfo *)giftInfo {
    
    NSString *messageString = [NSString stringWithFormat:@"给主播送了一个%@",giftInfo.giftname];
    ChatMessage *chatMessage =  [self configMessageForContent:messageString messageType:ChatGiftMessage giftInfo:giftInfo];
    
    KWeakSelf;
    AccountParam *param = [[AccountParam alloc]init];
    param.room_id = self.roomInfo.room_id;
    param.giftid = giftInfo.giftid;
    param.number = @"1";
    
    [[Account shareInstance] sendGiftWithParam:param success:^(BOOL successGetInfo,id responseObj){
        
        [chatView giftSendSuccess:successGetInfo];
        
        if (successGetInfo) {
            chatMessage.other.totalEarn = [NSString stringWithFormat:@"%@",responseObj];
            [ws sendMessage:chatMessage];
        }else{
            NSString * title = responseObj;
            [AlertTool ShowInView:chatView  onlyWithTitle:title hiddenAfter:1.0];
        }
    }];
}

#pragma mark 发送消息方法
-(void)sendMessage:(ChatMessage *)chatMessage{
    KWeakSelf;
    [[LeanCloudTool leanCloudTool] sendChatMessage:chatMessage callback:^(BOOL success, NSString *errorMessage) {
        if (success) {
            if ((is_guard_status&&chatMessage.type!=ChatGameWait)&&chatMessage.type!=ChatGameRanking&&chatMessage.type!=ChatGameStart&&chatMessage.type!=ChatGameStake&&chatMessage.type!=ChatGameStakeEnd&&chatMessage.type!=ChatGameAdd&&chatMessage.type!=ChatGameQuit&&chatMessage.type!=ChatGameQuit) {
                //                if (chatMessage.type>106 && 105 > chatMessage.type) {
                [ws.chatView startShowChatMessage:chatMessage];
                //                }
                
            }
            if(!is_guard_status&&chatMessage.type<200){
                [ws.chatView startShowChatMessage:chatMessage];
            }
        }else{
            [AlertTool ShowInView:ws.chatView onlyWithTitle:errorMessage hiddenAfter:1.0];
        }
    }];
}
#pragma mark 配置other消息方法
-(ChatMessage *)configMessageForContent:(NSString *)content messageType:(ChatMessageType)messageType giftInfo:(GiftInfo *)giftInfo{
    Account *account = [Account shareInstance];
    ChatMessage *chatMessage = [[ChatMessage alloc]initWithUserName:account.user_nicename content:content userId:account.ID userLevel:account.user_level avatar:account.avatar];
    chatMessage.type = messageType;
    if (giftInfo) {
        ChatMessageOther *other = [ChatMessageOther other];
        other.giftInfo = giftInfo;
        chatMessage.other = other;
    }
    return chatMessage;
}
//系统公告
-(ChatMessage *)announcementMessageForContent:(NSString *)content userName:(NSString *)userName{
    ChatMessage *chatMessage = [[ChatMessage alloc]init];
    chatMessage.userName = userName;
    chatMessage.type = ChatAnnouncement;
    chatMessage.content = content;
    return chatMessage;
}
//系统消息
-(ChatMessage *)systemMessageWithContent:(NSString *)content messageType:(ChatMessageType )chatMessageType{
    ChatMessage *chatMessage = [[ChatMessage alloc]initWithUserName:@"系统消息" content:content userId:[Account shareInstance].ID userLevel:[Account shareInstance].user_level avatar:[Account shareInstance].avatar];
    chatMessage.type = chatMessageType;
    return chatMessage;
}
//主播结束直播消息
-(void)hostSendEndShowingMessage{
    ChatMessage *chatMessage = [self systemMessageWithContent:@"主播正常结束直播" messageType:ChatHostFinishShowingNormal];
    [self sendMessage:chatMessage];
}


-(void)addAttentionMessage{
    Account *account = [Account shareInstance];
    NSString *content = [NSString stringWithFormat:@"%@关注了主播",account.user_nicename];
    ChatMessage *enterChatMessage = [self systemMessageWithContent:content messageType:ChatSystemMessage];
    [self sendMessage:enterChatMessage];
}

#pragma mark ShareViewDelegate分享
-(void)yzgShareView:(YZGShareView *)shareView clickShareButtonType:(ShareButtonType)shareButtonType{
    ShareParam *param = [ShareParam shareParam];
    param.room_id = self.roomInfo.room_id;
    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
        if (successGetInfo) {
            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:nil];
        }
    }];
}

-(void)showAddGameMsgView
{
    if (!_gameCell) {
        [self showGameView];
    }
}

// 游戏押注
-(void)showGameYzView:(NSString *)msg
{
    if (gameYzView||isNoGameYzView||!msg) {
        return;
    }
    
    NSData *jsonData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return;
    }
    // 屏蔽游戏中的玩家
    //    BOOL other = NO;
    //    NSArray *list = dict[@"user_list"];
    //    for (NSDictionary *d in list) {
    //        if([d[@"user_id"] isEqual:[Account shareInstance].ID]){
    //            other = YES;
    //            break;
    //        }
    //    }
    //    if (other) {
    //        return;
    //    }
    
    gameYzView = [[UIView alloc] initWithFrame:self.view.bounds];
    [gameYzView setBackgroundColor:RGB_COLOR(0, 0, 0, 0.3)];
    [self.view addSubview:gameYzView];
    
    GameYZTableViewCell *gameYzCell = [[[NSBundle mainBundle] loadNibNamed:@"GameYZTableViewCell" owner:nil options:nil] firstObject];
    gameYzCell.center = gameYzView.center;
    //    gameYzCell.layer.borderWidth=1;
    //    gameYzCell.layer.borderColor=[UIColor whiteColor].CGColor;
    gameYzCell.dictJson = msg;
    [gameYzView addSubview:gameYzCell];
    gameYzCell.gameYzCloseBlock = ^{
        [gameYzView removeFromSuperview],gameYzView=nil;
        isNoGameYzView=NO;
    };
}
#pragma mark - 游戏结束
// 游戏完结
-(void)showGameTheEndView:(NSString *)msg
{
    
    
    if (gameTheEndView||isNoGameTheEndView) {
        return;
    }
    _gameCell.answerHintsLabel.hidden = YES;
    gameTheEndView = [[UIView alloc] initWithFrame:self.view.bounds];
    [gameTheEndView setBackgroundColor:RGB_COLOR(0, 0, 0, 0.3)];
    [self.view addSubview:gameTheEndView];
    
    GameTheEndTableViewCell *gameTheEndCell = [[[NSBundle mainBundle] loadNibNamed:@"GameTheEndTableViewCell" owner:nil options:nil] firstObject];
    gameTheEndCell.center = gameTheEndView.center;
    //    gameTheEndCell.layer.borderWidth=1;
    //    gameTheEndCell.layer.borderColor=[UIColor whiteColor].CGColor;
    gameTheEndCell.dictJson = msg;
    [gameTheEndView addSubview:gameTheEndCell];
    gameTheEndCell.gameTheEndCloseBlock = ^{
        [gameTheEndView removeFromSuperview],gameTheEndView=nil;
        isNoGameTheEndView=NO;
    };
    self.gameListView.hidden = YES;
    //结算完成隐藏
    [self.chatView hiddenGiftButton];
    
    
}

#pragma mark **************接收到消息包括游戏消息*********************

-(void)notificationReceivedMessage:(NSNotification *)noti
{
    NSDictionary *message = noti.object;
    ChatMessage *chatMessage = message[@"chatMessage"];
    
   
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"GAMEPLAY" object:nil];
    // 接收到游戏消息
    if (chatMessage.type>=200) {
        if (chatMessage.type != ChatGameWait) {
            [giftListInvitaView removeFromSuperview];
            giftListInvitaView = nil;
        }
        //通知用户开启播放
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GAMEPLAY" object:nil];
        
        
        NSDictionary *d = [chatMessage.content mj_JSONObject];
       
        
        if (d) {
            if (d[@"match_id"] && _isReconnect == NO) {
                _isReconnect = YES;
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"token"] = [Account shareInstance].token;
                param[@"match_id"] = d[@"match_id"];
                
                [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagIsJoinMatch param:param success:^(id responseObject) {
                    if ([responseObject[@"code"] integerValue] == 509) {
                        //
                        //那么就显示用户重连显示用户界面
                        if (_gameCell.gameStartViewBlock) {
                            [self showGameView];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                _gameCell.selectGameView.hidden = YES;
                                [self showGameView];
//                                self.gameCell.headTitleLab.text = @"你已经掉线请等待主播发题即可重新进入游戏答题";
                            });
                        }

                    }


                } faile:^{
                    _isReconnect = NO;
                }];
                
                if ([_matchId isEqualToString:_userMatchId]) {
                    _userMatchId = nil;
                   
                    
                }
                
            }
            
        }
        
        
        if(!_gameCell){
            [self showAddGameMsgView];
        }
        //用户每次收到用户列表就显示排行榜
        if (d[@"user_list"]) {
            
            
            
            self.gameListView.userList = d[@"user_list"];
//            self.gameListView.hidden = YES;
            
        }
        
        if (chatMessage.type == ChatGameStart) {
            
            [giftListInvitaView removeFromSuperview];
            giftListInvitaView = nil;
        }
        
        if (chatMessage.type == ChatGameRanking) {
            alertAddGame=nil;
            _gameCell.gameMessage = chatMessage;
            [self showGameTheEndView:chatMessage.content];
             [_showControl.streamerKit stopPip];
            return;
        }
        
        if (chatMessage.type == ChatGameShowQuest) {
            //隐藏答题
            _gameCell.hidden = YES;
//            _gameBgView.hidden = YES;
            
        }
        
        
        if (!is_guard_status && chatMessage.type==ChatGameStake) {
            alertAddGame=nil;
            _gameCell.gameMessage = chatMessage;
            [self showGameYzView:chatMessage.content];
            
            return;
        }else{
            if(gameYzView&&chatMessage.type==ChatGameStakeEnd){
                alertAddGame=nil;
                [gameYzView removeFromSuperview],gameYzView=nil;
                [AlertTool ShowErrorInView:self.view withTitle:@"押注结束"];
                return;
            }
        }
        //        is_game_add = NO;
        //        if(!_gameCell&&chatMessage.type==ChatGameWait){
        //            if(!is_game_addNo){
        //                is_game_addNo = YES;
        //                [self showAddGameMsgView];
        //            }
        //        }
        if (!is_guard_status && chatMessage.type==ChatGameWait && d) {
            //            is_game_add = YES;
            //            _gameCell.gameMatchId = chatMessage.content;
            #pragma mark- ***********是否参加游戏*************
            if(!alertAddGame){
                
                
                //字符串转json
                NSDictionary *messageDict = [chatMessage.content mj_JSONObject];
                
                NSInteger bigpyte = [messageDict[@"bigType"] integerValue];
                 [self showGiftListView:messageDict];
                if (bigpyte == 2) {
                    
                    GameArea *areaModel = [GameArea mj_objectWithKeyValues:messageDict[@"gif"]];
                    
                 //礼物模式
                    if (!giftListInvitaView && _isInvitation == YES) {
                        giftListInvitaView = [GiftListInvitaView viewFromeNib];
//                        giftListInvitaView.ba
                        giftListInvitaView.width = 0.7 * KScreenWidth;
                        giftListInvitaView.height = 0.55 * KScreenHeight;
                        giftListInvitaView.center = self.view.center;
                         [self.view addSubview:giftListInvitaView];
                        giftListInvitaView.dataArray = areaModel.rank_present_list;
                      
                        KWeakSelf;
                        giftListInvitaView.hidden = NO;
                        __weak GiftListInvitaView *weakView = giftListInvitaView;
                        giftListInvitaView.joinBlock = ^(BOOL isJoin) {
                          
                            if (isJoin == NO) {
                                if (ws.gameCell.gameStartViewBlock) {
                                    ws.gameCell.gameStartViewBlock(nil, 1);
                                }
                                ws.isInvitation = NO;
                                //用户点击不参加20s后才提示是否加入游戏暂时没发现什么好的方法
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    ws.isInvitation = YES;
                                    
                                });
                                [weakView removeFromSuperview];
                                giftListInvitaView = nil;
                            }else{
                                
                                weakView.hidden = YES;
                                
                                NSString * meesage = [NSString stringWithFormat:@"当前加入游戏需要%@活力\n是否加入当前游戏？",areaModel.diamond_num];

                                [AlertTool alertWithControllerTitle:@"提示" alertMessage:meesage preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction * _Nullable action) {
                                    
                                    [ws joinGame];
                                    
                                    
                                } cancleHandler:^(UIAlertAction * _Nullable action) {
                                    
                                } viewController:ws];
                                
                                
                               
                            }
                            
                        };
                    }
                   
                    
                   
                    
                    
                    
                    
                }else{
                  //普通模式
                    NSString *msg = @"";
                    if([messageDict[@"price"] isKindOfClass:[NSNull class]]){
                        
                        msg = @"主播已开启智力答题活动，是否立即参加答题活动？";
                    }else{
                        
                        msg = [NSString stringWithFormat:@"主播已开启智力答题活动，当前游戏需要消耗%@%@是否立即参加答题活动？",messageDict[@"price"],kBenefit];
                    }
                    
                    
                    
                    
                    alertAddGame = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不参加" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //        [_gameBgView removeFromSuperview],_gameBgView=nil;
                        if (_gameCell.gameStartViewBlock) {
                            _gameCell.gameStartViewBlock(nil, 1);
                        }
                        
                        alertAddGame=nil;
                        _isInvitation = NO;
                        //用户点击不参加20s后才提示是否加入游戏暂时没发现什么好的方法
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            _isInvitation = YES;
                            
                        });
                        
                        
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"参加" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        [self joinGame];
                        
                        
                    }];
                    [alertAddGame addAction:cancelAction];
                    [alertAddGame addAction:okAction];
                    
                    if (_isInvitation == YES) {
                        
                        [self presentViewController:alertAddGame animated:YES completion:nil];
                    }
                    
                }
                    
                }

            if (!gzTimer) {
                gzTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    NSString *msg = @"[主播]发起了答题竞猜，如未加入的玩家请点击屏幕下方“小笑脸”按钮加入游戏！！！";
                    ChatMessage *message = [self systemMessageWithContent:msg messageType:ChatSystemMessage];
                    [self.chatView startShowChatMessage:message];
                }];
            }
        }
        
        //如果游戏为开始种那么久弹出游戏框
        if (chatMessage.type == ChatGameStart){
            
            [self showGame];
            
        }
        
        _gameCell.gameMessage = chatMessage;
        
         
        
        if (chatMessage.type==ChatGameStop||chatMessage.type==ChatGameFail){
            if (!is_guard_status)
                _gameCell.headTitleLab.text=@"";
            [self.chatView startShowChatMessage:chatMessage];
            alertAddGame=nil;
            
            // 玩家收到主播开启游戏失败后，关闭游戏窗口
            if (_gameCell&&(chatMessage.type==ChatGameStop||chatMessage.type==ChatGameFail)) {
                
                [_chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.mas_equalTo(-53);
                }];
                
                [UIView animateWithDuration:0.3 animations:^{
                    if (_kit.callstarted == YES) {
                        
                        _kit.cameraRect = CGRectMake(0, 0, 0, 0);
                    }
                    _gameCell.y = self.view.bounds.size.height;
                    if (_onCapture) {
                        _onCapture(NO);
                    }
                    
                    [self.view layoutIfNeeded];
                    
                    
                } completion:^(BOOL finished) {
                    [_gameBgView removeFromSuperview],_gameBgView=nil;
//                    [AlertTool ShowErrorInView:KKeyWindow withTitle:@"当前游戏被终止！！！"];
                    //                    is_game_addNo = NO;
                    isNoGameYzView= NO;
                    [gzTimer invalidate],gzTimer = nil;
                }];
            }
        }
    }
    else{
        
//        self.sensitiveWords;
        
        [self.chatView startShowChatMessage:[self replaceSensitiveWordsUserMessage:chatMessage]];
    }
}

- (void)showGame{
    
    [self.chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        //                         _chatView.chatConversationView.y = _chatView.chatConversationView.y + _gameCell.bounds.size.height * 0.75;
        
        make.bottom.mas_equalTo(-self.gameCell.bounds.size.height);
        
        
    }];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.kit.callstarted == YES) {
            
            self.kit.cameraRect = CGRectMake(0, 0, 0.5, 0.5);
            
        }
        [self.view layoutIfNeeded];
        self.gameCell.y = self.view.bounds.size.height - self.gameCell.bounds.size.height;
        if (_onCapture) {
            _onCapture(YES);
        }
        
        
    }];
    
}


#pragma mark - 加入游戏
- (void)joinGame{
    
//    if(_bgmView){
//
//        [_gameCell httprequestJoinMatch:^{
//            [self gameMessageWithContent:@"加入游戏" messageType:ChatGameAdd];
//            _gameCell.hidden=NO;
//            [_gameCell resSet];
//            [self showGameView];
//            //                            [UIView animateWithDuration:0.3 animations:^{
//            //
//            //                                [self.view layoutIfNeeded];
//            //
//            //                                //加入游戏
//            //
//            //                                    if (_kit.callstarted == YES) {
//            //
//            //                                        _kit.cameraRect = CGRectMake(0, 0, 0.5, 0.5);
//            //                                    }
//            //                                    _gameCell.y = self.view.bounds.size.height - _gameCell.bounds.size.height;
//            //
//            //                            }];
//        } faile:^{
//
//        }];
//
//    }else{
        if(_gameCell.gameStartViewBlock){
            
            _gameCell.gameStartViewBlock(nil, 1);
        }
        KWeakSelf;
        [_chatView.chatConversationView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            //                         _chatView.chatConversationView.y = _chatView.chatConversationView.y + _gameCell.bounds.size.height * 0.75;
            
            make.bottom.mas_equalTo(- ws.gameCell.bounds.size.height);
            
        }];
        
        [_gameCell httprequestJoinMatch:^{
            [ws gameMessageWithContent:@"加入游戏" messageType:ChatGameAdd];
            ws.gameCell.hidden=NO;
            [ws.gameCell resSet];
            [UIView animateWithDuration:0.3 animations:^{
                
                [ws.view layoutIfNeeded];
                
                //加入游戏
                
                if (ws.kit.callstarted == YES) {
                    
                    ws.kit.cameraRect = CGRectMake(0, 0, 0.5, 0.5);
                }
                ws.gameCell.y = ws.view.bounds.size.height - ws.gameCell.bounds.size.height;
                if (_onCapture) {
                    
                    _onCapture(YES);
                }
                
                
                
            }];
        } faile:^{
            
        }];
        
//    }
    
    
    
    
}

//铭感词语替换为***
- (ChatMessage *)replaceSensitiveWordsUserMessage:(ChatMessage *)message{
    NSString *content = [message.content stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (int i = 0; i < self.sensitiveWords.count; i ++) {
        
        NSString *sensitiveWord = self.sensitiveWords[i];
        NSString *replacWord = @"";
        for (int i = 0; i < sensitiveWord.length; i ++) {
            replacWord = [replacWord stringByAppendingString:@"*"];
        }
        content = [content stringByReplacingOccurrencesOfString:sensitiveWord withString:replacWord];
   
    }
    message.content = content;
    return message;
}


-(RoomParam*)configRoomParmWithUserId:(NSString *)userId withRoomId:(NSString *)roomId{
    RoomParam *roomParam = [RoomParam roomParam];
    roomParam.room_id = roomId;
    roomParam.ID = userId;
    return roomParam;
}

-(void)dealloc
{
    [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"idleTimerDisabled"];
    [self removeObserver:self forKeyPath:@"roomInfo"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[LeanCloudTool leanCloudTool] quitWithCallback:nil];
}

#pragma mark - 手势方法
- (void)tapAct
{
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    //   //点击的次数
    //    tap.numberOfTapsRequired = 1; // 单击
    //    //给self.view添加一个手势监测；
    //    [self.view addGestureRecognizer:tap];
    
}


- (void)SingleTap:(UITapGestureRecognizer *)tap
{
    
    //    [self dianzanAct];
    //    ChatMessage *chatMessage = [ChatMessage chatMessage];
    //    chatMessage.type = 4;
    //    [[LeanCloudTool leanCloudTool] sendChatMessage:chatMessage callback:^(BOOL success, NSString *errorMessage) {
    //    }];
    
    //     [self.chatView.layer addSublayer:[self emitterLayerdddd]];
}


#pragma mark - 小爪子动画 魏友臣 17/6/19
//- (CAEmitterLayer *)emitterLayer
//{
////    if (!_emitterLayer) {
////        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
////        emitterLayer.emitterPosition = CGPointMake(self.view.frame.size.width-70,self.view.frame.size.height-40);
////        emitterLayer.emitterSize = CGSizeMake(50, 50);
////        // 渲染模式
////        emitterLayer.renderMode = kCAEmitterLayerUnordered;
////        // 开启三维效果
////        //    _emitterLayer.preservesDepth = YES;
////        NSMutableArray *array = [NSMutableArray array];
////        NSArray *imageNames = @[@"橙色",@"淡蓝色",@"淡紫色",@"红色",@"金黄色",@"绿色"];
////        for (int i = 0; i<imageNames.count; i++) {
////            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
////            stepCell.birthRate = 0.8;
////            stepCell.lifetime = arc4random_uniform(3) + 1;//存活时间
////            stepCell.lifetimeRange = 1.0;//粒子效果的生成粒子数量
////            UIImage *image = [UIImage imageNamed:imageNames[i]];
////            stepCell.contents = (id)[image CGImage];
////            stepCell.velocity = arc4random_uniform(50) + 50;
////            stepCell.velocityRange = 55;
////            stepCell.emissionLongitude = -M_PI_2;;
////            stepCell.emissionRange = M_PI_2/4;
////            stepCell.scale = 0.3;
////            [array addObject:stepCell];
////        }
////        emitterLayer.emitterCells = array;
////        _emitterLayer = emitterLayer;
////    }
////    return _emitterLayer;
//}


- (CAEmitterLayer *)creatEmitter:(int)num
{
    
    
    int lifetimeRange = num>=10?3:1;
    
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
    }
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(self.view.frame.size.width-90,self.view.frame.size.height-40);
    emitterLayer.emitterSize = CGSizeMake(50, 50);
    // 渲染模式
    emitterLayer.renderMode = kCAEmitterLayerUnordered;
    // 开启三维效果
    //    _emitterLayer.preservesDepth = YES;
    NSMutableArray *array = [NSMutableArray array];
    NSArray *imageNames = lifetimeRange==1?@[@"橙色",@"金黄色",@"绿色"]:@[@"橙色",@"淡蓝色",@"淡紫色",@"红色",@"金黄色",@"绿色"];
    
    for (int i = 0; i<imageNames.count; i++) {
        CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
        stepCell.birthRate = 0.8;
        stepCell.lifetime = arc4random_uniform(3) + 1;//存活时间
        stepCell.lifetimeRange = lifetimeRange;//粒子效果的生成粒子数量
        UIImage *image = [UIImage imageNamed:imageNames[i]];
        stepCell.contents = (id)[image CGImage];
        stepCell.velocity = arc4random_uniform(50) + 50;
        stepCell.velocityRange = 55;
        stepCell.emissionLongitude = -M_PI_2;;
        stepCell.emissionRange = M_PI_2/4;
        stepCell.scale = 0.3;
        [array addObject:stepCell];
    }
    emitterLayer.emitterCells = array;
    _emitterLayer = emitterLayer;
    return _emitterLayer;
}



#pragma mark - 点赞动画

- (void)dianzanAct
{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = self.view.frame;
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 65, 30, 30);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 90, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.view addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 300);
    //  动画结束点的Y值
    CGFloat finishY = round(random() % 200);
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    NSArray *imageNames = @[@"橙色",@"淡蓝色",@"淡紫色",@"红色",@"金黄色",@"绿色"];
    int imageName = round(random() %5);
    
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:imageNames[imageName]];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}



#pragma mark - 连麦配置
- (void) setAgoraStreamerKitCfg {
    
    _kit.selfInFront = NO;
    _kit.agoraKit.videoProfile = AgoraRtc_VideoProfile_720P;
    //设置小窗口属性
    _kit.winRect = CGRectMake(0.5, 0.0, 0.5, 0.5);//设置小窗口属性
    _kit.rtcLayer = 4;//设置小窗口图层，因为主版本占用了1~3，建议设置为4
    
//    特性1：悬浮图层，用户可以在小窗口叠加自己的view，注意customViewLayer >rtcLayer,（option）
//        _kit.customViewRect = CGRectMake(0.6, 0.6, 0.3, 0.3);
//        _kit.customViewLayer = 5;
//            UIView * customView = [self createUIView];
//            [_kit.contentView addSubview:customView];
    
    //特性2:圆角小窗口
//    _kit.maskPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
    
    KWeakSelf;
    //kit回调，（option）
    _kit.onCallStart =^(int status){
        if(status == 200)
        {
            
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                
                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateConnected];
                [ws statEvent:@"建立连接" result:status];
            }
        }
        
        NSLog(@"oncallstart:%d",status);
    };
  
    _kit.onCallStop = ^(int status){
        
        ws.kit.cameraRect = CGRectMake(0, 0, 1, 1);
        if(status == 200)
        {
            
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                //正常自己断开连接
                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateStopCall];
                [ws statEvent:@"断开连接" result:status];
            }
        }else{
            //对方断开连接
//            ws.kit
            [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateStopCall];
            [ws.kit leaveChannel];
            //断开连接好后如果是主播端那么从新推流暂时还没发现好的办法
            if(self.chatViewStyle == ChatViewStyleHost){
//            [ws cleanShowControl];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHIBO" object:nil];
           
            }
            
            
        }
        NSLog(@"oncallstop:%d",status);
    };
    _kit.onChannelJoin = ^(int status){
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                ws.kit.cameraRect = CGRectMake(0, 0, 0.0, 0.0);
                [ws statEvent:@"成功加入" result:status];
                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStartCall];
                //                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateRegeistSuccess];
            }
        }
        NSLog(@"onChannelJoin:%d",status);
    };
    
    
}
-(void)cleanShowControl{
    if (self.showControl) {
        [self.showControl stopPreviewAndPush];
        self.showControl = nil;
    }
}

-(void)onLeaveChannelBtn
{
    [_kit leaveChannel];
}

- (void) onQuit{
    [_kit stopPreview];
    [_kit leaveChannel];
    _kit = nil;
    
    
}


#pragma mark - tool
-(void)statEvent:(NSString *)event
          result:(int)ret
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if(self.ctrlView.lblStat.text.length > 100)
    //            self.ctrlView.lblStat.text= @"";
    NSString *text = [NSString stringWithFormat:@"\n%@",event];

    [AlertTool ShowErrorInView:self.view withTitle:text];
    //
    //    });
}

-(void) onSwitchRtcView:(CGPoint)location
{
    CGRect winrect = _kit.winRect;
    
    //只有小窗口点击才会切换窗口
    if((location.x > winrect.origin.x && location.x <winrect.origin.x +winrect.size.width) &&
       (location.y > winrect.origin.y && location.y <winrect.origin.y +winrect.size.height))
    {
        _kit.selfInFront = !_kit.selfInFront;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint origin = [[touches anyObject] locationInView:self.view];
    CGPoint location;
    location.x = origin.x/self.view.frame.size.width;
    location.y = origin.y/self.view.frame.size.height;
    [self onSwitchRtcView:location];
}

-(void)panAction:(UIPanGestureRecognizer *)sender
{
    //获取手势在屏幕上拖动的点
    
    CGPoint translatedPoint = [panGestureRecognizer translationInView:self.view];
    
    panGestureRecognizer.view.center = CGPointMake(panGestureRecognizer.view.center.x + translatedPoint.x, panGestureRecognizer.view.center.y + translatedPoint.y);
    
    
    
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}



-(UIView *)createUIView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.layer.borderWidth = 10;
    view.layer.borderColor = [[UIColor blueColor] CGColor];
    return view;
}
-(void)postNotificationWithName:(NSString *)notificationName userInfoKey:(NSString *)key userInfoValue:(NSInteger)value{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{key:[NSNumber numberWithInteger:value]}];
}

- (GameListView *)gameListView{
    
    if (_gameListView == nil) {
        
        _gameListView = [GameListView viewFromeNib];
        _gameListView.frame = CGRectMake(KScreenWidth * 0.35, 20, KScreenWidth * 0.5, KScreenHeight * 0.4);
      
        [_gameListView setBackgroundColor:[UIColor whiteColor]];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:_gameListView];
    }
    
    return _gameListView;
    
}


@end


//
//  MovieViewController.m
//  Player
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlayerViewController.h"

#import "EndShowingController.h"

#import "RoomModel.h"
#import "RoomParam.h"
#import "RoomInfo.h"
#import "Account.h"

#import "PlayerLivingControl.h"
#import "ShowControl.h"
#import "LeanCloudTool.h"
#import "AlertTool.h"
@interface PlayerViewController ()<PlayerLivingControlDelegate>

@property (nonatomic , weak) UIImageView *backgroundImageView;



/**
 连麦推流
 */
@property (nonatomic , strong) ShowControl *showControl;

/**
 播放器
 */
@property (nonatomic , strong) PlayerLivingControl *playControl;

/**
 连麦view
 */
@property (nonatomic , strong) UIView *rtcView;
/**
 视频源
 */
@property (nonatomic , copy) NSString *channel_source;

@property (nonatomic , strong) UIView *playerSuperView;

/**
 同意主播连麦后才会有值,值为answerCallInvitation回调传过来的主播id
 */
@property (nonatomic , copy) NSString *hostId;

@property (nonatomic , weak) NSTimer *timer;

@end

@implementation PlayerViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString: self.avatar]];
    [self installPlayControl];
    [self initChatViewController];
    [self addNoti];
    [self loadRoomData];
    self.channel_source = self.video_url;
    
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resrefhPlay) name:@"GAMEPLAY" object:nil];
   
}





- (void)loadStateDidChange:(MPMovieLoadState)state{
    
    if (state ==  (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK)) {
      //播放完成
        [_timer invalidate];
        _timer = nil;
    }else{
     //播放失败
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadDataPlay) userInfo:nil repeats:YES];
        }
    }
    
    
    
}

- (void)resrefhPlay{
    
     [self reloadDataPlay];
    
}

- (void)reloadDataPlay{
    RoomParam *roomParam = [self configParam];
    KWeakSelf;
    [RoomModel enterRoomWithParam:roomParam success:^(id info, BOOL successGetInfo){
        if (successGetInfo) {
            RoomModel *roomModel = (RoomModel *)info;
           
            if ([_channel_source isEqualToString:roomModel.data.channel_source]) {
                
                return ;
            }
             ws.channel_source = roomModel.data.channel_source;
            [ws.playControl installPlayerWithUrlString:_channel_source];
        }else{
            [ws initEndShowingWithInfo:info];
        }
    }];
    
    
}


- (void)rctView{
    
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
}


-(void)loadRoomData{
    RoomParam *roomParam = [self configParam];
    KWeakSelf;
    [RoomModel enterRoomWithParam:roomParam success:^(id info, BOOL successGetInfo){
        if (successGetInfo) {
            RoomModel *roomModel = (RoomModel *)info;
            ws.chatViewController.roomInfo = roomModel.data;
            ws.chatViewController.roomSystemMsgArray = roomModel.msg;
            ws.channel_source = roomModel.data.channel_source;
            
            if ([_channel_source isEqualToString:roomModel.data.channel_source]) {
                
                return ;
            }
             [ws.playControl installPlayerWithUrlString:_channel_source];
        }else{
            [ws initEndShowingWithInfo:info];
        }
    }];
}

-(void)installPlayControl
{
    self.playControl = [PlayerLivingControl sharedInstance];
    self.playControl.delegate = self;
    self.playerSuperView = [[UIView alloc]init];
    [self.view addSubview:self.playerSuperView];
    KWeakSelf;
    [self.playerSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
//        make.left.top.right.bottom.mas_offset(10);
    }];
    [self.playControl installPlayerSuperView:self.playerSuperView];
}

-(void)playerLivingControlStartPlying{
    [self.backgroundImageView removeFromSuperview];
}

-(void)setChannel_source:(NSString *)channel_source{
    if (channel_source &&[_channel_source isEqualToString:channel_source]) return;
    _channel_source = [channel_source copy];
    [self.playControl installPlayerWithUrlString:_channel_source];
}

-(void)initChatViewController{
    self.chatViewController = [[ChatViewController alloc]initWithChatViewStyle:ChatViewStyleAudience];
    self.chatViewController.playerSuperView = self.playerSuperView;
    [self addChildViewController: self.chatViewController];
    [self.view addSubview: self.chatViewController.view];
    KWeakSelf;
    self.chatViewController.clickCloseButton =^{
        [ws.playControl uninstallPlayer];
        [ws cleanShowControl];
        [ws dismissViewControllerAnimated:YES completion:nil];
        [ws.navigationController popViewControllerAnimated:YES];
    };
    self.chatViewController.playOrShowError = ^(id info){
        if (ws.presentedViewController) {
            [ws dismissViewControllerAnimated:NO completion:nil];
        }
        [ws.playControl uninstallPlayer];
        [ws cleanShowControl];
        [ws initEndShowingWithInfo:info];
    };
    
    self.chatViewController.answerCallInvitation = ^(NSString *hostId){
        if (!ws.showControl) {
            ws.hostId = hostId;
            [ws showControlRegisterLocalid];
        }
    };
}

-(void)showControlRegisterLocalid{
    self.showControl = [ShowControl shareInstance];
//    [self.showControl rtcRegisterLocalid:[Account shareInstance].ID isAudience:YES];
//    self.chatViewController.showControl = self.showControl;
   [self.showControl.streamerKit joinChannel:[NSString stringWithFormat:@"julelive_%@",self.hostId]];
//    [[ShowControl shareInstance].streamerKit startPreview:self.view];
    [self startPreView];
//    [self.playControl uninstallPlayer];
    //恢复播放
//    [self.playControl installPlayerWithUrlString:self.channel_source];
}

-(void)cleanShowControl{
    if (self.showControl) {
        [self.showControl stopPreviewAndPush];
        self.showControl = nil;
    }
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianMaiStateDidChange:) name:YZGLianMaiStateChange object:nil];
}
-(void)lianMaiStateDidChange:(NSNotification *)noti{
    YZGLianMaiState lianMaiStateState = [noti.userInfo[YZGLianMaiStateKey] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (lianMaiStateState == YZGLianMaiStateRegeistSuccess) {
//            [self startPreView];
           
//            [self.showControl rtcStartCallRemoteid:self.hostId];
        
        }else if(lianMaiStateState == YZGLianMaiStateConnected){
            [self.playControl uninstallPlayer];
           }else if (lianMaiStateState == YZGLianMaiStateStopCall){
            //停止连麦
            [self stopCalling];
               
            //恢复播放
            [self.playControl installPlayerWithUrlString:self.channel_source];
        }else if (lianMaiStateState == YZGLianMaiStateError){
            //连麦出错
            [self stopCalling];
            [AlertTool ShowErrorInView:self.view withTitle:@"连麦出错"];
        }else if(lianMaiStateState == YZGLianMaiStateRegeistError){
            [self stopCalling];
            [AlertTool ShowErrorInView:self.view withTitle:@"连麦注册失败,请稍后重试"];
        }
    });
}

-(void)startPreView{
    
//    [ShowControl shareInstance].streamerKit.cameraRect = CGRectMake(0.5, 0, 0.5, 0.5);
    self.rtcView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.rtcView];
    [self.showControl startPreviewInview:self.rtcView];
    [self.view sendSubviewToBack:self.rtcView];
}
-(void)stopCalling{
    [self cleanShowControl];
    [self removeRTCView];
    self.hostId = nil;
}

-(void)removeRTCView{
    [self.rtcView removeFromSuperview];
    self.rtcView = nil;
}

-(RoomParam *)configParam{
    RoomParam *roomParam = [[RoomParam alloc]init];
    roomParam.room_id = self.room_id;
    roomParam.room_password = self.room_password;
    return roomParam;
}

-(void)initEndShowingWithInfo:(id)info{
    [[ShowControl shareInstance].streamerKit leaveChannel];
     [self.playControl uninstallPlayer];
    [self cleanShowControl];
    EndShowingController *end = [[EndShowingController alloc]initWithChatViewStyle:ChatViewStyleAudience withController:self];
    if ([info isKindOfClass:[NSString class]]) {
        end.errorInfo = info;
    }else if ([info isKindOfClass:[RoomModel class]]){
        RoomModel *roomModel = (RoomModel *)info;
        end.roomInfo = roomModel.data;
    }
    [self presentNeedNavgation:NO presentendViewController:end];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    [self sendExitRequest];
    [self sendExitMessage];
    [self cleanShowControl];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    [self sendExitRequest];
    [self sendExitMessage];
    [self cleanShowControl];
}

-(void)sendExitMessage{
    Account *account = [Account shareInstance];
    NSString *contet = [NSString stringWithFormat:@"%@ 离开房间",account.user_nicename];
    ChatMessage *chatMessage =[[ChatMessage alloc]initWithUserName:@"系统消息" content:contet userId:account.ID userLevel:account.user_level avatar:account.avatar];
    chatMessage.type = ChatExitMessage;
    [[LeanCloudTool leanCloudTool] sendChatMessage:chatMessage callback:nil];
}

-(void)sendExitRequest{
    RoomParam *roomParam = [self configParam];
    [RoomModel leaveRoomWithParam:roomParam success:nil];
}

-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView){
        UIImageView *imageview = [UIImageView new];
        [self.view addSubview:imageview];
        KWeakSelf;
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.view);
        }];
        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        _backgroundImageView = imageview;
    }
    return _backgroundImageView;
}
@end

//
//  ShowingController.m
//  liveFrame
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShowingController.h"
#import "ChatViewController.h"
#import "EndShowingController.h"
#import "BaseNavgationController.h"
#import "ShowingTopicController.h"

#import "ShowingTypeView.h"
#import "Account.h"
#import "AlertTool.h"

#import "RoomModel.h"
#import "RoomInfo.h"
#import "YZGShare.h"
#import "YZGAppSetting.h"
#import "ShowingFuncTypeView.h"
#import <libksygpulive/KSYGPUPipStreamerKit.h>
#import "KSYAgoraStreamerKit.h"
#import "HttpTool.h"
#import "GPUImageView.h"
@interface ShowingController ()<ShowControlShowingDelegate,ShowingTypeDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewToTop;

@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UITextField *showingTitle;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIButton *showingType;
@property (weak, nonatomic) IBOutlet UIButton *beauty;
@property (weak, nonatomic) IBOutlet UIButton *camera;
@property (weak, nonatomic) IBOutlet UIButton *startShowing;

@property (nonatomic , copy) NSString *room_price;
@property (nonatomic , copy) NSString *room_password;
@property (nonatomic , copy) NSString *room_privacy;
@property (nonatomic , copy) NSString *room_term_id;
@property (nonatomic , copy) NSString *minute_charge;

@property (nonatomic , strong) UIButton *selectedShareButton;
@property (nonatomic , strong) RoomModel *roomModel;

@property (nonatomic , strong) ChatViewController *chatViewController;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic, retain) KSYGPUPipStreamerKit * pipKit;
//选择类型
@property(nonatomic, strong) ShowingFuncTypeView *fucView;

@property(nonatomic, assign) BOOL isSetLoaction;
@property UIView      *preViews;

@end

@implementation ShowingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self setLayout];
    [self addNoti];
    [self initializeParam];
    self.room_term_id = @"1";
    [self configShowControl];
    
    [self locationButtonClick:self.location];
    [self receiveLocationUpdateMessage];
    self.showingTitle.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"你想要直播什么呢？" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //40*40
    NSArray *imageArray = @[@"微信",@"朋友圈",@"qq",@"qq空间"];
    for (int i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2.0-140+70*i,0,50,50)];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:0];
        button.tag = 222+i;
        [button addTarget:self action:@selector(shareAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:button];
    }
    
}

//半屏推流
- (void)banpush{
    
    _preView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 9 / 16)];
    
    
    
}



#pragma mark - 分享
- (void)shareAct:(UIButton *)button
{
    
    NSInteger shareButtonType = button.tag-221;
    ShareParam *param = [ShareParam shareParam];
    param.room_id = [Account shareInstance].token;
    [AlertTool showWithCustomModeInView:self.view];
    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
        [AlertTool Hidden];
        if (successGetInfo) {
            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:^(BOOL isSuccess, NSString *result) {
                //                [self startPush];
            }];
        }
    }];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self beginStartShow];
}

- (void)beginStartShow{
    
//     _preView.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth * 9.0 / 16);
     _preView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        CGSize preSz = _preView.frame.size;
    self.showControl.streamerKit.streamerProfile = KSYStreamerProfile_720p_auto;
    // 1. preView的宽高比大于1的情况下，需要避免根据方向进行调整previewDimension
    self.showControl.streamerKit.videoOrientation = preSz.width > preSz.height ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
//    CGSize preSz = _preView.frame.size;
    // 2. 设置采集画面输出方向(手机竖屏, 采集的画面也是竖屏)
    self.showControl.streamerKit.vCapDev.outputImageOrientation = UIDeviceOrientationPortrait;
    
    // 3. 根据_preView的[宽高比]进行设置预览和推流分辨率，即可做到任意size的半屏推流
      CGFloat ratio = preSz.height / preSz.width;
//    self.showControl.streamerKit.previewDimension = CGSizeMake(1080, 1080);
//    self.showControl.streamerKit.streamDimension = CGSizeMake(1080, 1080 );
   
    
    // 4. 开启预览
//    [self.showControl.streamerKit startPreview:self.preView];
    [self.showControl startPreviewInview:self.preView];
    
}

-(void)setLayout{
    self.startShowing.layer.cornerRadius = 40/2;
    self.startShowing.backgroundColor = [UIColor whiteColor];
    self.shareViewToTop.constant = self.shareViewToTop.constant *k5sHeightScale;
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateMessage) name:kAppUpDateCurrentPosition object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianMaiStateDidChange:) name:YZGLianMaiStateChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resPush) name:@"ZHIBO" object:nil];
    

}

-(void)receiveLocationUpdateMessage{
    
    _isSetLoaction = YES;
    self.location.userInteractionEnabled = YES;
    [self.location setTitle:[YZGAppSetting sharedInstance].currentCity forState:UIControlStateNormal];
    [[YZGAppSetting sharedInstance] updateCurrentLocationToServer:^(BOOL isSuccess,NSString *location) {
        
        
        
    }];
}

/**
 连麦状态通知
 
 @param noti noti
 */
-(void)lianMaiStateDidChange:(NSNotification *)noti{
    YZGLianMaiState lianMaiStateState = [noti.userInfo[YZGLianMaiStateKey] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (lianMaiStateState == YZGLianMaiStateHadCallComing) {
            [self.showControl rtcAnswerCall];
        }else if (lianMaiStateState == YZGLianMaiStateConnected){
            [AlertTool  ShowInView:self.preView onlyWithTitle:@"连麦成功..." hiddenAfter:1.0];
        }else if (lianMaiStateState == YZGLianMaiStateStopCall){
            [AlertTool  ShowInView:self.preView onlyWithTitle:@"连麦结束..." hiddenAfter:1.0];
        }
    });
}

-(void)configShowControl{
    self.showControl = [ShowControl shareInstance];
    self.showControl.showingDelegate = self;
    [self.showControl rtcRegisterLocalid:[Account shareInstance].ID isAudience:NO];
    self.beauty.selected = YES;
}

/**
 直播状态改变 showControl代理方法
 
 @param streamState 当前播放状态码
 */
-(void)showingStateDidChange:(YZGStreamState)streamState{
    if (streamState == YZGStreamStateConnected){
        [self startLiveCallBack];
    }
}

-(void)startLiveCallBack{
    //推流成功服务器回调
    RoomParam *param = [[RoomParam alloc]init];
    param.action = @"push";
    [RoomModel startLivePushCallback:param success:^(id responseObj, BOOL successGetInfo) {
        [self startShowRoomInfo];
    } faile:^{
        [self startShowRoomInfo];
    }];
}
-(void)startShowRoomInfo{
    if (self.chatViewController.roomInfo) {
        return;
    }
    self.chatViewController.roomSystemMsgArray = self.roomModel.msg;
    self.chatViewController.roomInfo = [self configRoomInfoWithRoomModel:self.roomModel];
}
-(RoomInfo *)configRoomInfoWithRoomModel:(RoomModel *)roomModel{
    RoomInfo *roomInfo = roomModel.data;
    roomInfo.avatar = [Account shareInstance].avatar;
    roomInfo.channel_creater = [Account shareInstance].ID;
    roomInfo.user_nicename = [Account shareInstance].user_nicename;
    roomInfo.total_earn = [Account shareInstance].sidou;
    return roomInfo;
}

-(void)initializeParam{
    self.room_privacy = @"0";
    self.room_price = @"0";
    self.room_password = nil;
}

#pragma mark ---按钮点击事件
- (IBAction)locationButtonClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开启定位"]) {
        sender.userInteractionEnabled = NO;
        [sender setTitle:@"定位中..." forState:UIControlStateNormal];
        [[YZGAppSetting sharedInstance] getCurrentLocation];
    }else{
        [sender setTitle:@"开启定位" forState:UIControlStateNormal];
    }
}

- (IBAction)showinTypeClick:(UIButton *)sender{
    ShowingTypeView *showingTypeView = [ShowingTypeView showingTypeView];
    showingTypeView.delegate = self;
    [self.view addSubview:showingTypeView];
    [showingTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    [showingTypeView setShowingTypeButtons:@[@"公开",@"私播",@"付费",@"密码",@"分钟"]];
}

-(void)clickShowingTypeButton:(ShowingType)showingType{
    [self initializeParam];
    
    if (showingType == ShowingTypePublic) {
        [self.showingType setTitle:@"公开" forState:UIControlStateNormal];
    }else if (showingType == ShowingTypePrivate){
        [self.showingType setTitle:@"私播" forState:UIControlStateNormal];
        self.room_privacy = @"1";
    }else if (showingType == ShowingTypePay) {
        [self pay];
    }else if (showingType == ShowingTypePassword){
        [self password];
    }else if (showingType == ShowingTypeMinuteCharge){
        [self minuteCharge];
    }
}

-(void)pay{
    [AlertTool alertWithTitle:nil message:@"请设置收费金额(每次)" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
        if (textFiled.text.length>0) {
            self.room_price = textFiled.text;
            [self.showingType setTitle:@"付费" forState:UIControlStateNormal];
        }
    } cancelButtonTitle:nil destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
}

-(void)password{
    [AlertTool alertWithTitle:nil message:@"请输入直播间密码" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
        
        if (textFiled.text.length>0) {
            self.room_password = textFiled.text;
            [self.showingType setTitle:@"密码" forState:UIControlStateNormal];
        }
    } cancelButtonTitle:nil destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
}
-(void)minuteCharge{
    [AlertTool alertWithTitle:nil message:@"请设置收费金额(每分钟)" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
        if (textFiled.text.length>0) {
            self.minute_charge = textFiled.text;
            [self.showingType setTitle:@"分钟" forState:UIControlStateNormal];
        }
    } cancelButtonTitle:nil destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
}
- (IBAction)beautyButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.showControl startOrStopBeauty] ;
}
- (IBAction)cameraButtonClick:(UIButton *)sender {
    [self.showControl switchCamera];
}
- (IBAction)tagButtonClick:(UIButton *)sender {
    ShowingTopicController *topicController = [[ShowingTopicController alloc]init];
    KWeakSelf;
    topicController.selectedTopic = ^(NSString *term_id,NSString *name){
        ws.room_term_id = term_id;
        [sender setTitle:name forState:UIControlStateNormal];
    };
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:topicController];
}

- (IBAction)shareButtonClick:(UIButton *)button
{
    self.selectedShareButton.selected = NO;
    self.selectedShareButton = button;
    self.selectedShareButton.selected =YES;
    
     [self startShare];
}

- (IBAction)closeButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startShowingButtonClick:(UIButton *)sender
{
//    if (self.selectedShareButton) {
//        [self startShare];
//    }else{
        [self startPush];
//    }
}
/**
 开始分享
 */
-(void)startShare{
    NSInteger shareButtonType = self.selectedShareButton.tag;
    ShareParam *param = [ShareParam shareParam];
    param.room_id = [Account shareInstance].token;
    [AlertTool showWithCustomModeInView:self.view];
    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
        [AlertTool Hidden];
        if (successGetInfo) {
            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:^(BOOL isSuccess, NSString *result) {
//                [self startPush];
            }];
        }
    }];
}
#pragma mark ---开始直播
/**
 开始推流
 */
-(void)startPush{
    
    if (_isSetLoaction == NO) {
        
         [AlertTool ShowErrorInView:self.view withTitle:@"正在获取当前位置请等待"];
        return;
    }
    
    RoomParam *param = [self configStartShowingParam];
//    [AlertTool showWithCustomModeInView:self.view];
    [AlertTool ShowInView:self.view];
    [RoomModel startLiveWithParam:param success:^(id response, BOOL successGetInfo) {
        if (successGetInfo){
            [AlertTool Hidden];
            RoomModel *roomModel = (RoomModel *)response;
            [self initChatViewController];
            self.roomModel = roomModel;
            [self startPushWithUrlString:roomModel.data.push_rtmp];
            [self.typeView removeFromSuperview];
        }else{
            [AlertTool ShowInView:self.view onlyWithTitle:response hiddenAfter:1.0];
        }
    }];
}

- (void)resPush{
    
                    
     [self startPushWithUrlString:self.roomModel.data.push_rtmp];
}

-(void)startPushWithUrlString:(NSString *)push_rtmp{
    [self.showControl startPushWithUrlString:push_rtmp];
    
}

-(void)initChatViewController
{
    for (UIView *view in self.view.subviews) {
        if (view != self.preView) {
            [view removeFromSuperview];
        }
    }
    ChatViewController *chatViewController = [[ChatViewController alloc]initWithChatViewStyle:ChatViewStyleHost];
    chatViewController.showControl = self.showControl;
    self.chatViewController = chatViewController;
    [self addChildViewController:chatViewController];
    [self.view addSubview:chatViewController.view];
    KWeakSelf;
    chatViewController.clickCloseButton =^{
        [ws cleanShowControl];
        [ws initEndShowingWithInfo:nil];
     };
    chatViewController.playOrShowError = ^(id info){
        if (ws.presentedViewController) {
            [ws dismissViewControllerAnimated:NO completion:nil];
        }
        [ws cleanShowControl];
        [ws initEndShowingWithInfo:info];
    };
    
    chatViewController.onCapture = ^(BOOL onCapture) {
        
//        [self.showControl stopPreView];
        
//        self.showControl.streamerKit.previewDimension = CGSizeMake(1920, 1080);
//        self.showControl.streamerKit.streamDimension = CGSizeMake(1920, 1080 );
//
//         self.showControl.streamerKit.cameraRect = CGRectMake(0, 0.0, 0, 0);
//          [self.showControl startPreviewInview:self.preView];
//        [self resPush];
//        return ;
        
        if (onCapture == YES) {
//             self.showControl.streamerKit.cameraRect = CGRectMake(0.25, 0.0, 0.5, 0.5);
//             [self.showControl stopPreview];
           //开启半屏幕推流
            // 半屏推流(预览视图不是全屏的, 预览视图的size如下)
//
//             _preView.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth * 9.0 / 16);
//            CGSize preSz = _preView.frame.size;
//            // 1. preView的宽高比大于1的情况下，需要避免根据方向进行调整previewDimension
//            self.showControl.streamerKit.videoOrientation = preSz.width > preSz.height ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
//            //    CGSize preSz = _preView.frame.size;
//            // 2. 设置采集画面输出方向(手机竖屏, 采集的画面也是竖屏)
//            self.showControl.streamerKit.vCapDev.outputImageOrientation = UIDeviceOrientationPortrait;
//
//            // 3. 根据_preView的[宽高比]进行设置预览和推流分辨率，即可做到任意size的半屏推流
//            CGFloat ratio = preSz.height / preSz.width;
//            self.showControl.streamerKit.previewDimension = CGSizeMake(1080, 1080 * ratio);
//            self.showControl.streamerKit.streamDimension = CGSizeMake(720, 720 *ratio);
//
//            // 4. 开启预览
//            //    [self.showControl.streamerKit startPreview:self.preView];
//            [self.showControl startPreviewInview:self.preView];
            
        }else{
           //关闭半屏推流
          self.showControl.streamerKit.cameraRect = CGRectMake(0, 0.0, 0, 0);
            
        }
        
        
    };
    
    
}

-(void)cleanShowControl{
    if (self.showControl) {
        [self.showControl stopPreviewAndPush];
        self.showControl = nil;
    }
}

-(void)initEndShowingWithInfo:(id)info{
    EndShowingController *end = [[EndShowingController alloc]initWithChatViewStyle:ChatViewStyleHost withController:self] ;
    if ([info isKindOfClass:[NSString class]]) {
        end.errorInfo = info;
    }else if ([info isKindOfClass:[RoomModel class]]){
        RoomModel *roomModel = (RoomModel *)info;
        end.roomInfo = roomModel.data;
    }
    [self presentNeedNavgation:NO presentendViewController:end];
}

-(RoomParam *)configStartShowingParam{
    RoomParam *param = [RoomParam roomParam];
    param.title = self.showingTitle.text;
    param.term_id = self.room_term_id;
    param.price = self.room_price;
    param.room_password = self.room_password;
    param.privacy = self.room_privacy;
    param.token = [Account shareInstance].token;
    if (![[self.location titleForState:UIControlStateNormal] isEqualToString:@"开启定位"]) {
        
//        NSString *location = [NSString stringWithFormat:@"%@-%@-%@",[YZGAppSetting sharedInstance].placemark.country,[YZGAppSetting sharedInstance].placemark.administrativeArea,[YZGAppSetting sharedInstance].currentCity];
        
//       param.location = [YZGAppSetting sharedInstance].currentCity;
//       param.longitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].longitude];
//       param.latitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].latitude];
        
        
    }
    
    return param;
}



-(void)dealloc{
    [self cleanShowControl];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//
//  ShowControl.m
//  sisitv
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "ShowControl.h"
#import <GPUImage/GPUImage.h>
#import <libksyrtclivedy/KSYRTCClient.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYRTCStreamerKit.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "KSYAgoraStreamerKit.h"
#import "KSYAgoraClient.h"

NSString * const YZGLianMaiStateChange  = @"YZGLianMaiStateDidChange";
NSString * const YZGBgmPlayStateChange  = @"YZGBgmPlayStateChange";

NSString * const YZGLianMaiStateKey  = @"YZGLianMaiStateKey";
NSString * const YZGBgmPlayStateKey  = @"YZGBgmPlayStateKey";



@interface ShowControl ()



@property (nonatomic , weak) UIView *preView;

@property (nonatomic , copy) NSString *pushingUrlString;

@property (nonatomic , copy) NSString *logText;
/**
 是否推流
 */
@property (nonatomic , assign) BOOL isPushing;
/**
 是连麦
 */
@property (nonatomic , assign) BOOL isCalling;
/**
 是否重新连接
 */
@property (nonatomic , assign) BOOL isReconnect;
/**
 连麦注册时是否是观众
 */
@property (nonatomic , assign) BOOL isAudience;
/**
 连麦注册时的id
 */
@property (nonatomic , copy) NSString *localid;
/**
 currentCameraState
 */
@property (nonatomic , assign) YZGCameraState currentCameraState;

@end

@implementation ShowControl
static ShowControl *showControl;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showControl = [[self alloc]init];
    });
    return showControl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showControl = [[super allocWithZone:zone]init];
    });
    return showControl;
}
-(KSYAgoraStreamerKit *)streamerKit{
    if (!_streamerKit) {
        // iOS 判断应用是否有使用相机的权限
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            YZGLog(@"相机权限受限");
            return nil;
        }
        if (TARGET_IPHONE_SIMULATOR) {
            
             _streamerKit = [[KSYAgoraStreamerKit alloc] initWithInterruptCfg];
            
        }else{
            
             _streamerKit = [[KSYAgoraStreamerKit alloc] initWithDefaultCfg];
        }
       
        // 打印版本号信息
        NSLog(@"vvvvvversion: %@", [_streamerKit getKSYVersion]);
        _streamerKit.bgmPlayer.bgmFinishBlock = ^{
            NSLog(@"bgmFinishBlock");
        };
    }
    return _streamerKit;
}
-(void)startPreviewInview:(UIView *)preView{
    self.preView = preView;
    [self addNoti];
    self.streamerKit.videoFPS = 15;
    [self.streamerKit startPreview:preView];
    [self startFliter];
    self.currentCameraState = YZGFrontCamera;
}
-(void)stopPreView{
    [self.streamerKit stopPreview];
}

-(void)startPushWithUrlString:(NSString *)pushUrlString{
    self.pushingUrlString = pushUrlString;
    if (self.pushingUrlString) {
        NSURL* pushingUrl = [[NSURL alloc] initWithString:pushUrlString];
        [self.streamerKit.streamerBase startStream:pushingUrl];
        self.isPushing = YES;
    }else{
        NSLog(@"pushUrlString为nil");
    }
}
-(void)stopStream{
    [self.streamerKit.streamerBase stopStream];
}
-(void)stopPreviewAndPush{
    [self rtcStopCall];
    [self stopPlayBgm];
    [self stopStream];
    [self stopPreView];
    [self rtcUnregister];
    if (!self.isReconnect) {
        [self resetPushingUrlStringAndPreViewAndLianMai];
    }
    self.streamerKit = nil;
    self.isReconnect = NO;
    self.isPushing = NO;
    self.isCalling = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)resetPushingUrlStringAndPreViewAndLianMai{
    self.preView = nil;
    self.pushingUrlString = nil;
    self.localid = nil;
    self.isAudience = NO;
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(streamStateChange)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bgmStateChange:)
                                                 name:KSYAudioStateDidChangeNotification
                                               object:nil];
}

-(void)appEnterBackground{
    if (self.isPushing || self.isCalling) {
        
        
    }else{
        // 进入后台时, 将预览从图像混合器中脱离, 避免后台OpenGL渲染崩溃
        [self.streamerKit.vPreviewMixer removeAllTargets];
        [self.streamerKit.vStreamMixer removeAllTargets];
        [self.streamerKit.aCapDev stopCapture];
    };
}
-(void)appBecomeActive{
    if (self.isPushing || self.isCalling) {
        
    }else{
        [self.streamerKit setupFilter:self.streamerKit.filter];
        [self.streamerKit.aCapDev startCapture];
    };
}

-(void)streamStateChange{
    NSInteger streamState = self.streamerKit.streamerBase.streamState;
    YZGLog(@"streamState: %zd ========",streamState);
    if ( streamState == YZGStreamStateIdle) {
        [AlertTool showWithCustomModeInView:self.preView];
    }else if ( streamState == YZGStreamStateConnected){
        [AlertTool  Hidden];
        [self.showingDelegate showingStateDidChange:streamState];
    }else if ( streamState == YZGStreamStateConnecting ) {
        [AlertTool showWithCustomModeInView:self.preView ];
    }else if ( streamState == YZGStreamStateDisconnecting ) {
        [AlertTool  ShowInView:self.preView onlyWithTitle:@"与推流服务器断开连接..." hiddenAfter:1.0];
    }else if ( streamState == YZGStreamStateError && self.pushingUrlString) {
 
        [AlertTool  ShowInView:self.preView onlyWithTitle:@"推流服务器连接出错..." hiddenAfter:1.0];
//        KSYStreamErrorCode errorCode = self.streamerKit.streamerBase.streamErrorCode;
//        self.isReconnect = YES;
//        [self stopPreviewAndPush];
//        [self tryReconnectWithErrorCode:errorCode];
    }
}
- (void)tryReconnectWithErrorCode:(KSYStreamErrorCode) errorCode{
    if (errorCode == KSYStreamErrorCode_CONNECT_BREAK) {
        [self tryReconnect];
    }
}
- (void)tryReconnect{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        NSLog(@"-=-=--=正在重连..");
        [self startPreviewInview:self.preView];
        [self rtcRegisterLocalid:self.localid isAudience:self.isAudience];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            [self startPushWithUrlString:self.pushingUrlString];
        });
    });
}
-(void)switchCamera{
    if (self.currentCameraState == YZGCameraSwitching) return;
    self.currentCameraState = YZGCameraSwitching;
    if ([self.streamerKit switchCamera]) {
        if ([self.streamerKit isTorchSupported]) {
            self.currentCameraState = YZGRearCamera;
        }else{
            self.currentCameraState = YZGFrontCamera;
        }
    }else{
        [AlertTool ShowErrorInView:KKeyWindow withTitle:@"切换摄像头失败"];
    }
}
-(void)toggleTorch{
    if ([self.streamerKit isTorchSupported]) {
        [self.streamerKit toggleTorch];
    }else{
        [AlertTool ShowErrorInView:KKeyWindow withTitle:@"当前摄像头无法开启闪光灯"];
    }
}

-(void)startOrStopBeauty{
    if (self.streamerKit.filter) {
        [self stopFliter];
    }else{
        [self startFliter];
    }
}
-(void)startFliter{
    KSYBeautifyFaceFilter *filter = [[KSYBeautifyFaceFilter alloc] init];
    filter.grindRatio = 0.8;
    filter. whitenRatio = 1.0;
    [self.streamerKit setupFilter:filter];
}
-(void)stopFliter{
    //取消滤镜只要将_filter置为nil就行
    [self.streamerKit setupFilter: nil];
}
-(void)changeBgmVoice:(float)voice{
    self.streamerKit.bgmPlayer.bgmVolume = voice;
    [self.streamerKit.aMixer setMixVolume:voice of:self.streamerKit.bgmTrack];
}
-(float)bgmVoice{
    return self.streamerKit.bgmPlayer.bgmVolume;
}

-(BOOL)isBeauty{
    if (self.streamerKit.filter) {
        return YES;
    }
    return NO;
}

-(void)startPlayBgmWithUrlString:(NSString *)urlString{
    [self stopPlayBgm];
    if (urlString) {
        [self.streamerKit.bgmPlayer startPlayBgm:urlString isLoop:NO];
    }else{
        NSString *defaultMusic =  [[NSBundle mainBundle] pathForResource:@"fanrenge" ofType:@"mp3"];
        [self.streamerKit.bgmPlayer startPlayBgm:defaultMusic isLoop:NO];
    }
}
-(void)bgmStateChange:(NSNotification *)noti{
    NSInteger bgmPlayState = self.streamerKit.bgmPlayer.bgmPlayerState;
    [self postNotificationWithName:YZGBgmPlayStateChange userInfoKey:YZGBgmPlayStateKey userInfoValue:bgmPlayState];
}
-(void)stopPlayBgm{
    if (self.isPlayingBgm) {
        [self.streamerKit.bgmPlayer stopPlayBgm];
    }
}
-(BOOL)isPlayingBgm{
    return self.streamerKit.bgmPlayer.isRunning;
}
-(float)bgmPlayTime{
    return self.streamerKit.bgmPlayer.bgmPlayTime;
}

- (void)rtcRegisterLocalid:(NSString *)localid isAudience:(BOOL)isAudience{
//    self.streamerKit.selfInFront = isAudience;
//    self.localid = localid;
//    [self setRtcSteamerCfg];
//    self.streamerKit.rtcClient.localId = [NSString stringWithFormat:@"%@",self.localid];
//    NSString *urlString = [NSString stringWithFormat:@"http://rtc.vcloud.ks-live.com:6002/rtcauth?uid=%@",localid];
//    NSURL *requestURL = [NSURL URLWithString:urlString];
//    //发送请求
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            self.logText = @"authString--申请authString成功/n";
//            self.streamerKit.rtcClient.authString=[NSString stringWithFormat:@"https://rtc.vcloud.ks-live.com:6001/auth?%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
//            [self.streamerKit.rtcClient registerRTC];
//        }else{
//            NSLog(@"申请authString失败:%@",[error localizedDescription]);
//        }
//
//        NSLog(@"%@",self.logText);
//    }];
//    [task resume];
}
- (void)rtcUnregister{
//    int ret = [self.streamerKit.rtcClient unRegisterRTC];
//    NSLog(@"rtcUnregister ret:%d",ret);
}
-(void)rtcStartCallRemoteid:(NSString *)remoteid{
//    int ret = [self.streamerKit.rtcClient startCall:remoteid];
//    NSString * event = [NSString stringWithFormat:@"发起呼叫,remote_id:%@",remoteid];
//    YZGLog(@"%@---%d",event,ret);
}
- (void)rtcStopCall{
//    int ret = [self.streamerKit.rtcClient  stopCall];
//    self.isCalling = NO;
//    YZGLog(@"rtcStopCall ---%d" ,ret);
    [self.streamerKit leaveChannel];
    [self.streamerKit stopPreview];
    
}

- (void)rtcRejectCall{
//    int ret = [self.streamerKit.rtcClient  rejectCall];
//    YZGLog(@"rtcRejectCall ---%d" ,ret);
}

- (void)rtcAnswerCall{
//    int ret = [self.streamerKit.rtcClient answerCall];
//    YZGLog(@"应答:ret:%d",ret);
//    self.isCalling = YES;
}

- (void)setRtcSteamerCfg {
//    //设置鉴权信息
//    self.streamerKit.rtcClient.authString = nil;//设置ak/sk鉴权信息,本demo从testAppServer取，客户请从自己的appserver获取。
//    //设置音频属性
//    self.streamerKit.rtcClient.sampleRate = 44100;//设置音频采样率，暂时不支持调节
//    //设置视频属性
//    self.streamerKit.rtcClient.videoFPS = 15; //设置视频帧率
//    self.streamerKit.rtcClient.videoWidth = 360;//设置视频的宽高，和当前分辨率相关,注意一定要保持16:9
//    self.streamerKit.rtcClient.videoHeight = 640;
//    self.streamerKit.rtcClient.MaxBps = 256000;//设置rtc传输的最大码率,如果推流卡顿，可以设置该参数
//    //设置小窗口属性
//    self.streamerKit.winRect = CGRectMake(0.69, 0.60, 0.3, 0.3);//设置小窗口属性
//    self.streamerKit.rtcLayer = 4;//设置小窗口图层，因为主版本占用了1~3，建议设置为4
//    
//    //特性1：悬浮图层，用户可以在小窗口叠加自己的view，注意customViewLayer >rtcLayer,（option）
//    //    self.streamerKit.customViewRect = CGRectMake(0.6, 0.6, 0.3, 0.3);
//    //    self.streamerKit.customViewLayer = 5;
//    [self.streamerKit.contentView addSubview:[self createUIView]];
//    //特性2:圆角小窗口
//    //    self.streamerKit.maskPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
//    
//    
//    KWeakSelf;
//    self.streamerKit.rtcClient.onRegister= ^(int status){
//        if (status !=200) {
//            ws.logText = @"连麦注册失败/n";
//            [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateRegeistError];
//        }else{
//            ws.logText = @"连麦注册成功/n";
//            [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateRegeistSuccess];
//        }
//        NSLog(@"%@",ws.logText);
//    };
//    self.streamerKit.rtcClient.onUnRegister= ^(int status){
//        NSLog(@"unregister callback-status:%d",status);
//    };
//    self.streamerKit.rtcClient.onCallInComing =^(char* remoteURI){
//        [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateHadCallComing];
//    };
//    //kit回调，（option）
//    self.streamerKit.onCallStart =^(int status){
//        ws.logText = [NSString stringWithFormat:@"rtc--statusCode---%d",status];
//        YZGLog(@"%@",ws.logText);
//        if (status == 100) {
//            //100 ==>连麦(StartCall)请求发送成功
//            [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStartCall];
//        }
//        else if(status == 200)
//        {
//            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
//            {
//                //200 ==>连麦成功
//                ws.isCalling = YES;
//                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateConnected];
//            }
//        }else {
//            ws.isCalling = NO;
//            [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateError];
//        }
//    };
//    self.streamerKit.onCallStop = ^(int status){
//        //停止连麦
//        ws.isCalling = NO;
//        [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateStopCall];
//        if(status == 200)
//        {
//            YZGLog(@"断开连接ok" );
//        }
//        else if(status == 408)
//        {
//            YZGLog(@"408超时" );
//        }
//    };
}
-(void)postNotificationWithName:(NSString *)notificationName userInfoKey:(NSString *)key userInfoValue:(NSInteger)value{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:@{key:[NSNumber numberWithInteger:value]}];
}

-(UIView *)createUIView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    view.layer.borderWidth = 10;
    view.layer.borderColor = [[UIColor blueColor] CGColor];
    return view;
}

#pragma mark - 连麦配置
//- (void) setAgoraStreamerKitCfg {

//    _streamerKit.selfInFront = NO;
//    _streamerKit.agoraKit.videoProfile = AgoraRtc_VideoProfile_DEFAULT;
//    //设置小窗口属性
//    _streamerKit.winRect = CGRectMake(0.6, 0.6, 0.3, 0.3);//设置小窗口属性
//    _streamerKit.rtcLayer = 4;//设置小窗口图层，因为主版本占用了1~3，建议设置为4
//    
//    //特性1：悬浮图层，用户可以在小窗口叠加自己的view，注意customViewLayer >rtcLayer,（option）
//    _streamerKit.customViewRect = CGRectMake(0.6, 0.6, 0.3, 0.3);
//    _streamerKit.customViewLayer = 5;
//    //    UIView * customView = [self createUIView];
//    //    [_kit.contentView addSubview:customView];
//    
//    //特性2:圆角小窗口
//    _streamerKit.maskPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
//    
//    KWeakSelf;
//    //kit回调，（option）
//    _streamerKit.onCallStart =^(int status){
//        if(status == 200)
//        {
//            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
//            {
//                NSLog(@"建立连接");
//                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateHadCallComing];
//                ws.isCalling = YES;
//            }
//        }else{
//             ws.isCalling = YES;
//            
//        }
//        
//        NSLog(@"oncallstart:%d",status);
//    };
//    _streamerKit.onCallStop = ^(int status){
//        if(status == 200)
//        {
//            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
//            {
//                NSLog(@"断开连接");
//                 [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateStopCall];
//            }
//        }
//        NSLog(@"oncallstop:%d",status);
//    };
//    _streamerKit.onChannelJoin = ^(int status){
//        if(status == 200)
//        {
//            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
//            {
//                 NSLog(@"成功加入");
//                [ws postNotificationWithName:YZGLianMaiStateChange userInfoKey:YZGLianMaiStateKey userInfoValue:YZGLianMaiStateConnected];
//            }
//        }
//        NSLog(@"onChannelJoin:%d",status);
//    };
//    
    
//}



@end

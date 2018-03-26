//
//  BaseTabBarController.m
//  liveFrame
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavgationController.h"
#import "MainViewController.h"
#import "MineViewController.h"
#import "ShowingController.h"
#import "YZGAppSetting.h"
#import "Account.h"
#import "YZGTabBar.h"
#import "BaseWebViewController.h"
#import "AlertTool.h"
#import "RootTool.h"
#import "showTypeContronller.h"
#import "LGFucView.h"
#import "VideoEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AliyunVideoRecordParam.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoCropParam.h"
#import "AliyunMediator.h"
#import "LGUserPlayerView.h"
#import "LGUserMediaViewController.h"
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDKPro/AliyunVideoSDKPro.h>
#else
#import "AliyunMediator.h"
#import "AliyunMediaConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoCropParam.h"
#endif


#define KSelectedImage(ImageName) ([UIImage imageWithOriginalName:ImageName])

#define KNormaImage(imageName) ([UIImage imageWithOriginalName:imageName])



@interface BaseTabBarController ()<YZGTabBarDelegate>{
    
    UIButton *_converButton;
    AVURLAsset *videoAsset;
    CADisplayLink *dlink;
    AVAssetExportSession *exporter;
}

@property (nonatomic, strong) UIViewController *recordViewController;
@property (nonatomic, strong) AliyunVideoRecordParam *quVideo;
@property (assign, nonatomic) BOOL isClipConfig;
@property (assign, nonatomic) BOOL isPhotoToRecord;
@end



@implementation BaseTabBarController

+ (void)initialize
{
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
   [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addOneChildViewControllerWithControllerName:@"MainViewController" normaImage:KNormaImage(@"menu_home_normal") selectedImage:KSelectedImage(@"menu_home_elect") navTitle:@"首页" tabBarTitle:@"首页" needNavgationBar:YES];
    
    [self addOneChildViewControllerWithControllerName:@"MainAttentionController" normaImage:KNormaImage(@"menu_attention_normal") selectedImage:KSelectedImage(@"menu_attention_elect") navTitle:@"关注" tabBarTitle:@"关注" needNavgationBar:YES];
    
       [self addOneChildViewControllerWithControllerName:@"UIViewController" normaImage:KNormaImage(@"") selectedImage:KSelectedImage(@"") navTitle:nil tabBarTitle:@"" needNavgationBar:YES];
    //wode
     [self addOneChildViewControllerWithControllerName:@"SisiConversationListController" normaImage:KNormaImage(@"menu_message_normal") selectedImage:KSelectedImage(@"menu_message_elect") navTitle:@"消息" tabBarTitle:@"消息" needNavgationBar:YES];

    [self addOneChildViewControllerWithControllerName:@"MineViewController" normaImage:KNormaImage(@"menu_me_normal") selectedImage:KSelectedImage(@"menu_me_elect") navTitle:nil tabBarTitle:@"我的" needNavgationBar:NO];
    
    //自定义tabBar
    [self setUpTabBar];
    
    [self addNoti];
    //更新下位置信息
    [self upadtaLocation];
}


- (void)upadtaLocation{
    
    
   [[YZGAppSetting sharedInstance] getCurrentLocation];
    

    
}

-(void)receiveLocationUpdateMessage{
    
   
    [[YZGAppSetting sharedInstance] updateCurrentLocationToServer:^(BOOL isSuccess ,NSString *loction) {
        
            //更新位置成功
        
    }];
}


- (void)addNoti{
    NSString * LGUploadVideoSuccess  = @"LGUploadVideoSuccess";
    NSString * LGUploadImageSuccess  = @"LGUploadImageSuccess";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideoSuccess) name:LGUploadVideoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideoSuccess) name:LGUploadImageSuccess object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateMessage) name:kAppUpDateCurrentPosition object:nil];
    
}

- (void)loginSuccess{
    
    
    
    
    
    
}

- (void)uploadVideoSuccess{
    
    LGUserMediaViewController *userMediaVc = [[LGUserMediaViewController alloc] initWithVcType:1];
    userMediaVc.isME = YES;
    
    
    NSInteger index = 0;
    for (UIViewController *vc in self.childViewControllers) {
        
//        UIViewController *vc =  nav.viewControllers.firstObject;
        
        if ([vc isKindOfClass:[MineViewController class]]) {
            
            [vc viewIfLoaded];
//            [self setSelectedIndex:4];
            [self setSelectedViewController:vc];
        }
        
        index += 1;
    }
    
    
    
    
    
}
- (void)uploadImageSuccess{
    
    
    
}


- (void)dealloc{

    YZGLog(@"%@",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//设置导航条的标题，分栏的标题。图片。等
#pragma mark - 添加一个子控制器
- (void)addOneChildViewControllerWithControllerName:(NSString *)controllerName normaImage:(UIImage *)image selectedImage:(UIImage *)selectedImage navTitle:(NSString *)title tabBarTitle:(NSString *)tabBarTitle needNavgationBar:(BOOL)needNavgationBar
{
    Class class = NSClassFromString(controllerName);
    UIViewController *viewController = [[class alloc]init];
    
//    if ([controllerName isEqualToString:@"BaseWebViewController"]) {
//        
//    }
    if ([controllerName isEqualToString:@"MainViewController"] || [controllerName isEqualToString:@"MineViewController"]) {
        
    }else{
        
        viewController.navigationItem.title = title;
    }
    viewController.tabBarItem.title = tabBarTitle;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    if (needNavgationBar)
    {
        BaseNavgationController *nav = [[BaseNavgationController alloc] initWithRootViewController:viewController];
        [self addChildViewController:nav];
        return;
     }
    [self addChildViewController:viewController];
}

#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    YZGTabBar *tabBar = [[YZGTabBar alloc]init];
    tabBar.yzgDelegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

-(void)yzgTabBar:(YZGTabBar *)tabBar didClickCenterButton:(UIButton *)button{
//    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//     
//        [self presentViewController: [AlertTool alertWithControllerTitle:@"提示" alertMessage:@"硬件问题摄像机无法使用" withActionTitle:@"确定" handler:^(UIAlertAction * _Nullable action) {
//            
//        }] animated:YES completion:nil];
//        
//        
//       
//        return;
//    }
    //显示功能
    _converButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    
    _converButton.backgroundColor = RGB_COLOR(0, 0, 0, 0.3);
    
    [_converButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_converButton];
    
    
    LGFucView *fucView = [LGFucView viewFromeNib];
    [fucView.uploadImage addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [fucView.uploadVideo addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [fucView.gameLive addTarget:self action:@selector(gameLive) forControlEvents:UIControlEventTouchUpInside];
    [fucView.closeButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_converButton addSubview:fucView];
    
    
    [fucView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(193);
        make.left.right.bottom.mas_equalTo(0);
        
    }];
 
}


- (void)uploadImage{
    
    VideoEditViewController *edite = [[VideoEditViewController alloc] init];
    edite.vcType = 2;
    
    [self presentViewController:edite animated:YES completion:^{
        [self removeView];
    }];
    
}
- (void)uploadVideo{
    
        AliyunVideoRecordParam *config = [[AliyunVideoRecordParam alloc] init];
        config.ratio = AliyunVideoVideoRatio9To16;
        config.size = AliyunVideoVideoSize540P;
        config.minDuration = 2;
        config.maxDuration = 150;
        config.position = AliyunCameraPositionFront;
        config.beautifyStatus = YES;
        config.beautifyValue = 80;
        config.torchMode = AliyunCameraTorchModeOff;
        config.gop = 5;
        config.videoQuality = 0.25;
        config.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
        _quVideo = config;
        AliyunVideoUIConfig *configUi = [[AliyunVideoUIConfig alloc] init];

        configUi.backgroundColor = RGB_COLOR(0, 0, 0, 0.5);
        configUi.timelineBackgroundCollor = [UIColor clearColor];
        configUi.timelineDeleteColor = [UIColor redColor];
        configUi.timelineTintColor = RGBToColor(239, 75, 129);
        configUi.durationLabelTextColor = [UIColor redColor];
        configUi.cutTopLineColor = [UIColor grayColor];
        configUi.cutBottomLineColor = [UIColor redColor];

        configUi.noneFilterText = @"无滤镜";
        configUi.hiddenDurationLabel = NO;
        configUi.hiddenFlashButton = NO;
        configUi.hiddenBeautyButton = NO;
        configUi.hiddenCameraButton = NO;
        configUi.hiddenImportButton = NO;
        configUi.hiddenDeleteButton = NO;
        configUi.hiddenFinishButton = NO;
        configUi.recordOnePart = NO;
        configUi.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳",@"波普",@"光圈",@"海盐",@"黑白",@"胶片",@"焦黄",@"蓝调",@"迷糊",@"思念",@"素描",@"鱼眼",@"马赛克",@"模糊"];
        configUi.imageBundleName = @"QPSDK";
        configUi.filterBundleName = @"FilterResource";
        configUi.recordType = AliyunVideoRecordTypeCombination;
        configUi.showCameraButton = YES;
        [[AliyunVideoBase shared] registerWithAliyunIConfig:configUi];
        _recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:config];
        [AliyunVideoBase shared].delegate = (id)self;


    BaseNavgationController *nav = [[BaseNavgationController alloc] initWithRootViewController:_recordViewController];

    [self presentViewController:nav animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self removeView];
    }];
}

- (void)gameLive{
    
    ShowingController *liveVC = [[ShowingController alloc] init];
   
    [self presentViewController:liveVC animated:YES completion:^{
        [self removeView];
    }];
    
}

- (void)removeView{
    
    [_converButton removeFromSuperview];
}



-(void)yzgTabBar:(YZGTabBar *)tabBar didClickCzButton:(UIButton *)button
{
    [AlertTool alertWithTitle:nil message:@"是否重新登录" callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            [Account removeAccount];
            [self dismissViewControllerAnimated:NO completion:nil];
            [[RootTool sharedInstance] chooseRootController];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

-(void)yzgTabBar:(YZGTabBar *)tabBar didClickDhButton:(UIButton *)button
{
    NSString *exchangeUrl = [NSString stringWithFormat:@"%@/portal/Appweb/earn?token=%@",[YZGAppSetting sharedInstance].appUrl,[[Account shareInstance] token]];
    BaseWebViewController *exchange = [[BaseWebViewController alloc]init];
    exchange.title = @"兑换";
    exchange.url = [NSURL URLWithString:exchangeUrl];
    BaseNavgationController *nav = [[BaseNavgationController alloc] initWithRootViewController:exchange];
    [self showViewController:nav sender:nil];

}


-(void)videoBaseRecordVideoExit {
    NSLog(@"退出录制");
    [self.recordViewController dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//录制完成
- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    NSLog(@"录制完成  %@", videoPath);
   

    LGUserPlayerView *plerView = [[LGUserPlayerView alloc] init];
    plerView.presenVc = recordVC;
    plerView.videoPath = videoPath;
//    return;
    //保存
     [recordVC.navigationController pushViewController:plerView animated:YES];
}

- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {


    // 可以更新相册页配置
    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
    mediaInfo.minDuration = 2.0;
    mediaInfo.maxDuration = 150;
    mediaInfo.fps = 25;
    mediaInfo.gop = 5;
    mediaInfo.videoQuality = 1;
    mediaInfo.size = AliyunVideoVideoSize540P;
    mediaInfo.ratio = AliyunVideoVideoRatio9To16;
    mediaInfo.cutMode = AliyunVideoCutModeScaleAspectFill;
    mediaInfo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return mediaInfo;

}


//裁剪完成
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"watermark" ofType:@"jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//     [self AVsaveVideoPath:[NSURL fileURLWithPath:videoPath] WithWaterImg:image WithCoverImage:nil WithQustion:nil WithFileName:@"video" cutCompeleteWithCropViewController:cropVC];
    VideoEditViewController *edite = [[VideoEditViewController alloc] init];
    edite.videoPath = videoPath;
    edite.outputSize = self.view.size;
    edite.vcType = 1;
    edite.presenVc = cropVC;
    
    [cropVC.navigationController pushViewController:edite animated:YES];

    
}





- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {

    NSLog(@"跳转录制页");
    return nil;
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {

    NSLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



///录制完成
- (void)recoderFinish:(UIViewController *)vc videopath:(NSString *)videoPath {

    UIViewController *editVC = [[AliyunMediator shared] editViewController];
    NSString *outputPath = [[vc valueForKey:@"recorder"] valueForKey:@"taskPath"];
    [editVC setValue:outputPath forKey:@"taskPath"];
    [editVC setValue:[vc valueForKey:@"quVideo"] forKey:@"config"];
    [self.navigationController pushViewController:editVC animated:YES];
}


///使用AVfoundation添加水印
- (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question WithFileName:(NSString*)fileName cutCompeleteWithCropViewController:(UIViewController *)cropVC
{
    if (!videoPath) {
        return;
    }
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale-0.2, videoAsset.duration.timescale);
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];
    
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    //    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    //        videoAssetOrientation_ =  UIImageOrientationUp;
    //    }
    //    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    //        videoAssetOrientation_ = UIImageOrientationDown;
    //    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:img WithCoverImage:coverImg WithQustion:question size:CGSizeMake(renderWidth, renderHeight)];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink setFrameInterval:15];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [dlink setPaused:NO];
    // 5 - 视频文件输出
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            [SVProgressHUD dismiss];
//            videoUrl
            VideoEditViewController *edite = [[VideoEditViewController alloc] init];
            edite.videoPath = myPathDocs;
            edite.outputSize = self.view.size;
            edite.vcType = 1;
            edite.presenVc = cropVC;
            
            [cropVC.navigationController pushViewController:edite animated:YES];
            
        });
    }];
    
}


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question  size:(CGSize)size {
    
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFontSize:30];
    [subtitle1Text setString:question];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.masksToBounds = YES;
    subtitle1Text.cornerRadius = 23.0f;
    [subtitle1Text setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize textSize = [question sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [subtitle1Text setFrame:CGRectMake(50, 100, textSize.width+20, textSize.height+10)];
    
    //水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;
    //    imgLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    
    imgLayer.bounds =  CGRectMake(0,0, img.size.width * 0.15, img.size.height * 0.15);;
    imgLayer.position = CGPointMake(img.size.width * 0.04, img.size.height * 0.56);
    
    
    //第二个水印
    CALayer *coverImgLayer = [CALayer layer];
    coverImgLayer.contents = (id)coverImg.CGImage;
    //    [coverImgLayer setContentsGravity:@"resizeAspect"];
    coverImgLayer.bounds =  CGRectMake(50, 200,210, 50);
    coverImgLayer.position = CGPointMake(size.width/4.0, size.height/4.0);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:coverImgLayer];
    
    //设置封面
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.0f];
    anima.repeatCount = 0;
    anima.duration = 5.0f;  //5s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    [coverImgLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

//更新生成进度
- (void)updateProgress {
    [SVProgressHUD showProgress:exporter.progress status:NSLocalizedString(@"生成中...", nil)];
    if (exporter.progress>=1.0) {
        [dlink setPaused:true];
        [dlink invalidate];
        [SVProgressHUD dismiss];
        
    }
}




@end

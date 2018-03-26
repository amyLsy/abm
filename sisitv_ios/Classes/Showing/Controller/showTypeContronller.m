//
//  showTypeContronller.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/20.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "showTypeContronller.h"
#import "ShowingFuncTypeView.h"
#import "ShowingController.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import <AliyunVideoSDK/AliyunVideoSDK.h>
//#import <AliyunVideoSDK/AliyunVideoRecordParam.h>
#import "NSObject+LGRuntime.h"
#import "AliyunPublishViewController.h"
#import "VideoEditViewController.h"

@interface showTypeContronller ()
//选择类型
@property(nonatomic, strong) ShowingFuncTypeView *fucView;
@property (nonatomic, assign) CGFloat videoOutputWidth;
@property (nonatomic, assign) CGFloat videoOutputRatio;
//@property (nonatomic, strong) AliyunVideoRecordParam *quVideo;
@property (nonatomic, strong) UIViewController *recordViewController;
@property (assign, nonatomic) BOOL isClipConfig;
@property (assign, nonatomic) BOOL isPhotoToRecord;
@end



@implementation showTypeContronller

- (ShowingFuncTypeView *)fucView{
    
    if (_fucView == nil) {
        
        _fucView = [ShowingFuncTypeView viewFromeNib];
    }
    
    
    return _fucView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//     self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"ShowVcDismiss" object:nil];
    
//    AliyunVideoRecordParam *param = [[AliyunVideoRecordParam alloc] init];
    // Do any additional setup after loading the view.
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addSubView{
    
//    JLMagicCameraViewController *magicCameraVc = [[JLMagicCameraViewController alloc] init];
//    UINavigationController *camerNav = [[UINavigationController alloc] initWithRootViewController:magicCameraVc];
//    AliyunVideoRecordParam *config = [AliyunVideoRecordParam alloc];
//    config.ratio = AliyunVideoVideoRatio9To16;
//    config.size = AliyunVideoVideoSize720P;
//    config.minDuration = 2;
//    config.maxDuration = 20;
//    config.position = AliyunCameraPositionFront;
//    config.beautifyStatus = YES;
//    config.beautifyValue = 100;
//    config.torchMode = AliyunCameraTorchModeOff;
//    config.gop = 5;
//    config.videoQuality = 0.25;
//    config.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
//    _quVideo = config;
//    AliyunVideoUIConfig *configUi = [[AliyunVideoUIConfig alloc] init];
//
//    configUi.backgroundColor = RGB_COLOR(0, 0, 0, 0.5);
//    configUi.timelineBackgroundCollor = [UIColor clearColor];
//    configUi.timelineDeleteColor = [UIColor redColor];
//    configUi.timelineTintColor = RGBToColor(239, 75, 129);
//    configUi.durationLabelTextColor = [UIColor redColor];
//    configUi.cutTopLineColor = [UIColor grayColor];
//    configUi.cutBottomLineColor = [UIColor redColor];
//
//    configUi.noneFilterText = @"无滤镜";
//    configUi.hiddenDurationLabel = NO;
//    configUi.hiddenFlashButton = NO;
//    configUi.hiddenBeautyButton = NO;
//    configUi.hiddenCameraButton = NO;
//    configUi.hiddenImportButton = NO;
//    configUi.hiddenDeleteButton = NO;
//    configUi.hiddenFinishButton = NO;
//    configUi.recordOnePart = NO;
//    configUi.imageBundleName = @"QPSDK";
//    configUi.filterBundleName = @"FilterResource";
//    configUi.recordType = AliyunVideoRecordTypeCombination;
//    configUi.showCameraButton = YES;
//    [[AliyunVideoBase shared] registerWithAliyunIConfig:configUi];
//    _recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:config];
//    [AliyunVideoBase shared].delegate = (id)self;
////    _recordViewController.view.frame = self.view.frame;
////    [self.view addSubview:_recordViewController.view];
////    [self addChildViewController:_recordViewController];

    ShowingController *liveVC = [[ShowingController alloc] init];
    liveVC.view.frame = self.view.frame;
   
    [self.view addSubview:liveVC.view];
    [self addChildViewController:liveVC];
    KWeakSelf;
    liveVC.typeView = self.fucView;
    [self.view addSubview:self.fucView];
    self.fucView.selectedCallBack = ^(UIButton *btn) {
        //1.选取相册文件 2.直播 3.拍摄

        switch (btn.tag) {
                //选取文件
            case 1:{

                VideoEditViewController *edite = [[VideoEditViewController alloc] init];

                edite.vcType = 2;
                [ws.navigationController pushViewController:edite animated:NO];
            }
                break;
            //直播拍摄
            case 2:{



//                liveVC.view.hidden = NO;
//                [liveVC beginStartShow];
//                ws.recordViewController.view.hidden = YES;
            }
                break;
            //录制视频
            case 3:{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];

                [ws.navigationController pushViewController:ws.recordViewController animated:NO];
//                liveVC.
//                liveVC.view.hidden = YES;
//                [liveVC cleanShowControl];
//                ws.recordViewController.view.hidden = NO;;
            }
                
                break;
                
            default:
                break;
        }

    };
    [self.fucView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_offset(0);
        make.height.mas_equalTo(36);
        make.bottom.offset(-10);
    }];

    
    
}
//
//-(void)videoBaseRecordVideoExit {
//    NSLog(@"退出录制");
//    [self.navigationController popViewControllerAnimated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//}
//
//- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
//    NSLog(@"录制完成  %@", videoPath);
//    VideoEditViewController *edite = [[VideoEditViewController alloc] init];
//    edite.videoPath = videoPath;
//    edite.outputSize = self.view.size;
//    edite.vcType = 1;
//
////    return;
//    //保存
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
//                                completionBlock:^(NSURL *assetURL, NSError *error) {
//
//
//                                }];
//     [self.navigationController pushViewController:edite animated:YES];
//}
//
//- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
//
//
//    // 可以更新相册页配置
//    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
//    mediaInfo.minDuration = 2.0;
//    mediaInfo.maxDuration = 20;
//    mediaInfo.fps = 25;
//    mediaInfo.gop = 5;
//    mediaInfo.videoQuality = 1;
//    mediaInfo.size = AliyunVideoVideoSize720P;
//    mediaInfo.ratio = AliyunVideoVideoRatio9To16;
//    mediaInfo.cutMode = AliyunVideoCutModeScaleAspectFill;
//    mediaInfo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
//    return mediaInfo;
//
//}
//
//// 裁剪
//- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
//
//
//    VideoEditViewController *edite = [[VideoEditViewController alloc] init];
//    edite.videoPath = videoPath;
//    edite.outputSize = self.view.size;
//    edite.vcType = 1;
//
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    //裁剪保存
//    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
//                                completionBlock:^(NSURL *assetURL, NSError *error) {
//
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                                    });
//                                }];
//    [self.navigationController pushViewController:edite animated:YES];
//}
//
//
//
//
//
//- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
//
//    NSLog(@"跳转录制页");
//    return nil;
//}
//
//- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
//
//    NSLog(@"退出相册页");
//    [photoVC.navigationController popViewControllerAnimated:YES];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)recoderFinish:(UIViewController *)vc videopath:(NSString *)videoPath {
//
//    if (self.isPhotoToRecord) {
//        self.isPhotoToRecord = NO;
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
//            if (error) {
//                NSLog(@"录制完成，保存到相册失败");
//                return;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }];
//        return;
//    }
//    UIViewController *editVC = [[AliyunMediator shared] editViewController];
//    NSString *outputPath = [[vc valueForKey:@"recorder"] valueForKey:@"taskPath"];
//    [editVC setValue:outputPath forKey:@"taskPath"];
//    [editVC setValue:[vc valueForKey:@"quVideo"] forKey:@"config"];
//    [self.navigationController pushViewController:editVC animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LGUserPlayerView.m
//  sisitv_ios
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGUserPlayerView.h"
#import <libksygpulive/KSYMoviePlayerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AliyunVideoSDKPro/AliyunVideoSDKPro.h>
#import "AlertTool.h"
#import "VideoEditViewController.h"
#import <GPUImage/GPUImage.h>
@interface LGUserPlayerView ()
@property (strong ,nonatomic) KSYMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *saveVideo;
@property (weak, nonatomic) IBOutlet UIView *playerView;


@end

@implementation LGUserPlayerView{
    
    GPUImageNormalBlendFilter *filter;
    GPUImageMovie *movieFile;
    GPUImageMovieWriter *movieWriter;
    AVURLAsset *videoAsset;
    CADisplayLink *dlink;
    AVAssetExportSession *exporter;
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.player stop];
    self.player = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player  = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_videoPath]];
    self.nextButton.layer.cornerRadius = 6;
    self.nextButton.layer.masksToBounds = YES;
    self.saveVideo.layer.cornerRadius = 4;
    self.saveVideo.layer.masksToBounds = YES;
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    self.player.shouldLoop = YES;
    self.player.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.playerView addSubview:self.player.view];
    [self.player prepareToPlay];
}




- (IBAction)back:(id)sender {
    
    [self.player stop];
    self.player = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next:(id)sender {
    
    
    VideoEditViewController *edite = [[VideoEditViewController alloc] init];
    edite.videoPath = _videoPath;
    edite.outputSize = self.view.size;
    edite.vcType = 1;
    edite.presenVc = _presenVc;
    [self.navigationController pushViewController:edite animated:YES];
}
- (IBAction)save:(id)sender {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:_videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    [AlertTool ShowErrorInView:self.view withTitle:@"保存成功"];
                                    
                                }];
}


@end

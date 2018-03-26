//
//  ShowControl.h
//  sisitv
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ShowControlUtilits.h"
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYAgoraStreamerKit.h"
@class ShowControl;

@protocol ShowControlShowingDelegate <NSObject>

-(void)showingStateDidChange:(YZGStreamState)streamState;

@end


@interface ShowControl : NSObject

@property (nonatomic , weak) id<ShowControlShowingDelegate> showingDelegate;
@property (nonatomic , strong) KSYAgoraStreamerKit *streamerKit;
+(instancetype)shareInstance;

-(void)startPreviewInview:(UIView *)preView;
-(void)stopPreView;

-(void)startPushWithUrlString:(NSString *)pushUrlString;
-(void)stopPreviewAndPush;

-(void)startPlayBgmWithUrlString:(NSString *)urlString;
-(void)stopPlayBgm;
-(BOOL)isPlayingBgm;

- (void)rtcRegisterLocalid:(NSString *)localid isAudience:(BOOL)isAudience;
-(void)rtcStartCallRemoteid:(NSString *)remoteid;
- (void)rtcStopCall;
- (void)rtcAnswerCall;
- (void)rtcRejectCall;

-(BOOL)isBeauty;

-(void)switchCamera;
-(void)toggleTorch;
-(void)startOrStopBeauty;

/**
 @abstract    背景音的已经播放长度 (单位:秒)
 @discussion  从0开始，最大为bgmDuration长度
 */
@property (nonatomic, readonly) float bgmPlayTime;

/**
 改变bgm音量

 @param voice voice
 */
-(void)changeBgmVoice:(float)voice;

/**
 当前bgm音量

 @return 当前bgm的音量的大小
 */
-(float)bgmVoice;

- (void)tryReconnect;

@end

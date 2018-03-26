//
//  PlayerLivingControl.m
//  sisitv_ios
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "PlayerLivingControl.h"
#import "AlertTool.h"

@interface PlayerLivingControl ()



@property (nonatomic , weak) UIView *playerSuperView;

@property(nonatomic,copy) NSString *livingUrlString;

@end

@implementation PlayerLivingControl

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

-(void)installPlayerSuperView:(UIView *)playerSuperView{
    self.playerSuperView = playerSuperView;
    [AlertTool showWithCustomModeInView:playerSuperView];
}
#pragma mark --- 初始化播放器
-(void)installPlayerWithUrlString:(NSString *)livingUrlString
{
    if (!livingUrlString) {
        return;
    }
    if (self.player) {
        [self.player reload:[NSURL URLWithString:livingUrlString]];
        return;
    }
    self.livingUrlString = livingUrlString;
    [self installMovieNotificationObservers];
    self.player  = [[KSYMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:self.livingUrlString]];
    [self.playerSuperView addSubview:self.player.view];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    KWeakSelf;
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.playerSuperView);
    }];
    self.player.messageDataBlock = ^(NSDictionary *message, int64_t pts, int64_t param){
        
    };
    [self.player prepareToPlay];
}

-(void)uninstallPlayer{
    [self removeMovieNotificationObservers];
    self.livingUrlString = nil;
    [AlertTool Hidden];
    [self.player stop];
    [self.player.view removeFromSuperview];
    self.player = nil;
}

#pragma mark ---注册通知

-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moviePlayBackStateDidChange:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadStateDidChange:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
}

//加载状态改变
- (void)loadStateDidChange:(NSNotification*)notification
{
    if (self.player.loadState !=  (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK)) {
        [AlertTool showWithCustomModeInView:self.playerSuperView];
    }else{
        [AlertTool Hidden];
        
        
    }
    [self.delegate loadStateDidChange:self.player.loadState];
}





//播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        [self.delegate playerLivingControlStartPlying];
        [AlertTool Hidden];
    }else{
        [AlertTool showWithCustomModeInView:self.playerSuperView];
    }
}

-(void)dealloc
{
    YZGLog(@"%@",self);
}

#pragma clang diagnostic pop
@end

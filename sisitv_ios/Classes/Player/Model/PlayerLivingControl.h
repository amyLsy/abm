//
//  PlayerLivingControl.h
//  sisitv_ios
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGSingleton.h"
#import "RoomModel.h"
#import <libksygpulive/KSYMoviePlayerController.h>
@protocol PlayerLivingControlDelegate <NSObject>

-(void)playerLivingControlStartPlying;

- (void)loadStateDidChange:(MPMovieLoadState)state;

@end

@interface PlayerLivingControl : YZGSingleton

@property (nonatomic , weak) id<PlayerLivingControlDelegate>delegate;
@property(nonatomic, strong) KSYMoviePlayerController*player;



-(void)installPlayerSuperView:(UIView *)playerSuperView;

-(void)installPlayerWithUrlString:(NSString *)livingUrlString;

-(void)uninstallPlayer;

@end

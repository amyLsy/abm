//
//  LGPlaytool.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/3.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "YZGSingleton.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>
@interface LGPlaytool : YZGSingleton
@property (strong ,nonatomic) AliyunVodPlayer *aliPlayer;
- (void)prepare;
- (void)startPlay;
- (void)pausePlay;
- (void)resumePlay;
- (void)stopPlay;
- (void)releasePlayer;
@end

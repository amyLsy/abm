//
//  GiftCache.m
//  sisitv
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "GiftCache.h"

@interface GiftCache()

/**
 * 连送定时器
 */
@property (nonatomic , strong) NSTimer *continueTimer;

@end

@implementation GiftCache

-(void)startTimner{
    [self stopTimner];
    self.timeOfInterval = 5;
    self.continueTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changesCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.continueTimer forMode:NSRunLoopCommonModes];
}

-(void)changesCount{
    self.timeOfInterval --;
    if (self.timeOfInterval<=0) {
        [self resetCacheInfo];
    }
}

-(void)resetCacheInfo{
    self.countOfGift = @"0";
    self.lastChatMessageIdentifie = nil;
    [self stopTimner];
}

-(void)stopTimner{
    if (self.continueTimer) {
        [self.continueTimer invalidate];
        self.continueTimer = nil;
        self.timeOfInterval = 0;
    }
}

@end

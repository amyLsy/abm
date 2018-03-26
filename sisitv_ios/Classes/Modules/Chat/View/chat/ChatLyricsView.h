//
//  ChatLyricsView.h
//  sisitv_ios
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatLyricsView : UIView
/**
 当开始播放歌曲的时候,显示歌词视图,加载歌词
 
 @param lyrics 歌词
 */
-(void)startLoadLyrics:(NSArray *)lyrics;

-(void)currentBgmPlayTime:(float)bgmPlayTime;
/**
 停止加载歌词
 */
-(void)stopLoadLyrics;

@end

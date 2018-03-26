//
//  YZGMusicItem.h
//  sisitv_ios
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGMusicItem : NSObject

typedef NS_ENUM(NSInteger,YZGMusicStatus){
    YZGMusicOnline= 0,
    YZGMusicDownLoaded ,
    YZGMusicDownLoading,
    YZGMusicDownFailed,
    YZGMusicDownDeleting
};
typedef NS_ENUM(NSInteger,YZGMusicPlayStatus){
    YZGMusicStop = 0,
    YZGMusicPlaying,
    YZGMusicPause
};
/**
 歌曲id
 */
@property (nonatomic , copy) NSString *song_id;
/**
 歌曲名
 */
@property (nonatomic , copy) NSString *song_name;
/**
 歌曲url
 */
@property (nonatomic , copy) NSString *mp3Url;
/**
 歌手名字
 */
@property (nonatomic , copy) NSString *artist_name;
/**
 当前下载进度
 */
@property (nonatomic , assign) CGFloat currentProgress;
/**
  下载状态
 */
@property (nonatomic , assign) YZGMusicStatus musicStatus;
/**
  播放状态
 */
@property (nonatomic , assign) YZGMusicPlayStatus playStatus;
/**
 一行歌词
 */
@property (nonatomic , copy) NSString *lyric;
/**
 一行歌词所在的秒数
 */
@property (nonatomic , copy) NSString *timestamp;

@end

//
//  DownloadedMusic.h
//  xiuPai
//
//  Created by apple on 16/11/29.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZGMusicParam.h"

@class YZGMusicItem;

@interface YZGDownloadMusic : NSObject

+(instancetype)shareInstance;


/**
 请求音乐列表

 @param param 请求所需的参数
 @param success 网络请求成功的回调
 */
-(void)requestMusicWithParam:(NSDictionary *)param success:(void (^)(id result ,BOOL isSuccess))success;


/**
 根据歌曲的url地址下载歌曲

 @param musicItem 当前要下载的musicItem
 @param progress 进度
 @param completion 成功或失败的回调
 */
-(void)downLoadMusicForMusicItem:(YZGMusicItem *)musicItem downloadProgress:(void (^)(CGFloat))progress completion:(void (^)(BOOL isSuccess,id result))completion;

/**
 下载歌词

 @param param 参数:歌曲的id
 @param success 网络请求成功的回调
 */
-(void)downLoadLyricsWithParam:(YZGMusicParam *)param success:(void (^)(BOOL isSuccess,id result))success;

/**
 已经下载的音乐

 @return 一个数据对象为YZGMusicItem的数组
 */
-(NSArray *)allDownloadedMusic;

/**
 根据所给的歌曲的名字,返回歌曲所存储的位置

 @param musicItem 歌曲item
 @return 歌曲路径
 */
-(NSString *)playingSongPathForMusicItem:(YZGMusicItem *)musicItem;

/**
 正在播放的歌曲的歌词数组,必须先播放歌曲,才有值
 
 @param musicItem 歌曲item
 @return 正在播放的歌曲的歌词数组
 */
-(NSArray *)playingLyricsForMusicItem:(YZGMusicItem *)musicItem;

/**
 根据所给的歌曲的名字和歌曲的id,删除歌曲和歌词

 @param musicItem 歌曲Item
 */
-(void)deleteSongForMusicItem:(YZGMusicItem *)musicItem;

@end

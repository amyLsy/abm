//
//  YZGMusicParam.h
//  sisitv_ios
//
//  Created by apple on 17/2/16.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGMusicParam : NSObject

/**
 搜索的歌曲名字
 */
@property (nonatomic , copy) NSString *keyword;

/**
 搜索的歌词的id
 */
@property (nonatomic , copy) NSString *song_id;

@end

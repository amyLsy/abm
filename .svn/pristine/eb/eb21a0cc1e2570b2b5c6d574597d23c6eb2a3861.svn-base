//
//  DownloadedMusic.m
//  xiuPai
//
//  Created by apple on 16/11/29.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGDownloadMusic.h"
#import "YZGMusicItem.h"
#import "YZGChainRequest.h"
#import "YZGRequest.h"
#import <FMDB/FMDB.h>
#import "AlertTool.h"
#import "HttpTool.h"

static YZGDownloadMusic *_instance ;
static FMDatabase *dataBase ;

@interface YZGDownloadMusic ()

/**
 正在播放的歌词
 */
@property (nonatomic , strong) NSMutableArray *playingLyricsArray;

/**
 临时存储本次下载的歌词和时间
 */
@property (nonatomic , strong) NSMutableArray *tempArray;
/**
 临时存储本次下载的本次歌词 value为字典
 */
@property (nonatomic , strong) NSMutableArray *tempLyricsArray;

@end


@implementation YZGDownloadMusic

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YZGDownloadMusic alloc] init];
    });
    return _instance;
}
/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

+ (void)initialize
{
    if (self == [YZGDownloadMusic class]) {
        dataBase = [FMDatabase databaseWithPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) [0] stringByAppendingPathComponent:@"downloadedMusic.sqlite"]];
        if ([dataBase open]) {
            if ([dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_downloadedMusic (song_id text  , song_name text ,mp3Url text ,artist_name text);"]) {
                YZGLog(@"创建t_downloadedMusic表成功");
            }else{
                YZGLog(@"创建t_downloadedMusic表失败");
            }
        }
    }
}

-(NSString *)playingSongPathForMusicItem:(YZGMusicItem *)musicItem{
    NSString *path = [self songPathForMusicItem:musicItem];
    return path;
}

-(NSArray *)playingLyricsForMusicItem:(YZGMusicItem *)musicItem{
    [self sortLyricsWithSong_id:musicItem.song_id];
    return [self.playingLyricsArray copy];
}

-(void)requestMusicWithParam:(NSDictionary *)param success:(void (^)(id result ,BOOL isSuccess))success{
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagSearchSong param:param.mutableCopy success:^(id responseObject) {
        BOOL isSuccess = NO;
        id result = nil;
        if ([responseObject[@"code"] integerValue] == 200) {
            isSuccess = YES;
            result = [YZGMusicItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }else{
            [AlertTool ShowErrorInView:KKeyWindow withTitle:@"网络繁忙"];
        }
        if (success) {
            success(result,isSuccess);
        }
    } faile:nil];
}

-(void)downLoadMusicForMusicItem:(YZGMusicItem *)musicItem downloadProgress:(void (^)(CGFloat))progress completion:(void (^)(BOOL isSuccess,id result))completion{
    
    BOOL isDownLoaded = [[NSFileManager defaultManager] fileExistsAtPath:[self songPathForMusicItem:musicItem]];
    if (isDownLoaded) {
        completion(NO,@"歌曲已经存在");
        return;
    }
    [HttpTool downLoadMusicWithUrl:musicItem.mp3Url toPath:[self songPathForMusicItem:musicItem] downloadProgress:progress completion:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            [self storeSongForMusicItem:musicItem];
            YZGMusicParam *param = [[YZGMusicParam alloc] init];
            param.song_id = musicItem.song_id;
            [self downLoadLyricsWithParam:param success:nil];
        }
        completion(isSuccess,result);
    }];
}

-(void)downLoadLyricsWithParam:(YZGMusicParam *)param success:(void (^)(BOOL, id))success{
    [self.tempLyricsArray removeAllObjects];
    [self.playingLyricsArray removeAllObjects];

    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagSearchSongLyric param:param.mj_keyValues success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
                
                NSString *lyrics = responseObject[@"data"][@"lyric"];
                [self parseLylics:lyrics song_id:param.song_id];
                if (self.tempLyricsArray.count>0) {
                    //歌词存到本地
                    [self storeLyrics:lyrics song_id:param.song_id];
                    [self.tempLyricsArray removeAllObjects];
                }
            }
        }else{
            [AlertTool ShowErrorInView:KKeyWindow withTitle:@"该歌曲暂无歌词"];
        }
    } faile:nil];
}

/**
 解析歌词

 @param lyrics 歌词字符串
 */
-(void)parseLylics:(NSString *)lyrics song_id:(NSString *)song_id{
    
    NSArray *tempArray = [lyrics componentsSeparatedByString:@"\n"];
    for (NSString *str in tempArray)
    {
        if (str && str.length > 0)
        {
            //清除数组里面的临时数据
            [self.tempArray removeAllObjects];
            [self parseLineLyric:str];
            [self parseTimeArray:self.tempArray];
        }
    }
}

/**
 解析每一行的字符串,分离歌词和时间

 @param lineLyric 每一行的字符串
 */
-(void)parseLineLyric:(NSString *)lineLyric{
    //lineLyric是一行 例如 [00:00.00] I love you
    if (!lineLyric || lineLyric.length <= 0)
        return;
    NSRange range = [lineLyric rangeOfString:@"]"];
    if (range.length > 0)
    {
        //歌词
        NSString * lyric = [lineLyric substringFromIndex:range.location + 1];
        //时间
        NSString * time = [lineLyric substringToIndex:range.location];
        if (time && time.length > 0)
            [self.tempArray addObject:lyric];
            [self.tempArray addObject:time];
        if (lyric)
            [self parseLineLyric:lyric];
    }
}
-(void)parseTimeArray:(NSMutableArray *) tempArray
{
    if (!tempArray || tempArray.count <= 0)
        return;
    //时间
    NSString *time = [tempArray lastObject];
    time = [time stringByReplacingOccurrencesOfString:@"[" withString:@""];
    if (!time || ([time rangeOfString:@"["].length > 0 && [time rangeOfString:@"]"].length > 0))
    {
        [self.tempArray removeAllObjects];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    // 转换成以秒为单位的时间计数器
    NSString *secondTime = [self timeToSecond:time];
    NSString *lyric = [tempArray firstObject];
    //把歌词和对应的时间保存到一个字典中去
    [dic setObject:lyric forKey:secondTime];
    [self.tempLyricsArray addObject:dic];
    [self.tempArray removeAllObjects];
}

-(NSString *)timeToSecond:(NSString *)formatTime{
    if (!formatTime || formatTime.length <= 0)
        return nil;
    if ([formatTime rangeOfString:@"["].length >= 1)
        return nil;
    //00:18.221
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(0, 2)];
    NSString * second = [formatTime substringWithRange:NSMakeRange(3, 2)];
    NSString * millisecond= @"0";
    if (formatTime.length>6) {
        millisecond = [formatTime substringWithRange:NSMakeRange(6, 1)];
    }else if (formatTime.length>7){
        millisecond = [formatTime substringWithRange:NSMakeRange(6, 2)];
    }else if (formatTime.length > 8){
        millisecond = [formatTime substringWithRange:NSMakeRange(6, 3)];
    }
    float finishTime = minutes.floatValue * 60 + second.floatValue + millisecond.floatValue/1000;
    return [NSString stringWithFormat:@"%f",finishTime];
}

// 以时间顺序进行排序
-(void)sortLyricsWithSong_id:(NSString *)song_id{
    
    if (!song_id) return;
    
    [self.playingLyricsArray removeAllObjects];
    
    NSString *lyrics = [self lyricsFromCacheForSong_id:song_id];
    if (!lyrics) return;
    
    [self parseLylics:lyrics song_id:song_id];
    
    NSMutableArray *lyricsArray = [NSMutableArray array] ;
    if (self.tempLyricsArray.count>0) {
        lyricsArray = [self.tempLyricsArray mutableCopy];
        [self.tempLyricsArray removeAllObjects];
    }
    if (lyricsArray.count <= 0) return;
    
    self.playingLyricsArray = [lyricsArray mutableCopy];
    for (NSUInteger i = 0; i < lyricsArray.count - 1; i++)
    {
        for (NSUInteger j = i + 1; j < lyricsArray.count; j++)
        {
            id firstDic = [lyricsArray objectAtIndex:i];
            id secondDic = [lyricsArray objectAtIndex:j];
            if (firstDic && secondDic && [firstDic isKindOfClass:[NSDictionary class]] && [secondDic isKindOfClass:[NSDictionary class]])
            {
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                BOOL bigger = [firstTime floatValue] > [secondTime floatValue];
                if (bigger) // 第一句时间大于第二句，就要进行交换
                {
                    [self.playingLyricsArray replaceObjectAtIndex:i withObject:secondDic];
                    [self.playingLyricsArray replaceObjectAtIndex:j withObject:firstDic];
                }
            }
        }
    }
}


-(void)deleteSongForMusicItem:(YZGMusicItem *)musicItem{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL removeSongSuccess = [fileManager removeItemAtPath:[self songPathForMusicItem:musicItem] error:nil];
    if (removeSongSuccess) {
        //删除歌词
        [fileManager removeItemAtPath:[self lyricsPathWithSong_id:musicItem.song_id] error:nil];
        //从数据库中 删除歌曲
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from t_downloadedMusic where %@ = '%@'",
                               @"song_id", musicItem.song_id];
        if (![dataBase executeUpdate:deleteSql]) {
            NSLog(@"从数据库中删除歌曲error");
        } else {
            NSLog(@"s从数据库中删除歌曲 uccess");
        }
    }
}

/**
 把下载的歌词以歌曲id为名保存到本地

 @param lyrics 下载的歌词
 @param song_id 歌曲的id
 */
-(void)storeLyrics:(NSString *)lyrics song_id:(NSString *)song_id{
    NSString *lrcPath = [self lyricsPathWithSong_id:song_id];
    NSError *err;
     BOOL storeLyrics = [lyrics writeToFile:lrcPath atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (storeLyrics) {
        YZGLog(@"storeLyrics success %@--",lrcPath);
    }else{
        YZGLog(@"storeLyrics error %@--",[err localizedDescription]);
    }
}

/**
 下载成功音乐,存储到本地数据库
 
 @param musicItem musicItem
 */

-(void)storeSongForMusicItem:(YZGMusicItem *)musicItem{
    NSString *song_id = musicItem.song_id;
    NSString *song_name = musicItem.song_name;
    NSString *mp3Url = musicItem.mp3Url;
    NSString *artist_name = musicItem.artist_name;
    BOOL success = [dataBase executeUpdate:@"INSERT INTO t_downloadedMusic (song_id ,song_name,mp3Url,artist_name) VALUES (?, ? ,? ,?)",song_id,song_name,mp3Url,artist_name];
    if (success) {
        YZGLog(@"storeMusicForMusic success");
    }
    else{
        YZGLog(@"storeMusicForMusic faile");
    }
}

/**
 根据歌曲item获得歌曲的路径
 
 @param musicItem 歌曲item
 @return 歌曲的路径
 */
-(NSString *)songPathForMusicItem:(YZGMusicItem *)musicItem{
    NSString * musicDirectory = [self createDirectoryIfNotExists:@"yzgMusic"];
    NSString *fullPath = [musicDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",musicItem.song_id]];
    return fullPath;
}
/**
 根据歌曲id获得歌词的路径
 
 @param song_id 歌曲id
 @return 歌词的路径
 */
-(NSString *)lyricsPathWithSong_id:(NSString *)song_id{
    NSString * lyricsDirectory = [self createDirectoryIfNotExists:@"yzgMusicLyrics"];
    NSString *fullPath = [lyricsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",song_id]];
    return fullPath;
}

-(NSString *)createDirectoryIfNotExists:(NSString *)directoryName{
    NSString *cachePath = [self getCachePath];
    NSString * directory = [cachePath stringByAppendingPathComponent:directoryName];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:directory];
    if (!isExists) {
        NSError * error = nil;
        BOOL isCreateSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (isCreateSuccess) {
             YZGLog(@"create %@ Directory success---",directoryName);
        } else {
            YZGLog(@"create %@ Directory fail reson%@---",directoryName,[error localizedDescription]);
        }
    }else{
        YZGLog(@"directoryName %@ 已存在---",directoryName);
        YZGLog(@"%@",directory);
    }
    return directory;
}

-(NSString *)getCachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 根据歌曲id从本地已下载的歌词文件,读取歌词
 
 @param song_id 歌曲id
 @return 歌词字符串
 */
-(NSString *)lyricsFromCacheForSong_id:(NSString *)song_id
{
    NSString *lyrics;
    
    NSString *lyricsPath = [self lyricsPathWithSong_id:song_id];
    if (lyricsPath) {
        NSError *error ;
        
        NSURL *url = [NSURL URLWithString:lyricsPath];
        if (url) {
            lyrics = [NSString stringWithContentsOfFile:lyricsPath encoding:NSUTF8StringEncoding error:&error];
            if (!lyrics || lyrics.length <= 0)
            {
                NSLog(@"lyrics FromCache error = %@",error.description);
            }
        }
    }
    return lyrics;
}

-(NSArray *)allDownloadedMusic
{
    FMResultSet *set = [dataBase executeQuery:@"select * from t_downloadedMusic"];
    NSMutableArray *allMusics = [NSMutableArray array];
    while ([set next]) {
        YZGMusicItem *rowItem = [[YZGMusicItem alloc]init];
        rowItem.musicStatus = YZGMusicDownLoaded;
        rowItem.song_id = [set stringForColumn:@"song_id"];
        rowItem.song_name = [set stringForColumn:@"song_name"];
        rowItem.mp3Url = [set stringForColumn:@"mp3Url"];
        rowItem.artist_name = [set stringForColumn:@"artist_name"];
        [allMusics addObject:rowItem];
    }
    return [allMusics copy];
}

-(NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
-(NSMutableArray *)tempLyricsArray{
    if (!_tempLyricsArray) {
        _tempLyricsArray = [NSMutableArray array];
    }
    return _tempLyricsArray;
}

-(NSMutableArray *)playingLyricsArray{
    if (!_playingLyricsArray) {
        _playingLyricsArray = [NSMutableArray array];
    }
    return _playingLyricsArray;
}
@end

//
//  ChatLyricsView.m
//  sisitv_ios
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatLyricsView.h"
#import "ChatLyricsCell.h"
#import <MJExtension/MJExtension.h>
@interface ChatLyricsView ()<UITableViewDelegate,UITableViewDataSource>
/**
 歌词TableView
 */
@property (nonatomic , strong) UITableView *lyricsView;

@property (nonatomic , strong) NSMutableArray *lyricsData;

@property (nonatomic , assign) NSInteger currentPlayIndex;

@end

@implementation ChatLyricsView

//进行了self = [super init];修改 魏友臣 2017/5/11
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.lyricsData = [NSMutableArray array];
        [self initLyricsView];
    }
    return self;
}

-(void)initLyricsView
{
    self.lyricsView = [[UITableView alloc]init];
    self.lyricsView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.lyricsView];
    [self.lyricsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lyricsView registerNib:[UINib nibWithNibName:@"ChatLyricsCell" bundle:nil] forCellReuseIdentifier:@"ChatLyricsCell"];
    self.lyricsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lyricsView.delegate = self;
    self.lyricsView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricsData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZGMusicItem *lyricsItem = self.lyricsData[indexPath.row];
    ChatLyricsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatLyricsCell" forIndexPath:indexPath];
    cell.lyricsItem = lyricsItem;
    return cell;
}

-(void)startLoadLyrics:(NSArray *)lyrics{
    
    if (!lyrics || lyrics.count<=0) return;
   
    [self.lyricsData removeAllObjects];
    
    for (NSDictionary *lyricDic in lyrics) {
        YZGMusicItem *lyricItem = [[YZGMusicItem alloc]init];
        lyricItem.lyric = [[lyricDic allValues] firstObject];
        lyricItem.timestamp = [[lyricDic allKeys] firstObject];
        if (lyricItem.timestamp.floatValue >0) {
            [self.lyricsData addObject:lyricItem];
        }
    }
    [self.lyricsView reloadData];
    self.currentPlayIndex = 0;
    [self selectLyrics];
}

-(void)currentBgmPlayTime:(float)bgmPlayTime{
    if (!self.lyricsData || self.lyricsData.count<=0) { return; }
    if (self.currentPlayIndex>=self.lyricsData.count-1) { return; }
    YZGMusicItem *nextLyricItem = self.lyricsData[self.currentPlayIndex + 1];
    CGFloat nextLyricTime = nextLyricItem.timestamp.floatValue;
    if (bgmPlayTime >= nextLyricTime) {
        self.currentPlayIndex++;
        if (self.currentPlayIndex>=self.lyricsData.count) { return; }
        [self selectLyrics];
    }
}

-(void)selectLyrics{
    [self.lyricsView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

-(void)stopLoadLyrics{
    self.currentPlayIndex = 0;
    [self.lyricsData removeAllObjects];
    [self.lyricsView reloadData];
}
-(void)dealloc{
    YZGLog(@"-------------chatLyricsView  dealloc-----------------");

}
@end

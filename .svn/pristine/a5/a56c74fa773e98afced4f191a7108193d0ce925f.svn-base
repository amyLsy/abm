//
//  ChatAlertDownLoadMusicController.m
//  xiuPai
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatDownLoadedMusicController.h"
#import "ChatDeleteMusicController.h"
#import "BaseNavgationController.h"
#import "ChatMusicDataSource.h"
#import "YZGDownloadMusic.h"

@interface ChatDownLoadedMusicController ()

@end

@implementation ChatDownLoadedMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor clearColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToEnterEditingMode:)];
    [self.view addGestureRecognizer:ges];
}
-(void)pullDownToRefresh{
    YZGTableViewSectionItem *sectionItem = [self.dataSource.sectionItems firstObject];
    [sectionItem.rowItems removeAllObjects];
    [sectionItem.rowItems addObjectsFromArray:[[YZGDownloadMusic shareInstance] allDownloadedMusic]];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullDownToRefresh];
}
-(void)createDataSource{
    self.dataSource = [[ChatMusicDataSource alloc] initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc] init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickPlayMusic:(UIButton *)button withItem:(YZGMusicItem *)musicItem{
    NSString *musicPath = [[YZGDownloadMusic shareInstance] playingSongPathForMusicItem:musicItem];
    self.playButtonClick(musicPath,[[YZGDownloadMusic shareInstance] playingLyricsForMusicItem:musicItem]);
}
-(void)longPressToEnterEditingMode:(UILongPressGestureRecognizer *)ges{
    if (ges.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    ChatDeleteMusicController *delete = [[ChatDeleteMusicController alloc]init];
    BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:delete];
    [self presentViewController:nav animated:YES completion:nil];
}

@end

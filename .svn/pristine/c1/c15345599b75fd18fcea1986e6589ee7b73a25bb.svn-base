//
//  ChatAlertSearchMusicController.m
//  xiuPai
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatSearchMusicController.h"
#import "ChatMusicDataSource.h"
#import "HttpTool.h"
#import "SearchBar.h"
#import "YZGDownloadMusic.h"
#import "AlertTool.h"

@interface ChatSearchMusicController ()<YZGTableViewCellDelegate>

@property (nonatomic , strong) SearchBar *searchBar ;

@end

@implementation ChatSearchMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
    }];
} 
-(void)createDataSource{
    self.dataSource = [[ChatMusicDataSource alloc] initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc] init];
    [self.dataSource.sectionItems addObject:sectionItem];
}
-(SearchBar *)searchBar
{
    if (!_searchBar)
    {
        SearchBar *searchBar=[[SearchBar alloc]init];
        searchBar.placeholderString = @"请输入歌曲名称";
        [self.view addSubview:searchBar];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
        _searchBar = searchBar;
        KWeakSelf;
        searchBar.clickSearchButton =^(){
            [ws searchButtonClick];
        };
    }
    return _searchBar;
}

-(void)searchButtonClick{
    YZGTableViewSectionItem *sectionItem = [self.dataSource.sectionItems firstObject];
    [sectionItem.rowItems removeAllObjects];
    KWeakSelf;
    [[YZGDownloadMusic shareInstance] requestMusicWithParam:@{@"keyword":self.searchBar.text} success:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            [sectionItem.rowItems addObjectsFromArray:result];
            [ws.tableView reloadData];
        }
    }];
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickPlayMusic:(UIButton *)button withItem:(YZGMusicItem *)musicItem{
    NSString *musicPath = [[YZGDownloadMusic shareInstance] playingSongPathForMusicItem:musicItem];
    self.playButtonClick(musicPath,[[YZGDownloadMusic shareInstance] playingLyricsForMusicItem:musicItem]);
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickDownloadMusic:(UIButton *)button withItem:(YZGMusicItem *)item{
    KWeakSelf;
    [[YZGDownloadMusic shareInstance] downLoadMusicForMusicItem:item downloadProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            item.musicStatus = YZGMusicDownLoading;
            item.currentProgress = progress;
            [cell setItem:item forIndexPath:nil];
        });
    } completion:^(BOOL isSuccess, id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                item.musicStatus = YZGMusicDownLoaded;
            }else{
                item.musicStatus = YZGMusicDownFailed;
            }
            [AlertTool ShowErrorInView:KKeyWindow withTitle:result];
            [ws.tableView reloadData];
        });
    }];
}
@end

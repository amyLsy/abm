//
//  ChatDeleteMusicController.m
//  sisitv_ios
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatDeleteMusicController.h"
#import "ChatMusicDataSource.h"
#import "YZGDownloadMusic.h"
@interface ChatDeleteMusicController ()

@property (nonatomic , strong) NSMutableArray *delete;

@end

@implementation ChatDeleteMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    //编辑模式下是否可以多选,选中后前面出现对勾
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
    self.delete = [NSMutableArray array];
    [self addNavigationItem];
    [self pullDownToRefresh];
}

-(void)addNavigationItem{
    // 自定义返回按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [leftBtn setTitle:@"删除" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(deleteSeletedMusic) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self pullDownToRefresh];
}
-(void)pullDownToRefresh{
    YZGTableViewSectionItem *sectionItem = [self.dataSource.sectionItems firstObject];
    [sectionItem.rowItems removeAllObjects];
    NSArray *dataArray = [[YZGDownloadMusic shareInstance] allDownloadedMusic];
    for (YZGMusicItem *musicItem in dataArray) {
        musicItem.musicStatus = YZGMusicDownDeleting;
    }
    [sectionItem.rowItems addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

-(void)createDataSource{
    self.dataSource = [[ChatMusicDataSource alloc] initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc] init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZGTableViewSectionItem *sectionItem = self.dataSource.sectionItems.firstObject;
    YZGTableViewRowItem *rowItem =  sectionItem.rowItems[indexPath.row];
    [self.delete addObject:rowItem];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZGTableViewSectionItem *sectionItem = self.dataSource.sectionItems.firstObject;
    YZGTableViewRowItem *rowItem =  sectionItem.rowItems[indexPath.row];
    [self.delete removeObject:rowItem];
}
-(void)deleteSeletedMusic{
    YZGTableViewSectionItem *sectionItem = self.dataSource.sectionItems.firstObject;
    [sectionItem.rowItems removeObjectsInArray:self.delete];
    
    for (YZGMusicItem *musicItem in self.delete) {
        [[YZGDownloadMusic shareInstance] deleteSongForMusicItem:musicItem];
    }
    [self.delete removeAllObjects];
    [self.tableView setEditing:NO];
    [self close];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

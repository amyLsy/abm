//
//  ChatGuardListController.m
//  xiuPai
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatGuardListController.h"
#import "GuardDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
@interface ChatGuardListController ()<YZGTableViewCellDelegate>

@end

@implementation ChatGuardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(20, 0,KScreenWidth - 40, 300);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.center = self.view.center;
    RoomParam *roomParam = [RoomParam roomParam];
    [RoomModel getGuardListWithParam:roomParam success:^(id responseObj, BOOL successGetInfo) {
        if (successGetInfo) {
            [AlertTool Hidden];
            YZGTableViewSectionItem *sectionItem = [self.dataSource.sectionItems firstObject];
            [sectionItem.rowItems addObjectsFromArray:responseObj];
            [self.tableView reloadData];
        }else{
            [AlertTool ShowInView:KKeyWindow  onlyWithTitle:responseObj hiddenAfter:1.0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeGuardList)];
    [self.view addGestureRecognizer:tap];
}

-(void)createDataSource{
    self.dataSource = [[GuardDataSource alloc]initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)closeGuardList{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickCancelButton:(UIButton *)button withUserId:(NSString *)userId{
    RoomParam *roomParam = [RoomParam roomParam];
    roomParam.ID = userId;
    [RoomModel managerLiveGuard:roomParam withTitle:button.titleLabel.text  success:^(id responseObj, BOOL successGetInfo) {
        if (successGetInfo) {
            if ([responseObj containsString:@"取消"]) {
                self.cancelGuardCallBack(userId);
                [button setTitle:@"设为场控" forState:UIControlStateNormal];
            }else{
                self.setGuardCallBack(userId);
                [button setTitle:@"取消场控" forState:UIControlStateNormal];
            }
        }else
        {
            [AlertTool ShowInView:self.view onlyWithTitle:responseObj hiddenAfter:1.0];
        }
    }];
}

@end

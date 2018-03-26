//
//  UserInfoDataSource.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UserInfoDataSource.h"

@implementation UserInfoDataSource
@synthesize delegateController = _delegateController;

-(Class)tableView:(UITableView *)tableView cellClassForSection:(NSInteger)section{
    return [UtilityCell class];
}

-(YZGHeaderView *)headerViewForTableView:(UITableView *)tableView{
    UserInfoHeaderView *headerView = [UserInfoHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, KScreenWidth, [headerView headerHeightForTableView:tableView]);
    headerView.delegate = self.delegateController;
    return headerView;
}

@end

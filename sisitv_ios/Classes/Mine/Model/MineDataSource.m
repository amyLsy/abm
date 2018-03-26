//
//  MineDataSource.m
//  xiuPai
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MineDataSource.h"
#import "LGReferencesCell.h"

@implementation MineDataSource
@synthesize delegateController = _delegateController;

-(Class)tableView:(UITableView *)tableView cellClassForSection:(NSInteger)section{
    return [MineTableViewCell class];
}

-(YZGHeaderView *)headerViewForTableView:(UITableView *)tableView{
    MineHeaderView *headerView = [MineHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, KScreenWidth, [headerView headerHeightForTableView:tableView]);
    headerView.delegate = self.delegateController;
    return headerView;
}
@end

@implementation ReferencesDataSource

-(Class)tableView:(UITableView *)tableView cellClassForSection:(NSInteger)section{
    
    return [LGReferencesCell class];
}


@end

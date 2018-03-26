//
//  YZGTableViewController.m
//  sisitv
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGTableViewController.h"

@interface YZGTableViewController ()
@end

@implementation YZGTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    [self creatTableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}


-(void)creatTableView{
    self.tableView = [[YZGTableView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth, KHadTabBarAndNavBarViewHeight) style:UITableViewStylePlain];
    self.tableView.yzgDelegate = self;
    self.tableView.yzgDataSource = self.dataSource;
    [self.view addSubview:self.tableView];
}

-(void)createDataSource{
    @throw @"You Must implement This Mehtod";
}

-(void)dealloc{
    self.tableView.yzgDelegate = nil;
    self.tableView.yzgDataSource = nil;
}

@end

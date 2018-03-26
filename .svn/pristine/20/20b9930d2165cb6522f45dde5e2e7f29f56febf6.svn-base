//
//  LGReferencesViewController.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGReferencesViewController.h"
#import "MJRefresh.h"
#import "MineDataSource.h"
#import "LGMineParam.h"
#import "AlertTool.h"
#import "Account.h"
#import "LGReferencesModel.h"

@interface LGReferencesViewController ()

@end

@implementation LGReferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createModel{
    self.listModel = [[LGReferencesModel alloc] initWithDelegate:self];
}

-(void)createDataSource{
    self.dataSource = [[ReferencesDataSource alloc] initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)configForRequest{
    LGMineParam *showListParam = [[LGMineParam alloc] init];
    showListParam.token = [Account shareInstance].token;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_rcmd_list" withRequestParam:showListParam];
    self.listModel.netRequest = mainListRequest;
}

-(void)requestDidSuccess{
    if (self.listModel.responseObject.count == 0) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem.rowItems addObjectsFromArray: self.listModel.responseObject];
}

//点击的回调
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    
}

@end

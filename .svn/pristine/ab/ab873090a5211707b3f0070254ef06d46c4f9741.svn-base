//
//  MainAttentionVC.m
//  sisitv_ios
//
//  Created by 胡祥 on 2017/5/12.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "MainAttentionVC.h"
#import "MJRefresh.h"

@interface MainAttentionVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *myTabelview;
@end

@implementation MainAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableViews];
    
    
}

#pragma mark - ---network data---

#pragma mark 刷新
- (void)upDataAct
{
    
    
}
#pragma mark 加载更多
- (void)getMoreDataAct
{
    
    
}

#pragma mark - ----TableViews----
//
#pragma mark  init
- (void)initTableViews
{
    _myTabelview = [[UITableView alloc]initWithFrame:self.view.frame];
    _myTabelview.delegate = self;
    _myTabelview.dataSource = self;
    _myTabelview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_myTabelview];
    _myTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upDataAct)];
    _myTabelview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDataAct)];
    
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

#pragma mark datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

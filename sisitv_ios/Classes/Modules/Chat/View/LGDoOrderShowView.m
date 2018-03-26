//
//  LGDoOrderShowView.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/30.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGDoOrderShowView.h"
#import "LGDoOrderShowCell.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "Account.h"
#import "AlertTool.h"
#import "LGShowListCell.h"
#import "LGShowListModel.h"
@interface LGDoOrderShowView()
@property(nonatomic,strong) NSMutableArray *userhowArray;
@property(nonatomic,strong) NSMutableArray *orderShowListArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *showType;

@property (assign, nonatomic) NSInteger showListType;
@end

@implementation LGDoOrderShowView{
   NSInteger  _limit_begin;
}

static NSString *cellID = @"LGDoOrderShowCell";
static NSString *showcellID = @"LGShowListCell";

- (NSMutableArray *)userhowArray{
    
    if (_userhowArray == nil) {
        _userhowArray = [NSMutableArray array];
    }
    return _userhowArray;
    
    
}

- (NSMutableArray *)orderShowListArray{
    
    if (_orderShowListArray == nil) {
        
        _orderShowListArray = [NSMutableArray array];
    }
    
    return _orderShowListArray;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"LGDoOrderShowCell" bundle:nil]
         forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LGShowListCell" bundle:nil]
         forCellReuseIdentifier:showcellID];
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    _limit_begin = 0;

}
- (IBAction)showtypeAtion:(UISegmentedControl *)sender {
    
    _showListType = sender.selectedSegmentIndex;
    _limit_begin = 0;
    [self.userhowArray removeAllObjects];
    [self.orderShowListArray removeAllObjects];
    [self.tableView.mj_footer resetNoMoreData];
    [self loadData];
    
    
}

- (void)setUid:(NSString *)uid{
    _uid = uid;
    
    [self loadData];
}

- (void)refresh{
    
    //获取主播的节目列表
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"limit_begin"] = @"0";
    param[@"limit_num"] = @"20";
    param[@"uid"] = _uid;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUserShow param:param success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *data  = responseObject[@"data"];
            if (data.count < 20) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.userhowArray = [LGShowListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];

        }
        
    } faile:^{
        
    }];
    
}

- (void)loadData{

    if (_showListType == 0) {
        //获取主播的节目列表
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"limit_begin"] = @"0";
        param[@"limit_num"] = @"20";
        param[@"uid"] = _uid;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUserShow param:param success:^(id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] integerValue] == 200) {
                  NSArray *data  = responseObject[@"data"];
                if (data.count < 20) {
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.userhowArray addObjectsFromArray:[LGShowListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                [self.tableView reloadData];
                
            }
            
        } faile:^{
            
        }];
    }else{
        //获取的表演节目列表
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"limit_begin"] = @(_limit_begin);
        param[@"limit_num"] = @20;
        param[@"uid"] = _uid;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagOrderhowList param:param success:^(id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] integerValue] == 200) {
                NSArray *data  = responseObject[@"data"];
                if (data.count < 20) {
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.orderShowListArray addObjectsFromArray:responseObject[@"data"]];
                [self.tableView reloadData];
                
            }
            
        } faile:^{
            
        }];
        
    }
    
   
    
    
}

- (void)refreshDoShowList{
    
    
    //获取的表演节目列表
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"limit_begin"] = @"0";
    param[@"limit_num"] = @20;
    param[@"uid"] = _uid;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagOrderhowList param:param success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *data  = responseObject[@"data"];
            if (data.count < 20) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.orderShowListArray  = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self.tableView reloadData];
            
        }
        
    } faile:^{
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_showListType == 0) {
        return self.userhowArray.count;
    }
    return self.orderShowListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_showListType == 0) {
         return 102.5;
    }
    return 56;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_showListType == 1) {
        LGDoOrderShowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        NSDictionary *dict = self.orderShowListArray[indexPath.row];
        cell.titleLable.text = dict[@"title"];
        cell.descLabel.text = dict[@"description"];
        cell.addTime_label.text = dict[@"add_time"];
        if ([dict[@"status"] integerValue] == 2) {
            cell.statusLabel.text = @"表演中";
        }else{
            
            cell.statusLabel.text = @"即将演出";
        }
        
        return cell;
    }else{
        
        LGShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:showcellID];
        [cell setItem:self.userhowArray[indexPath.row] forIndexPath:indexPath];
        
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_showListType == 0) {
        
        if (_userDoOrderShowCallback) {
            if (self.userhowArray.count) {
                LGShowListModel *model = self.userhowArray[indexPath.row];
                _userDoOrderShowCallback(model,self);
            }
            
        }
    }else{
        
        if (_userDohowCallback) {
            if (self.orderShowListArray[indexPath.row]) {
                NSDictionary *dict = self.orderShowListArray[indexPath.row];
                _userDohowCallback(dict[@"id"],self);
            }
           
            
            
        }
        
        
    }
    
}


- (IBAction)closeAtion:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)showswitchAtion:(UISwitch *)sender {
    
    if (self.showSwitchCallback) {
         self.showSwitchCallback(sender);
    }
   
    
}

@end

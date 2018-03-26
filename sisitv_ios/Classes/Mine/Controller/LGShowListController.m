//
//  LGShowListController.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGShowListController.h"
#import "LGShowListModel.h"
#import "LGShowDataSource.h"
#import "LGMineParam.h"
#import "Account.h"
#import "LGShowAddView.h"
#import "LGShowAddView.h"
#import "MJRefresh.h"
#import "LGShowSelectedFucView.h"
#import "HttpTool.h"
#import "AlertTool.h"
@interface LGShowListController ()

@end

@implementation LGShowListController{
    
    BOOL _isShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"添加"forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.tableView.mj_header beginRefreshing];
}

- (void)add{
    
    if (_isShow == YES) {
        return;
    }
    //添加
    LGShowAddView *showView =  [LGShowAddView viewFromeNib];
    showView.isEditor = NO;
    [self.view addSubview:showView];
    showView.frame = self.view.bounds;
    showView.submit = ^(UIView *view) {
        _isShow = NO;
        [self.listModel loadData];
        [self.tableView reloadData];
        if (_backFinish) {
            _backFinish();
        }
        [view removeFromSuperview];
    };
    showView.cancel = ^(LGShowAddView *view) {
        _isShow = NO;
    };
    _isShow = YES;
    [self.view addSubview:showView];
}

-(void)createModel{
    self.listModel = [[LGShowListModel alloc] initWithDelegate:self];
}

-(void)createDataSource{
    self.dataSource = [[LGShowDataSource alloc] initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)configForRequest{
    LGMineParam *showListParam = [[LGMineParam alloc] init];
    showListParam.token = [Account shareInstance].token;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_user_show" withRequestParam:showListParam];
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
    
    LGShowListModel *model = item;
    LGShowSelectedFucView *fucView = [LGShowSelectedFucView viewFromeNib];
    
    fucView.buttonClick = ^(UIButton *btn ,UIView *fucView) {
        switch (btn.tag) {
                //启用
            case 1:{
                
                [self requestShowStatu:@"1" item_id:model.id fucView:fucView];
            }
                break;
            //禁止
            case 2:{
                [self requestShowStatu:@"-1" item_id:model.id fucView:fucView];
            }
                //编辑
                break;
            case 3:{
                //进入编辑
                
                [fucView removeFromSuperview];
                LGShowAddView *editView = [LGShowAddView viewFromeNib];
                editView.titleLabel.text = @"编辑";
                editView.titleTextField.text = model.title;
                editView.descTitleTextField.text = model.desc;
                editView.timeTextField.text = model.duration;
                editView.priceTextField.text = [NSString stringWithFormat:@"%.2f",model.price];
                [self.view addSubview:editView];
                 editView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                editView.isEditor = YES;
                editView.edit = ^(LGShowAddView *view) {
                  
                    NSString *title = view.titleTextField.text;
                    NSString *desc = view.descTitleTextField.text;
                    NSString *duration = view.timeTextField.text;
                    NSString *price = view.priceTextField.text;
                    
                    if (title.length && desc.length && duration.length && price.length) {
                        NSMutableDictionary *param = [NSMutableDictionary dictionary];
                        param[@"token"] = [Account shareInstance].token;
                        param[@"title"] = title;
                        param[@"desc"] = desc;
                        param[@"duration"] = duration;
                        param[@"price"] = price;
                        param[@"item_id"] = model.id;
                        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserhowEdit param:param success:^(id responseObject) {
                            if ([responseObject[@"code"] integerValue] == 200) {
                                [AlertTool ShowErrorInView:self.view withTitle:@"编辑成功"];
                                _isShow = NO;
                                [view removeFromSuperview];
                                [self.listModel loadData];
                                [self.tableView reloadData];
                            }else{
                                  [AlertTool ShowErrorInView:self.view withTitle:@"编辑失败"];
                            }
                        } faile:^{
                            [AlertTool ShowErrorInView:self.view withTitle:@"请求错误"];
                        }];
                    }else{
                        [AlertTool ShowErrorInView:self.view withTitle:@"选项不能为空"];
                    }
                };
            }
                //删除
                break;
            case 4:{
                [self requestShowStatu:@"2" item_id:model.id fucView:fucView];
            }
                //取消
                break;
                
            case 5:{
                _isShow = NO;
                [fucView removeFromSuperview];
            }
                break;
                
            default:
                break;
        }
    };
    
    fucView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    _isShow = YES;
    [self.view addSubview:fucView];
}

-(void)requestShowStatu:(NSString *)status item_id:(NSString *)item_id fucView:(UIView *)fucView{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"item_id"] = item_id;
    param[@"status"] = status;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagShowStatus param:param success:^(id responseObject) {
        _isShow = NO;
        if ([responseObject[@"code"] integerValue] == 200) {
            [AlertTool ShowErrorInView:self.view withTitle:@"操作成功"];
//            [self.tableView.mj_header beginRefreshing];
            [self.listModel loadData];
            [self.tableView reloadData];
        }else{
            [AlertTool ShowErrorInView:self.view withTitle:@"操作成功"];
        }
        [fucView removeFromSuperview];
    } faile:^{
        _isShow = NO;
        [fucView removeFromSuperview];
        [AlertTool ShowErrorInView:self.view withTitle:@"网络错误"];
    }];
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

//
//  CostViewController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CostViewController.h"
#import "Account.h"
#import "AlertTool.h"
#import "YZGPay.h"
#import "AlertTool.h"
#import "CostModel.h"
#import "CostTableViewDataSource.h"
#import "YZGAppSetting.h"
#import "MMHeaderView.h"
#import "MMRechargeFooterView.h"
#import "MMRechargeTableViewCell.h"

@interface CostViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) MMHeaderView *headerView;
@property (nonatomic, strong) CostRowItem *currentProduct;
@end

@implementation CostViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"美美";
    _selectIndex = 0;
    [self setupTableView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyProductEnd:) name:kBuyProductEnd object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MMRechargeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MMRechargeTableViewCell"];
    //tableHeaderView
    _headerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MMHeaderView class]) owner:nil options:nil]lastObject];
    _headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 289);
    self.tableView.tableHeaderView = _headerView;
    //tableFooterView
    MMRechargeFooterView *footerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MMRechargeFooterView class]) owner:nil options:nil]lastObject];
    footerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 119);
    self.tableView.tableFooterView = footerView;
    //callback
    KWeakSelf;
    _headerView.meimeiValueLabel.text = [Account shareInstance].balance;
    _headerView.moneyValue = ^(CostRowItem *moneyValue) {
        footerView.moneyLabel.text = moneyValue.money_num;
        ws.currentProduct = moneyValue;
    };
    footerView.btnAction = ^{
        if (ws.currentProduct == nil) {
            [AlertTool ShowErrorInView:self.view withTitle:@"请先选择充值金额哦~"];
            return ;
        }
        [AlertTool showWithCustomModeInView:self.view];
        
        PayParam *param = [[PayParam alloc]init];
        param.item_id = ws.currentProduct.ID;
        if (ws.selectIndex == 0) {
            [[YZGPay shareInstance] payWithPlatForm:AliPayPlat withParam:param];
        }else{
            [[YZGPay shareInstance] payWithPlatForm:WeChatPayPlat withParam:param ];
        }
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _selectIndex = indexPath.row;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMRechargeTableViewCell"];
    NSArray *iconArray = @[@"wallet_alipay",@"wechat"];
    NSArray *nameArray = @[@"支付宝支付",@"微信支付"];
    cell.iconImgView.image = [UIImage imageNamed:iconArray[indexPath.row]];
    cell.rechargeNameLabel.text = nameArray[indexPath.row];
    cell.selectBtn.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _selectIndex) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else{
        [cell.selectBtn setImage:[UIImage imageNamed:@"choose_unselected"] forState:UIControlStateNormal];
    }
    return cell;
}



-(void)loadData{
    KWeakSelf;
    [CostModel getDiamondListSuccess:^(BOOL successGetInfo, NSArray *costRowItems) {
        YZGLog(@"costRowItems : %@",costRowItems);
        ws.headerView.productArray = [NSMutableArray arrayWithArray:costRowItems];
    }];
}

-(void)buyProductEnd:(NSNotification *)noti{
    NSDictionary *result = [noti userInfo];
    [AlertTool ShowInView:self.view onlyWithTitle:result[@"descrp"] hiddenAfter:2.0];
    if ([result[@"status"] isEqualToString:@"1"]) {
        Account *account = [Account shareInstance];
        KWeakSelf;
        [account getAccountInfoSuccess:^{
            ws.headerView.meimeiValueLabel.text = account.balance;
        } faile:nil];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

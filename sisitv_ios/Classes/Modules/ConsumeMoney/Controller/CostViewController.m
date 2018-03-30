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
@end

@implementation CostViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"美美";
    _selectIndex = 0;
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyProductEnd:) name:kBuyProductEnd object:nil];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MMRechargeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MMRechargeTableViewCell"];
    //tableHeaderView
    MMHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MMHeaderView class]) owner:nil options:nil]lastObject];
    headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 289);
    self.tableView.tableHeaderView = headerView;
    //tableFooterView
    MMRechargeFooterView *footerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MMRechargeFooterView class]) owner:nil options:nil]lastObject];
    footerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 119);
    self.tableView.tableFooterView = footerView;
    //callback
    __block NSString *money = nil;
    headerView.moneyValue = ^(NSString *moneyValue) {
        footerView.moneyLabel.text = moneyValue;
        money = moneyValue;
    };
    footerView.btnAction = ^{
        if (money == nil) {
            [AlertTool ShowErrorInView:self.view withTitle:@"请先选择充值金额类型哦~"];
            return ;
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
//    cell.btnAction = ^(NSInteger selectIndex) {
//        _selectIndex = selectIndex;
//        [self.tableView reloadData];
//    };
    return cell;
}



-(void)createDataSource{
//    self.dataSource = [[CostTableViewDataSource alloc]init];
//    Account *account =[Account shareInstance];
//    YZGTableViewSectionItem *sectionItem0 = [[YZGTableViewSectionItem alloc]init];
//    CostRowItem *rowItem0 = [[CostRowItem alloc]init];
//    rowItem0.balance = account.balance;
//    [sectionItem0.rowItems addObject:rowItem0];
//    [self.dataSource.sectionItems addObject:sectionItem0];
//
    [CostModel getDiamondListSuccess:^(BOOL successGetInfo, NSArray *costRowItems) {
        if (successGetInfo) {
//            YZGTableViewSectionItem *sectionItem1 = [[YZGTableViewSectionItem alloc]init];
//            [sectionItem1.rowItems addObjectsFromArray:costRowItems];
//            [self.dataSource.sectionItems addObject:sectionItem1];
//            [self.tableView reloadData];
        }
    }];
}

//yzgdelegate
-(void)didSelectItem:(id)object atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return;
    }
    [self payWithObject:object];
}


- (void)payWithObject:(CostRowItem *)costRowItem{
    
    PayParam *param = [[PayParam alloc]init];
    param.item_id = costRowItem.ID;
    
//    KWeakSelf;
//    if (![[YZGAppSetting sharedInstance] isInAppleStore]){
//        [AlertTool showWithCustomModeInView:ws.view];
//        [[YZGPay shareInstance] payWithPlatForm:ApplePayPlat withParam:param];
//        return;
//    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 微信支付
    UIAlertAction *wx = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AlertTool showWithCustomModeInView:self.view];
        [[YZGPay shareInstance] payWithPlatForm:WeChatPayPlat withParam:param ];
        
    }];
    // 支付宝
    UIAlertAction *alipay = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AlertTool showWithCustomModeInView:self.view];
        [[YZGPay shareInstance] payWithPlatForm:AliPayPlat withParam:param];
    }];
    [controller addAction:wx];
    [controller addAction:alipay];
    
//    // Apple内购
////    UIAlertAction *iap = [UIAlertAction actionWithTitle:@"Apple内购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [AlertTool showWithCustomModeInView:self.view];
//        [[YZGPay shareInstance] payWithPlatForm:ApplePayPlat withParam:param];
////    }];
////    [controller addAction:iap];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancleAction];
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)buyProductEnd:(NSNotification *)noti{
    NSDictionary *result = [noti userInfo];
    [AlertTool ShowInView:self.view onlyWithTitle:result[@"descrp"] hiddenAfter:2.0];
    if ([result[@"status"] isEqualToString:@"1"]) {
        Account *account = [Account shareInstance];
        KWeakSelf;
        [account getAccountInfoSuccess:^{
//            YZGTableViewSectionItem *sectionItem0 = [self.dataSource.sectionItems firstObject];
//            CostRowItem *rowItem = [sectionItem0.rowItems firstObject];
//            rowItem.balance = account.balance;
//            [ws.tableView reloadData];
        } faile:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

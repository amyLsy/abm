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
@interface CostViewController ()<YZGTableViewDelegate>


@end

@implementation CostViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的账户";
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyProductEnd:) name:kBuyProductEnd object:nil];
}



-(void)createDataSource{
    self.dataSource = [[CostTableViewDataSource alloc]init];
    Account *account =[Account shareInstance];
    YZGTableViewSectionItem *sectionItem0 = [[YZGTableViewSectionItem alloc]init];
    CostRowItem *rowItem0 = [[CostRowItem alloc]init];
    rowItem0.balance = account.balance;
    [sectionItem0.rowItems addObject:rowItem0];
    [self.dataSource.sectionItems addObject:sectionItem0];
    
    [CostModel getDiamondListSuccess:^(BOOL successGetInfo, NSArray *costRowItems) {
        if (successGetInfo) {
            YZGTableViewSectionItem *sectionItem1 = [[YZGTableViewSectionItem alloc]init];
            [sectionItem1.rowItems addObjectsFromArray:costRowItems];
            [self.dataSource.sectionItems addObject:sectionItem1];
            [self.tableView reloadData];
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
            YZGTableViewSectionItem *sectionItem0 = [self.dataSource.sectionItems firstObject];
            CostRowItem *rowItem = [sectionItem0.rowItems firstObject];
            rowItem.balance = account.balance;
            [ws.tableView reloadData];
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

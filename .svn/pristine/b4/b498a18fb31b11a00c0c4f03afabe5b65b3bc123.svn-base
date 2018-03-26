//
//  MyGiftController.m
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MyGiftController.h"
#import "MYGiftDataSource.h"
#import "MYGiftModel.h"
#import "Account.h"
#import "MJRefresh.h"
#import "YZGListModel.h"
#import "YZGTableViewRowItem.h"
#import "GiftCell.h"
#import "LGMineParam.h"
#import "AlertTool.h"
#import "HttpTool.h"
#import "MYExchageGiftController.h"

@interface MyGiftController ()

@end

@implementation MyGiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}


-(void)createModel{
    self.listModel = [[MYGiftModel alloc] initWithDelegate:self];
}

-(void)createDataSource{
    self.dataSource = [[MYGiftDataSource alloc] initWithController:self];
    YZGCollectionRowItem *sectionItem = [[YZGCollectionRowItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)configForRequest{
    LGMineParam *param = [[LGMineParam alloc] init];
    param.token = [Account shareInstance].token;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_mypresent_list" withRequestParam:param];
    self.listModel.netRequest = mainListRequest;
}

-(void)requestDidSuccess{
    if (self.listModel.responseObject.count == 0) {
        [self.collectionView.mj_footer endRefreshing];
    }else{
        [self.collectionView.mj_footer resetNoMoreData];
    }
    YZGCollectionSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem.rowItems addObjectsFromArray: self.listModel.responseObject];
}

- (void)createDataSourceAndLayout{
    MYGiftDataSource *dataSource = [[MYGiftDataSource alloc] initWithController:self];
    self.dataSource = dataSource;
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem0];
    CGFloat margin = 1;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    self.cellClassName = @[@"GiftCell"];
}





//点击的回调
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    
    MYGiftModel *model = (MYGiftModel *)item;
    if ([model.status integerValue] == 1) {
        
        [AlertTool ShowErrorInView:self.view withTitle:@"已经兑换等待发货中..."];
        
        return;
    }else if ([model.status integerValue] == 2){
        
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [aler addAction:[UIAlertAction actionWithTitle:@"确认收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exchangeGiftType:3 giftItem:item];
        }]];
        [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:aler animated:YES completion:nil];
    }else if ([model.status integerValue] == 3){
        [AlertTool ShowErrorInView:self.view withTitle:@"你已完成兑换"];

    }
    
    if ([model.status integerValue] == 0) {
        
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [aler addAction:[UIAlertAction actionWithTitle:@"兑换活力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exchangeGiftType:1 giftItem:item];
        }]];
        [aler addAction:[UIAlertAction actionWithTitle:@"兑换实物" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exchangeGiftType:2 giftItem:item];
        }]];
        
        
        
        [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        
        
        
        [self presentViewController:aler animated:YES completion:^{
            
        }];
    }
    
    
    
    
}


- (void)exchangeGiftType:(NSInteger)giftType giftItem:(MYGiftModel *)item{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"present_id"] = item.id;
    param[@"exchange_type"] = @(giftType);
    param[@"token"] = [Account shareInstance].token;
    if (giftType == 2) {
        //兑换实物
        MYExchageGiftController *exVc = [[MYExchageGiftController alloc] init];
        exVc.model = item;
        [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:exVc];
       
    }else if(giftType == 3){
        
        [self requesteExchangeParam:param];
        
    }else{
        
         NSString *message = [NSString stringWithFormat:@"是否兑换成%@活力",item.needcoin];
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [aler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requesteExchangeParam:param];
        }]];
        
    
        [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:aler animated:YES completion:^{
            
        }];
        
    }
    
}


- (void)requesteExchangeParam:(NSMutableDictionary *)param{
    
    
    [AlertTool ShowInView:self.view];
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagPresentExchange param:param success:^(id responseObject) {
        [AlertTool Hidden];
        if ([responseObject[@"code"] integerValue] == 200) {
            [AlertTool ShowInView:self.view onlyWithTitle:@"兑换成功" hiddenAfter:1];
            [self.listModel refreshData];
        }else{
            
            [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
        }
        
        
    } faile:^{
        
    }];
    

}


@end

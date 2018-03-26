//
//  UtilityController.m
//  xiuPai
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UtilityController.h"
#import "UserInfoController.h"
#import "UtilityListModel.h"
#import "UtilityDataSource.h"
#import "Account.h"
#import "AlertTool.h"
@interface UtilityController ()

@property (nonatomic , copy) NSString *titleString;

@property (nonatomic , assign) BOOL utilityStyle;

@end

@implementation UtilityController

-(instancetype)initWithUtilityStyle:(UtilityStyle)utilityStyle{
    if (self = [super init]) {
        if (utilityStyle == UtilityAttention) {
            self.titleString = @"我的关注";
        }else{
            self.titleString = @"我的粉丝";
        }
        self.utilityStyle = utilityStyle;
    }
    return self;
}

-(instancetype)initWithTitle:(UtilityStyle)utilityStyle name:(NSString *)titleName{
    if (self = [super init]) {
        if (utilityStyle == UtilityAttention) {
            self.titleString = @"关注";
        }else{
            self.titleString = @"粉丝";
        }
        self.utilityStyle = utilityStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight);

    [self.tableView yzgStartRefreshing];
}

-(void)createDataSource{
    self.dataSource = [[UtilityDataSource alloc]initWithController:self];
    YZGTableViewSectionItem *sectionItem  = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)createModel{
    self.listModel = [[UtilityListModel alloc] initWithDelegate:self];
}

-(void)configForRequest{
    NSString *requestUrl;
    if (self.utilityStyle == UtilityFans) {
        requestUrl = @"getUserFansList";
    }else if(self.utilityStyle == UtilityAttention){
        requestUrl = @"getUserAttentionList";
    }
    UtilityListParam *utilityParam  = [[UtilityListParam  alloc] init];
    utilityParam.ID = self.ID;
    YZGRequest *rankListRequest = [[YZGRequest alloc] initWithRequestUrl:requestUrl withRequestParam:utilityParam];
    self.listModel.netRequest = rankListRequest;
}

-(void)requestDidSuccess{
    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem.rowItems addObjectsFromArray:self.listModel.responseObject];
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickAttentionStatusWithTitle:(NSString *)title withItem:(id)item{
    UtilityRowItem *utilityRowItem = (UtilityRowItem *)item;
    Account *account = [Account shareInstance];
    AccountParam *param = [AccountParam accountParam];
    param.userid = utilityRowItem.ID;
    KWeakSelf;
    [account attentionOrCancelAttentionWithCurrentButtonTitle:title WithParam:param success:^(BOOL successGetInfo, id responseObj) {
        if (successGetInfo) {
            [item setAttention_status:responseObj];
            [ws.tableView reloadData];
        }else{
            [AlertTool ShowErrorInView:self.tableView withTitle:responseObj];
        }
    }];
}

-(void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    UserInfoController *userInfo = [[UserInfoController alloc]init];
    userInfo.ID = [item ID];
    [self presentNeedNavgation:NO presentendViewController:userInfo];
}

@end

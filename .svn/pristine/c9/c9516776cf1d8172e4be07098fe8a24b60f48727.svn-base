//
//  SearchController.m
//  liveFrame
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchController.h"
#import "SearchBar.h"
#import "Account.h"
#import "UserInfoController.h"
#import "SearchListModel.h"
#import "UtilityDataSource.h"
@interface SearchController ()

@property (nonatomic , strong) SearchBar *searchBar ;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight);
    [self titleView];
}

-(void)titleView
{
    self.navigationItem.titleView = self.searchBar;
}

-(void)createDataSource{
    self.dataSource = [[UtilityDataSource alloc]initWithController:self];
    YZGTableViewSectionItem *sectionItem =  [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}
-(void)createModel{
    self.listModel = [[SearchListModel  alloc] initWithDelegate:self];
}
-(void)configForRequest{
    YZGRequest *search = [[YZGRequest alloc]initWithRequestUrl:@"searchUsers"];
    self.listModel.netRequest = search;
}

-(void)requestDidSuccess{
    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem.rowItems addObjectsFromArray:self.listModel.responseObject];
}

-(SearchBar *)searchBar
{
    if (!_searchBar)
    {
        CGFloat y = 7;
        SearchBar *searchBar=[[SearchBar alloc]initWithFrame:CGRectMake(0, y, KScreenWidth - 76 *KWidthScale, self.navigationController.navigationBar.height -2*y)];
        searchBar.placeholder = @"请输入用户名或ID";
        _searchBar = searchBar;
        KWeakSelf;
        searchBar.clickSearchButton =^(){
            [ws searchButtonClick];
        };
    }
    return _searchBar;
}

-(void)searchButtonClick
{
    [self.searchBar resignFirstResponder];
    SearchListParam *param = [[SearchListParam alloc]init];
    param.keyword = self.searchBar.text;
    self.listModel.listParam = param;
    [self.tableView yzgStartRefreshing];
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickAttentionStatusWithTitle:(NSString *)title withItem:(id)item{
    UtilityRowItem *utilityRowItem = (UtilityRowItem *)item;
    AccountParam *param = [AccountParam accountParam];
    param.userid = utilityRowItem.ID;
    KWeakSelf;
    [[Account shareInstance] attentionOrCancelAttentionWithCurrentButtonTitle:title WithParam:param success:^(BOOL successGetInfo, id responseObj) {
        if (successGetInfo) {
            [item setAttention_status:responseObj];
            [ws.tableView reloadData];
        }
    }];
}

-(void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    UserInfoController *userInfo = [[UserInfoController alloc]init];
    userInfo.ID = [item ID];
    [self presentNeedNavgation:NO presentendViewController:userInfo];
}

@end

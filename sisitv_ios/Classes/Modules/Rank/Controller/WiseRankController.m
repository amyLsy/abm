//
//  WiseRankController.m
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiseRankController.h"
#import "UserInfoController.h"
#import "RankDataSource.h"
#import "RankListModel.h"
#import "RankHeadView.h"
#import "Account.h"
@interface WiseRankController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControl;
@property (nonatomic , copy) NSString *ID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segentHeight;
@property (strong, nonatomic)  RankHeadView *headView;
@end

@implementation WiseRankController

-(instancetype)initWithID:(NSString *)ID{
    if (self = [super init]) {
        self.ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationItem.title = @"智者榜";// ？？？？？？
    CGFloat y = self.segentHeight.constant;
    self.tableView.frame = CGRectMake(0, y, KScreenWidth, KOnlyHadNavBarViewHeight - y );
    //    self.segementControl.tintColor = kNavColor;
    [self cliclSegment:self.segementControl];
    [self addheadView];
}

- (void)addheadView{
    self.headView = [RankHeadView viewFromeNib];
    self.headView.frame = CGRectMake(0, 0, 100, 200);
    KWeakSelf;
    self.headView.headCallback = ^(RankRowItem *item) {
        UserInfoController *userInfo = [[UserInfoController alloc]init];
        userInfo.ID = [item ID];
        [ws presentNeedNavgation:NO presentendViewController:userInfo];
    };
    self.tableView.tableHeaderView = self.headView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/**（总榜all/月榜month/周榜week/日榜day）*/
- (IBAction)cliclSegment:(UISegmentedControl *)segment{
    NSString *order;//源代码type
    if (segment.selectedSegmentIndex ==0) {
        order = @"month";//0对应月
    }else if (segment.selectedSegmentIndex ==1){
        order = @"week";//1对应周
    }else if (segment.selectedSegmentIndex ==2){
        order = @"day";//2对应日
    }else{//智者榜没有总榜
        order = @"all";
    }
    // 这里的type类型要改nil。不过self.ID改不改好像没区别。
    RankListParam *rankListParam = [[RankListParam alloc] initWithId:self.ID type:@"wiserank" order:order];
    rankListParam.token = [Account shareInstance].token;// 提交服务器验证
    self.listModel.listParam = rankListParam;
    [self.tableView yzgStartRefreshing];
}

- (void)handleAfterRequestFaile{
    [super handleAfterRequestFaile];
    self.headView.dataArray = nil;
}

-(void)createDataSource{
    self.dataSource = [[RankDataSource alloc]init];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}
-(void)createModel{
    self.listModel = [[RankListModel alloc] initWithDelegate:self];
}

-(void)configForRequest{// 把这里改成智者榜排行，getSystemWiseRankingList
    //    RankRequest *rankRequest = [[RankRequest alloc]initWithRequestUrl:@"getUserContributionList" withRequestParam:nil];// 原代码：个人贡献榜接口
    RankRequest *rankRequest = [[RankRequest alloc]initWithRequestUrl:@"getSystemWiseRankingList" withRequestParam:nil];
    self.listModel.netRequest = rankRequest;
}

-(void)requestDidSuccess{
    YZGTableViewSectionItem *sectionItem = [self.dataSource.sectionItems objectAtIndex:0];
    NSMutableArray *dataArray = self.listModel.responseObject;
    if (dataArray.count <= 3) {
        self.headView.dataArray = dataArray;
        [sectionItem.rowItems removeAllObjects];
    }else{
        NSRange headRange = NSMakeRange(0, 3);
        NSArray *headArray = [dataArray subarrayWithRange:headRange];
        self.headView.dataArray = headArray;
        NSRange range = NSMakeRange(headArray.count, dataArray.count - headArray.count);
        NSArray *array = [dataArray subarrayWithRange:range];
        [sectionItem.rowItems addObjectsFromArray:array];
    }
}

-(void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    UserInfoController *userInfo = [[UserInfoController alloc]init];
    userInfo.ID = [item ID];
    [self presentNeedNavgation:NO presentendViewController:userInfo];
}
@end





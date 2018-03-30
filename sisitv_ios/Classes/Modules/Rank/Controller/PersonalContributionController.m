//
//  PersonalContributionController.m
//  xiuPai
//
//  Created by apple on 16/10/24.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "PersonalContributionController.h"
#import "UserInfoController.h"
#import "RankDataSource.h"
#import "RankListModel.h"
#import "RankHeadView.h"
@interface PersonalContributionController ()
@property (nonatomic , copy) NSString *ID;
@property (strong, nonatomic)  RankHeadView *headView;
@end

@implementation PersonalContributionController


-(instancetype)initWithID:(NSString *)ID{
    if (self = [super init]) {
        self.ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"贡献榜";
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight);
//    self.segementControl.tintColor = kNavColor;
//    [self cliclSegment:nil];
    
    [self requestHttpWithType:@"month"];
    [self addheadView];
}


- (void)addheadView{
    self.headView = [RankHeadView viewFromeNib];
    self.headView.frame = CGRectMake(0, 0, 100, 245);
    KWeakSelf;
    self.headView.headCallback = ^(RankRowItem *item) {
        UserInfoController *userInfo = [[UserInfoController alloc]init];
        userInfo.ID = [item ID];
        [ws presentNeedNavgation:NO presentendViewController:userInfo];
    };
    self.tableView.tableHeaderView = self.headView;
    
    self.headView.switchRankType = ^(NSString *type) {
        [ws requestHttpWithType:type];
    };
}

- (void)requestHttpWithType:(NSString *)type{
    RankListParam *rankListParam = [[RankListParam alloc] initWithId:self.ID type:type order:nil];
    self.listModel.listParam = rankListParam;
    [self.tableView yzgStartRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


/**（总榜all/月榜month/周榜week/日榜day）*/
- (IBAction)cliclSegment:(UISegmentedControl *)segment{
    NSString *type;
    if (segment.selectedSegmentIndex ==0) {
//        type = @"all";
        type = @"month";
    }else if (segment.selectedSegmentIndex ==1){
        type = @"week";
    }else if (segment.selectedSegmentIndex ==2){
        type = @"day";
    }else{
    }
    type = @"month";
    RankListParam *rankListParam = [[RankListParam alloc] initWithId:self.ID type:type order:nil];
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

-(void)configForRequest{
    RankRequest *rankRequest = [[RankRequest alloc]initWithRequestUrl:@"getUserContributionList" withRequestParam:nil];
    self.listModel.netRequest = rankRequest;
}

-(void)requestDidSuccess{
    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
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

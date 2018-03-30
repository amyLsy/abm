//
//  WeekContributionController.m
//  sisitv
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "ContributionController.h"
#import "UserInfoController.h"
#import "RankDataSource.h"
#import "RankListModel.h"
#import "Account.h"
#import "RankHeadView.h"
#import "MJRefresh.h"
@interface ContributionController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segentHeight;
@property (strong, nonatomic)  RankHeadView *headView;

@end

@implementation ContributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat y = self.segentHeight.constant;
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight);

//    self.segementControl.tintColor = kNavColor;

    [self cliclSegment:self.segementControl];
    
     [self addheadView];
}

- (void)addheadView{
   
    
    self.headView = [RankHeadView viewFromeNib];
    KWeakSelf;
    self.headView.headCallback = ^(RankRowItem *item) {
      
        UserInfoController *userInfo = [[UserInfoController alloc]init];
        userInfo.ID = [item ID];
        [ws presentNeedNavgation:NO presentendViewController:userInfo];
        
    };
    self.headView.frame = CGRectMake(0, 0, 100, 200);
    
    self.tableView.tableHeaderView = self.headView;
    
}

/**（总榜all/月榜month/周榜week/日榜day）*/
- (IBAction)cliclSegment:(UISegmentedControl *)segment{
    NSString *order;
    if (segment.selectedSegmentIndex ==0) {
        order = @"all";
    }else if (segment.selectedSegmentIndex ==1){
        order = @"month";
    }else if (segment.selectedSegmentIndex ==2){
        order = @"week";
    }else{
        order = @"day";
    }
    RankListParam *rankListParam = [[RankListParam alloc] initWithId:nil type:@"contribution" order:order];
    self.listModel.listParam = rankListParam;
    [self.tableView yzgStartRefreshing];
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
    RankRequest *rankRequest = [[RankRequest alloc]initWithRequestUrl:@"getSystemRankingList" withRequestParam:nil];
    self.listModel.netRequest = rankRequest;
    self.headView.dataArray = nil;
}


- (void)handleAfterRequestFaile{
    [super handleAfterRequestFaile];
    
    self.headView.dataArray = nil;
    
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

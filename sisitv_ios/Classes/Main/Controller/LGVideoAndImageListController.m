//
//  LGVideoAndImageListController.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGVideoAndImageListController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "YZGCollectionView.h"
#import "LGMediaDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "MainListModel.h"
#import "LGVideoListCell.h"
#import "LGMediaListModel.h"
#import "LGMediaListRequest.h"
#import "MainNewDataSource.h"
#import "MainNewCollectionCell.h"
#import "LGPlaysController.h"
#import "LGTopRequest.h"
#import "LGTopCell.h"
#import "HttpTool.h"
#import "LGUploadTermsModel.h"
#import "LGButtont.h"
#import "YZGAppSetting.h"
#import "MJRefresh.h"

@interface LGVideoAndImageListController ()<LGTermsViewDelegate>{
    
    YZGCollectionSectionItem *_sectionItem;
    NSString * _term_id;
    BOOL _isBig;
    LGPlaysController *play;
    BOOL isShow;
    NSMutableArray *array;
}
@property (nonatomic,assign) NSInteger vcType;

@end

@implementation LGVideoAndImageListController

-(instancetype)initWithVcType:(NSInteger)vcType{
    
    if (self = [super init]) {
        
        _vcType = vcType;
    }
    
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    isShow = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    isShow = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView yzgTriggerRefreshing];
    _term_id = 0;
   [self loadTopic];
    
//    LGTopCell *topCell = (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
//    topCell.termsTypeView.delegate = self;
    
}



- (void)termsViewAtionWithType:(LGButtont *)actionType headView:(LGTermsTypeView *)termsView{
    
    LGUploadTermsModel *model = (LGUploadTermsModel *)actionType.object;
    _term_id = model.id;
    [self configForRequest];
    [self.listModel refreshData];
    [self.collectionView.mj_header beginRefreshing];
  
}




- (void)createDataSourceAndLayout{
    self.dataSource = [[MainNewDataSource alloc] initWithController:self];
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
    YZGCollectionSectionItem *sectionItem1 = [[YZGCollectionSectionItem alloc]init];
     YZGCollectionSectionItem *sectionItem2 = [[YZGCollectionSectionItem alloc]init];
    
    [self.dataSource.sectionItems addObject:sectionItem0];
    [self.dataSource.sectionItems addObject:sectionItem1];
    [self.dataSource.sectionItems addObject:sectionItem2];
    
    CGFloat margin = 1;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    self.cellClassName = @[@"LGVideoListCell",@"MainNewTopicCollectionCell",@"MainNewSepCollectionCell",@"LGTopCell"];
    NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
    LGTopCell *topCell =  (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
    topCell.termsTypeView.delegate = self;
    topCell.termsTypeView.hidden = YES;//lsy
}
-(void)createModel{
    self.listModel = [[LGMediaListModel alloc] initWithDelegate:self];
}
-(void)configForRequest{
    MainListParam *mainListParam = [[MainListParam alloc] init];
    mainListParam.type = [NSString stringWithFormat:@"%zd",self.vcType];
    mainListParam.sortby = 0;
    mainListParam.term_id = _term_id;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_views" withRequestParam:mainListParam];
    self.listModel.netRequest = mainListRequest;
}

-(void)handleAfterRequestFaile{
    [super handleAfterRequestFaile];
//    [self loadData];
}


-(void)requestDidSuccess{
    //lsy
    
    NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
    LGTopCell *topCell =  (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
    topCell.termsTypeView.delegate = self;
    topCell.termsTypeView.hidden = YES;//lsy
    [YZGAppSetting sharedInstance].isHot = NO;
   
//    YZGCollectionSectionItem *sectionItem0 = [self.dataSource.sectionItems objectAtIndex:0];
//    [sectionItem0.rowItems removeAllObjects];
//    [sectionItem0.rowItems addObject:array];
    _sectionItem = [self.dataSource.sectionItems objectAtIndex:2];
    [_sectionItem.rowItems addObjectsFromArray:self.listModel.responseObject];
    if (play) {
         play.videoListArray = _sectionItem.rowItems;
    }
    
    
//    [self loadData];
    
}

-(void)loadTopic{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(_vcType);
    YZGCollectionSectionItem *sectionItem0 = [self.dataSource.sectionItems objectAtIndex:0];
    YZGCollectionSectionItem *sectionItem1 = [self.dataSource.sectionItems objectAtIndex:1];
   
    NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
    LGTopCell *topCell =  (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
    topCell.termsTypeView.delegate = self;
    topCell.termsTypeView.hidden = YES;//lsy
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUploadTerms param:param success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
                LGUploadTermsModel *allModel = [[LGUploadTermsModel alloc] init];
                allModel.id = @"0";
                allModel.name = @"全部";
                array = [NSMutableArray array];
                [array addObject:allModel];
//                [array addObjectsFromArray:[LGUploadTermsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                [sectionItem0.rowItems removeAllObjects];
                [sectionItem0.rowItems addObject:array];
                [sectionItem1.rowItems addObject:@"this is sepView so that's need no data"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
//
//                    LGTopCell *topCell =  (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
//                    topCell.termsTypeView.delegate = self;
//                    topCell.termsTypeView.hidden = YES;//lsy
//                });
//            [self.collectionView reloadData];
        }
        
        
    } faile:^{
        
    }];
    
}

//-(void)loadData{
//    if (self.listModel.isRefresh){
//
//        _sectionItem = [self.dataSource.sectionItems objectAtIndex:2];
//        LGMediaListRequest *topicRequest = [[LGMediaListRequest alloc] init];
//        topicRequest.requestParam = @{@"type":@(self.vcType),@"token":[Account shareInstance].token,@"uid":_isMe == YES ? [Account shareInstance].ID:@""};
//        [topicRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
//
//            [_sectionItem.rowItems addObjectsFromArray:request.item];
//            [self.collectionView reloadData];
//        } failure:nil];
//
//    }
//
//
//}




- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    LGMediaListModel *model = (LGMediaListModel *)item;
    KWeakSelf;
    play = [[LGPlaysController alloc] init];
    play.model = model;
    play.viewType = self.vcType;
    play.videoListArray = _sectionItem.rowItems;
    play.indexPath = indexPath;
    play.setOffset = ^(NSInteger index) {
        if (isShow == YES) {
            
            return ;
        }
        CGFloat width = (KScreenWidth - 1)/2.0;
        CGFloat height = width/0.65 * index * 0.5;
        [ws.collectionView setContentOffset:CGPointMake(0, height) animated:YES];
    };
    play.loadData = ^(NSInteger index) {
       
        [ws.listModel pullUpToLoadMore];
        
    };
//    self.listModel
    [self.navigationController pushViewController:play animated:YES];
//    [self presentNeedNavgation:YES presentendViewController:play];
    
    [self addhits:model];
}

- (void)addhits:(LGMediaListModel *)model{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @(_vcType);
    param[@"item_id"] = model.id;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagAddhits param:param success:^(id responseObject) {
        
    } faile:^{
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



//
//  LGVideoAttentionController.m
//  sisitv_ios
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGVideoAttentionController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "YZGCollectionView.h"
#import "MainNewDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "MainListModel.h"
#import "TopicRequest.h"
#import "LGMediaListModel.h"
#import "LGPlaysController.h"
#import "HttpTool.h"
#import "YZGAppSetting.h"

@interface LGVideoAttentionController ()

@end

@implementation LGVideoAttentionController{
    
    YZGCollectionSectionItem *_sectionItem;
    NSString * _term_id;
    BOOL _isBig;
    LGPlaysController *play;
    BOOL isShow;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.collectionView.contentInset = UIEdgeInsetsMake(92, 0, 44, 0);
    
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
}

- (void)createDataSourceAndLayout{
    self.dataSource = [[MainNewDataSource alloc]init];
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
   [self.dataSource.sectionItems addObject:sectionItem0];
    CGFloat margin = 1.0;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    self.cellClassName = @[@"LGVideoListCell",@"MainNewTopicCollectionCell",@"MainNewSepCollectionCell",@"LGTopCell"];
    
}
-(void)createModel{
    self.listModel = [[LGMediaListModel alloc] initWithDelegate:self];
}

-(void)configForRequest{
    
    MainListParam *mainListParam = [[MainListParam alloc] init];
    //1为视频，2为图片
    mainListParam.type = _parameter;
    mainListParam.sortby = @"1";
    mainListParam.token = [Account shareInstance].token;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_views" withRequestParam:mainListParam];
    self.listModel.netRequest = mainListRequest;
}

-(void)handleAfterRequestFaile{
    [super handleAfterRequestFaile];
  
}

-(void)requestDidSuccess{
    [YZGAppSetting sharedInstance].isHot = NO;
    YZGCollectionSectionItem *sectionItem2 = [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem2.rowItems addObjectsFromArray:self.listModel.responseObject];
    _sectionItem = sectionItem2;
    
}

- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    LGMediaListModel *model = (LGMediaListModel *)item;
    KWeakSelf;
    play = [[LGPlaysController alloc] init];
    play.model = model;
    play.viewType = [self.parameter integerValue];
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

    UITabBarController *rootVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
     UINavigationController *selectVc = rootVc.selectedViewController;
    [selectVc pushViewController:play animated:YES];
    [self addhits:model];
}

- (void)addhits:(LGMediaListModel *)model{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [Account shareInstance].token;
    params[@"type"] = self.parameter;
    params[@"item_id"] = model.id;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagAddhits param:params success:^(id responseObject) {
        
    } faile:^{
        
    }];
    
    
}






@end

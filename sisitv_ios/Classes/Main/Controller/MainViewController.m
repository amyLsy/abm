//
//  MainViewController.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "MainHotController.h"
#import "MainAttentionController.h"
#import "MainNewController.h"
#import "RankController.h"
#import "SearchController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "UpdateView.h"
#import "MainTitleView.h"
#import "MainScrollView.h"
#import "AlertTool.h"
#import "LeanCloudTool.h"
#import "YZGAppSetting.h"
#import "Account.h"
#import "UpdateRequest.h"
#import "TopicRequest.h"
#import "PageTitleView.h"
#import "PageContentView.h"
#import "MainAreaController.h"
#import "LGVideoAndImageListController.h"
#import "LGImageListController.h"
#import "LGSelectGameView.h"

static CGFloat const kCollectionViewLeft = 55.0;
static CGFloat const kCollectionViewHeight = 44.0;

@interface MainViewController ()<PageTitleViewDelegate, PageContentViewDelegate>

@property (nonatomic , strong) MainScrollView *scrollView;
@property (nonatomic , strong) MainTitleView *titleView;
@property (nonatomic , strong) PageContentView *pageContentView;
@property (nonatomic , strong) PageTitleView *pageTitleView;
@property (nonatomic , copy) NSMutableArray *topicRowItemArray;
@property (nonatomic , copy) NSMutableArray *childVcs;

@property (nonatomic , copy) NSMutableArray *topics;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self loadInfo];
    
    //获取到首页的头视图数据
    TopicRequest *requset = [[TopicRequest alloc]init];
    requset.requestParam = @{@"term_id":@"10000"};
    [requset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        
        //topicRowItemArray titleView 的参数
        
//        for (TopicRowItem *item in requset.item) {
//            [self.topicRowItemArray addObject:item];
//            [self.topics addObject:item];
//        }
        
        /*
        //修改了self.topicRowItemArray self.topics的参数
        //魏友臣 17/5/12
        for(int i =0;i<3;i++)
        {
            [self.topicRowItemArray addObject:requset.item[i]];
            [self.topics addObject:requset.item[i]];
        }
      
         */
        
        [self.navigationController.navigationBar addSubview:self.titleView];
    
        [self.titleView addSubview:self.pageTitleView];
        [self.pageTitleView setTitleWithIndex:0];
    
        [self addChildController];
        
        [self.view addSubview:self.pageContentView];
        [self.pageContentView setCurrentIndex:0];
    
    } failure:nil];
    
   
    
}

-(void)pageContentViewWithContentView:(PageContentView *)contentView index:(NSInteger)index{
    
    [self.pageTitleView setTitleWithIndex:index];
}

//点击
- (void)pageTitleViewWithTitleView:(PageTitleView *)PageTitleView selectedIndex:(NSInteger)index{
    
    [self.pageContentView setCurrentIndex:index];
}

-(void)loadInfo{
    [[LeanCloudTool leanCloudTool] openLeanCloudWithcallback:nil];
    [self excuteRemoteNotiInfo];
    [self update];
    [[YZGAppSetting sharedInstance] getGiftListArray];
}

-(void)addChildController{
//    MainAttentionController *attention = [[MainAttentionController alloc]init];
//    [self.childVcs addObject:attention];
    MainHotController *hot = [[MainHotController alloc]init];
    [self.childVcs addObject:hot];
    LGVideoAndImageListController *listVc1 = [[LGVideoAndImageListController alloc] initWithVcType:1];
    [self.childVcs addObject:listVc1];
    MainAreaController *new2 = [[MainAreaController alloc]init];
    [self.childVcs addObject:new2];
    LGVideoAndImageListController *listVc2 = [[LGVideoAndImageListController alloc] initWithVcType:2];
    [self.childVcs addObject:listVc2];
//    MainNewController *new = [[MainNewController alloc]init];
//    [self.childVcs addObject:new];
    
    

    
//    for (int i = 0; i < self.topics.count; i ++) {
//        TopicRowItem *item = self.topics[i];
//        MainNewController *new1 = [[MainNewController alloc]init];
//        new1.term_id = item.term_id;
//        [self.childVcs addObject:new1];
//    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.titleView.hidden = YES;
}

- (NSMutableArray *)topicRowItemArray{
    if (!_topicRowItemArray) {
        _topicRowItemArray = [[NSMutableArray alloc] init];
//        TopicRowItem *item1 = [[TopicRowItem alloc] init];
//        item1.name = @"关注";
//        [_topicRowItemArray addObject:item1];
        TopicRowItem *item2 = [[TopicRowItem alloc] init];
        item2.name = @"直播";
         [_topicRowItemArray addObject:item2];
        TopicRowItem *item5 = [[TopicRowItem alloc] init];
        [_topicRowItemArray addObject:item5];
        item5.name = @"视频";
        TopicRowItem *item4 = [[TopicRowItem alloc] init];
         [_topicRowItemArray addObject:item4];
        item4.name = @"同城";
        TopicRowItem *item6 = [[TopicRowItem alloc] init];
        item6.name = @"图片";
        [_topicRowItemArray addObject:item6];
//        TopicRowItem *item3 = [[TopicRowItem alloc] init];
//        item3.name = @"附近";
//        [_topicRowItemArray addObject:item3];
      
    }
    return _topicRowItemArray;
}

- (NSMutableArray *)childVcs{
    if (!_childVcs) {
        _childVcs = [NSMutableArray array];
    }
    return _childVcs;
}

- (NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (PageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [[PageTitleView alloc] initWithFrame:CGRectMake(kCollectionViewLeft, 0, KScreenWidth - 2*kCollectionViewLeft, kCollectionViewHeight) titles:self.topicRowItemArray];
        _pageTitleView.delegate = self;
    }
    return _pageTitleView;
}

- (PageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [[PageContentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KHadTabBarAndNavBarViewHeight) childVcs: self.childVcs parentViewController:self];
        _pageContentView.delegate = self;
    }
    return _pageContentView;
}

//检测是否有新版本
/*
 *
 */
-(void)update{
    UpdateRequest *updateRequest = [[UpdateRequest alloc] initWithRequestParam:@{@"ver_num":[YZGAppSetting sharedInstance].currentAppVersion}];
    [updateRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        UpdateView *updateView = [UpdateView updateView];
        [KKeyWindow addSubview:updateView];
        updateView.updateInfo = request.item;
    } failure:nil];
}
//处理推送消息
-(void)excuteRemoteNotiInfo{
    NSDictionary *launchOptions = [YZGAppSetting sharedInstance].remoteNotiUserInfo;
    if ([launchOptions[@"type"] isEqualToString:@"URL"]) {
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.url = [NSURL URLWithString:launchOptions[@"url"]];
        [self.navigationController pushViewController:web animated:YES];
    }else if([launchOptions[@"type"] isEqualToString:@"LIVE"]){
        PlayerViewController *movieViewController = [[PlayerViewController alloc] init];
        movieViewController.room_id = launchOptions[@"roomId"];
        [self presentNeedNavgation:NO presentendViewController:movieViewController];
    }
}


-(void)searchButtonClick
{
    SearchController *searchController = [[SearchController alloc]init];
    [self.navigationController pushViewController:searchController animated:YES];
}
-(void)rankButtonClick
{
    RankController *rankController = [[RankController alloc]init];
    [self.navigationController pushViewController:rankController animated:YES];
}


//首页的titleView参数
-(MainTitleView *)titleView{
    if (!_titleView) {
        _titleView = [MainTitleView titleViewFromXib];
        _titleView.frame = self.navigationController.navigationBar.bounds;
        [self.navigationController.navigationBar addSubview:self.titleView];
        KWeakSelf;
        self.titleView.currentButtonIndex =  ^(NSInteger index) {
            [ws.scrollView scrollToTableViewWithTag:index];
        };
        self.titleView.search =^(){
            [ws searchButtonClick];
        };
        self.titleView.rank = ^(){
            [ws rankButtonClick];
        };
    }
    return _titleView;
}


@end

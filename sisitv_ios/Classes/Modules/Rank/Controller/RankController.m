//
//  ContributionController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RankController.h"
#import "MainScrollView.h"
#import "RankTitleView.h"

#import "IncomeRankController.h"
#import "ContributionController.h"
#import "WiseRankController.h"
#import "RankHeadView.h"
#import "Account.h"

@interface RankController ()<UIScrollViewDelegate>

@property (nonatomic , strong) NSMutableArray *allContributionData;

@property (nonatomic , strong) NSMutableArray *weeklyContributionData;

@property (nonatomic , strong) RankTitleView *titleView;

@property (nonatomic , assign) BOOL isWeeklyData;

@property (nonatomic , strong) MainScrollView *scrollView;

@property (nonatomic , strong) RankHeadView *headView;

@end

@implementation RankController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleView];
    [self addMainScrollView];
    [self addChildController];
    [self.titleView selectedButtonWithIndex:0];
    
}



-(void)addMainScrollView
{
    self.scrollView = ({
        MainScrollView *scrollView = [[MainScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(3 *KScreenWidth, 0);// 增加3组页面的宽度？？？
        scrollView;
    });
}

-(void)addTitleView
{
    self.titleView = ({
        RankTitleView *titleView = [RankTitleView titleViewFromXib];
        self.navigationItem.titleView  = titleView;
        KWeakSelf;
        titleView.currentButtonIndex=^(NSInteger index) {
            [ws.scrollView scrollToTableViewWithTag:index];
        };
        titleView;
    });
   
}

-(void)addChildController{// 增加子类控制器？左右滑动、下滑框内显示
    IncomeRankController *income = [[IncomeRankController alloc]init];// 收益榜
    income.type = @"benefit";
     [self addChildViewController:income];
    
    IncomeRankController *contribution = [[IncomeRankController alloc]init];
//    ContributionController *contribution = [[ContributionController alloc]init];// 打赏榜
    contribution.type = @"contribution";
     [self addChildViewController:contribution];
    
    IncomeRankController *wiserank = [[IncomeRankController alloc]init];
//    WiseRankController *wiskrank = [[WiseRankController alloc]init];//新增独立智者榜
    
    wiserank.type = @"wiserank";
     [self addChildViewController:wiserank];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    UIViewController *willShowVc = self.childViewControllers[index];
    //选中相应标题按钮
    [self.titleView selectedButtonWithIndex:index];
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end

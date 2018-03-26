//
//  ChatAlertMusicController.m
//  xiuPai
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatMusicController.h"
#import "ChatSearchMusicController.h"
#import "ChatDownLoadedMusicController.h"

#import "MainScrollView.h"
#import "ChatMusicTitleView.h"

@interface ChatMusicController ()<UIScrollViewDelegate>

@property (nonatomic , strong) ChatMusicTitleView *titleView;
@property (nonatomic , strong) MainScrollView *scrollView;

@end

@implementation ChatMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    [self addMainScrollView];
    [self addChildController];
    [self addTitleView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleView selectedButtonWithIndex:0];
}

-(void)addMainScrollView
{
    MainScrollView *scrollView = [[MainScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(2 *KScreenWidth, 0);
    self.scrollView = scrollView;
}
-(void)addTitleView
{
    self.titleView = ({
        ChatMusicTitleView *titleView = [ChatMusicTitleView titleViewFromXib];
        self.navigationItem.titleView  = titleView;
        KWeakSelf;
        titleView.currentButtonIndex=^(NSInteger index) {
            [ws.scrollView scrollToTableViewWithTag:index];
        };
        titleView;
    });
}
-(void)addChildController{
    ChatDownLoadedMusicController *downLoaded = [[ChatDownLoadedMusicController alloc]init];
    KWeakSelf;
    downLoaded.playButtonClick =^(NSString *musicPath,NSArray *lyrics){
        ws.playMusicButtonClick(musicPath,lyrics);
        [ws removeChildController];
    };
    [self addChildViewController:downLoaded];
    downLoaded.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.scrollView addSubview:downLoaded.view];
    
    ChatSearchMusicController *search = [[ChatSearchMusicController alloc]init];
    search.playButtonClick =^(NSString *musicPath,NSArray *lyrics){
        ws.playMusicButtonClick(musicPath,lyrics);
        [ws removeChildController];
    };
    [self addChildViewController:search];
    search.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight);
    [self.scrollView addSubview:search.view];
}

-(void)removeChildController{
    for (UIViewController *childController in  self.childViewControllers){
        [childController willMoveToParentViewController:nil];
        [childController removeFromParentViewController];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    if (self.childViewControllers.count<=0) return;

    UIViewController *willShowVc = self.childViewControllers[index];
    //选中相应标题按钮
    [self.titleView selectedButtonWithIndex:index];
    if ([willShowVc isKindOfClass:[ChatDownLoadedMusicController class]]) {
        ChatDownLoadedMusicController *downLoaded = (ChatDownLoadedMusicController *)willShowVc;
        [downLoaded pullDownToRefresh];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end

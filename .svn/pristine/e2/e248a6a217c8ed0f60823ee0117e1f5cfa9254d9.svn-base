//
//  SisiConversationListController.m
//  cooluck
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 JLXX-YZG. All rights reserved.
//

#import "SisiConversationListController.h"
@interface SisiConversationListController ()

@end

@implementation SisiConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.needLeftBackButon) {
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
       
       
    }
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"bg_nav1"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"bg_nav1"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
   
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"bg_nav1"] forBarMetrics:UIBarMetricsDefault];
}

@end

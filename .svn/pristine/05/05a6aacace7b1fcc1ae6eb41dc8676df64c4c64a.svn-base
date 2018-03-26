//
//  SisiConversationViewController.m
//  sisitv
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "SisiConversationViewController.h"

@interface SisiConversationViewController ()

@end

@implementation SisiConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.needLeftBackButon) {
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

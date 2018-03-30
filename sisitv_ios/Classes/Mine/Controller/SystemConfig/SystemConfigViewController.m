//
//  SystemConfigViewController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SystemConfigViewController.h"
#import "ChangePasswordController.h"
#import "AboutSisiController.h"
#import "FeedBackViewController.h"
#import "Account.h"
#import "RootTool.h"
#import "LeanCloudTool.h"
@interface SystemConfigViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changePassword;
@property (weak, nonatomic) IBOutlet UILabel *currentVersion;
@property (weak, nonatomic) IBOutlet UIButton *exit;

@end

@implementation SystemConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.currentVersion.text = [NSString stringWithFormat:@"当前版本 : v%@",version];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)ablouSisiLive:(UIButton *)sender
{
    [self.navigationController pushViewController:[[AboutSisiController alloc]init] animated:YES];
}
- (IBAction)feedBack:(UIButton *)sender
{
    [self.navigationController pushViewController:[[FeedBackViewController alloc]init] animated:YES];
}

- (IBAction)changePassword:(UIButton *)sender
{
    [self.navigationController pushViewController:[[ChangePasswordController alloc]init] animated:YES];
}
- (IBAction)quitAccount:(UIButton *)sender {
    [Account removeAccount];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[RootTool sharedInstance] chooseRootController];
}


@end

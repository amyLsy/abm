//
//  ChagerViewController.m
//  sisitv_ios
//
//  Created by weiyouchen on 2017/6/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChagerViewController.h"
#import "Account.h"
#import <WebKit/WebKit.h>
@interface ChagerViewController ()<WKNavigationDelegate>
{
    WKWebView *webView;
}
@end

@implementation ChagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.url];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //支付宝
    if ([url containsString:@"alipays://"]) {
        NSLog(@"dataStr=%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]] ;
    }
    
    //微信
    if ([url containsString:@"weixin://"]) {
        NSLog(@"dataStr=%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]] ;
    }
    
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    decisionHandler(actionPolicy);
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  BaseWebViewController.m
//  sisitv
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseWebViewController.h"
#import "AlertTool.h"
#import <WebKit/WebKit.h>
@interface BaseWebViewController ()<WKNavigationDelegate>

@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic , strong) UIProgressView *progressView;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KOnlyHadNavBarViewHeight)];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //    self.progress.progressTintColor = [UIColor colorWithHexString:@"B2DFEE"];
    
    //    [_webView loadHTMLString:@"<br /><br /><input type=\"file\" accept=\"image/*;capture=camera\">" baseURL:nil];
    self.progressView.progress = 0.1;
    
    // 定义返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    if (self.navigationController) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progressView.progress = [change[@"new"] floatValue];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
}
// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
    [AlertTool ShowInView:self.webView onlyWithTitle:@"网页加载失败" hiddenAfter:1.0];
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];;
}

-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 2)];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        self.progressView.transform = transform;//设定宽高
        [self.webView addSubview:_progressView];
    }
    return _progressView;
}


@end

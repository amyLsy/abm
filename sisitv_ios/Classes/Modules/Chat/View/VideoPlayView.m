//
//  VideoPlayView.m
//  sisitv_ios
//
//  Created by 廖健 on 2017/11/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "VideoPlayView.h"
#import <Photos/Photos.h>
#import <WebKit/WebKit.h>

@interface VideoPlayView ()

@property (strong, nonatomic)NSURL *url;
@property (strong, nonatomic)AVPlayer *player;
@property (strong, nonatomic)WKWebView *webView;

@end

@implementation VideoPlayView

- (instancetype)initWithFrame:(CGRect)frame andURL:(NSURL *)url
{
    if (self = [super initWithFrame:frame]) {
        
        _url = url;
        [self videoPlayInitWithFrame:frame];
        
    }
    return self;
}

- (void)videoPlayInitWithFrame:(CGRect)frame
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.allowsInlineMediaPlayback=true;
    //不全屏播放
    
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    //4.加载Request
    [_webView loadRequest:request];

    [self addSubview:_webView];
    
}

- (void)dealloc
{
    _webView = nil;
    _player  = nil;
}

@end

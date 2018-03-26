//
//  RootTool.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootTool.h"
#import "ADController.h"
#import "LoginController.h"
#import "NewFeatureController.h"
#import "Account.h"
#import "ADRequest.h"
#import "YZGAppSetting.h"

@interface RootTool ()

@property (nonatomic , copy) void(^disappearHandler)(void);

@end

@implementation RootTool

-(void)showAdvertWithTimeInterval:(NSTimeInterval)ti disappearHandler:(void(^)(void))disappearHandler {
    ADItem *adItem = [self loadCacheADItem];
    self.disappearHandler = disappearHandler;
    KWeakSelf;
    if (adItem) {
        ADController *adController = [[ADController alloc] initWithTimeInterval:ti disappearHandler:^{
            [ws checkIsNewVersion];
        }];
        adController.adItem = adItem;
        ws.rootWindow.rootViewController = adController;
    }else{
        [ws checkIsNewVersion];
    }
    [self requsetNextAdImage];
}

/**
 是否是打开的新版本,是的话,展示欢迎界面
 */
-(void)checkIsNewVersion{
    // 新版本显示轮播图
    if ([[YZGAppSetting sharedInstance] checkIsNewVersion]) {
        KWeakSelf;
        NewFeatureController *newFeature = [[NewFeatureController alloc] initWithDisappearHandler:^{
            [ws changeVisibleWindow];
        }];
        self.rootWindow.rootViewController = newFeature;
    }
    else
    {
        [self changeVisibleWindow];
    }
}

-(void)chooseRootController{
    KWeakSelf;
    if (![Account shareInstance].token)
    {
        [self.delegate rootToolExitSuccess:ws];
        
        LoginController *login = [[LoginController alloc] initWithSuccessLogin:^{
            [ws.delegate rootToolLoginSuccess:ws];
        }];
        self.rootWindow.rootViewController = login;
    }else{
        [self.delegate rootToolLoginSuccess:ws];
    }
}

-(void)changeVisibleWindow
{
    self.disappearHandler();
}

-(ADItem *)loadCacheADItem{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromDiskCacheForKey:@"yzgCacheAdImage"];
    if (image) {
        ADItem *adItem = [[ADItem alloc] init];
        adItem.adImage = image;
        adItem.url = [[NSUserDefaults standardUserDefaults] objectForKey:@"yzgCacheAdUrl"];
        adItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"yzgCacheAdTitle"];
        return adItem;
    }
    return nil;
}

// 加载网络广告图
-(void)requsetNextAdImage
{
//    ADRequest *adRequest = [[ADRequest alloc]init];
//    [adRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
//        [self cacheAdItem:request.item];
//    } failure:nil];
}

-(void)cacheAdItem:(ADItem *)adItem
{
    SDWebImageDownloader *download = [SDWebImageDownloader sharedDownloader];
    NSURL *url = [NSURL URLWithString:adItem.info];
    [download downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:@"yzgCacheAdImage"];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:adItem.url forKey:@"yzgCacheAdUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:adItem.title forKey:@"yzgCacheAdTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UIWindow *)rootWindow{
    if (!_rootWindow) {
        _rootWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _rootWindow.windowLevel = UIWindowLevelNormal + 10.0;
        [_rootWindow makeKeyAndVisible];
    }
    return _rootWindow;
}

@end



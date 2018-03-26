//
//  AppDelegate.m
//  liveFrame
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "Account.h"
#import "YZGPay.h"
#import "LeanCloudTool.h"
#import "BaseTabBarController.h"
#import "YZGAppSetting.h"
#import "RootTool.h"
#import "YZGShare.h"
#import "SPUncaughtExceptionHandler.h"


//------------推送相关------
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>



@interface AppDelegate ()<RootToolDelegate,JPUSHRegisterDelegate>

@property (nonatomic , strong) BaseTabBarController *tabBarController;

@end

@implementation AppDelegate


#pragma mark - 极光推送
- (void)creatJPush
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self creatWindow];
    
    [self regeistLeanCould];

    [self regeistShare];
    
    [[RootTool sharedInstance] showAdvertWithTimeInterval:1.0 disappearHandler:^{
        [self getAccountInfo];
    }];
    //ios 10以前,从推送消息打开app 走这里给remoteNotiUserInfo赋值,当然iOS 10也会走这里
    //ios 10以后,从推送消息打开app 会走YZGAppSetting的UNCenterDelegate代理方法中给remoteNotiUserInfo赋值
    
    if (launchOptions) {
        NSDictionary *remoteNotiUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [YZGAppSetting sharedInstance].remoteNotiUserInfo = remoteNotiUserInfo;
    }
    
    //推送相关
    [self regeistNotification];
    ///异常捕获
//    InstallUncaughtExceptionHandler();
//    [self redirectNSlogToDocumentFolder];
    return YES;
}


- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}


-(void)creatWindow{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self deafaultController];
}

-(UIViewController *)deafaultController{
    UIViewController *rootController = [[UIViewController alloc]init];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ad"]];
    [rootController.view addSubview:imageView];
    imageView.frame = rootController.view.bounds;
    return rootController;
}

-(void)getAccountInfo{
    //是否开启了推广活动
    [[YZGAppSetting sharedInstance] appisPromotion:^(BOOL isPromotion) {
        [YZGAppSetting sharedInstance].isPromotion = isPromotion;
    }];
    
    
    [[Account isLogined] getAccountInfoSuccess:^{
        [self guideInfo];
        [self successGetAccountInfo];
    } faile:^{
        [self chooseRootController];
    }];
}


- (void)guideInfo{
    
//    if ([Account shareInstance].firstRegister == YES) {
//        
//    }
    
    
}

-(void)successGetAccountInfo{
    if (![YZGAppSetting sharedInstance].isInAppleStore) {
        [[YZGAppSetting sharedInstance] checkIsInAppleStore:nil];
    };
    [self chooseRootController];
}

-(void)rootToolLoginSuccess:(RootTool *)rootTool{
    rootTool.rootWindow = nil;
    if (_tabBarController) {
        _tabBarController = nil;
    }
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    self.tabBarController.selectedIndex = 0;
}

-(void)rootToolExitSuccess:(RootTool *)rootTool{
    //还没想好怎么写
    [YZGAppSetting sharedInstance].remoteNotiUserInfo = nil;
    [[LeanCloudTool leanCloudTool] closeWithCallback:nil];
}



-(void)regeistLeanCould{
    [[LeanCloudTool leanCloudTool] regeistLeanCould];
}
//注册sharesdk
-(void)regeistShare
{
    [YZGShare registerShare];
}
//注册Notification
-(void)regeistNotification
{
    [[YZGAppSetting sharedInstance] registerForRemoteNotification];
}

-(void)chooseRootController{
   RootTool *rootTool = [RootTool sharedInstance];
    rootTool.delegate = self;
    [rootTool chooseRootController];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[LeanCloudTool leanCloudTool] regeistRemoteNotificationWithDeviceToken:deviceToken];
    NSLog(@"%@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"-=-=-%@",userInfo);
}

//openurl
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return  [[YZGPay shareInstance] handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [[YZGPay shareInstance] handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[YZGPay shareInstance] handleOpenURL:url];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    application.applicationIconBadgeNumber = 0 ;
}

-(BaseTabBarController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController = [[BaseTabBarController alloc]init];
    }
    return _tabBarController;
}

@end

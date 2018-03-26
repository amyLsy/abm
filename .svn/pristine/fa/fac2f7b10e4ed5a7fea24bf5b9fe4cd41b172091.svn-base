//
//  YZGAppSetting.m
//  xiuPai
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGAppSetting.h"
#import "Account.h"

#import "GiftListRequest.h"
#import "SetLocationRequest.h"


#import <UserNotifications/UserNotifications.h>


@interface LocationService: NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic , copy) NSString *currentCity;

@property (nonatomic ,strong) CLPlacemark *placemark;

@property(nonatomic) CLLocationDegrees latitude;

@property(nonatomic) CLLocationDegrees longitude;

@end

@implementation LocationService

-(instancetype)init{
    if (self = [super init]) {
        self.currentCity = @"火星";
    }
    return self;
}

-(void)startUpdateLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        YZGLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        YZGLog(@"无法获取位置信息");
    }
    [self mars];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    CLLocation *newLocation = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            self.currentCity = city;
            self.placemark = placemark;
            self.longitude =  newLocation.coordinate.longitude;
            self.latitude =  newLocation.coordinate.latitude;
            [[NSNotificationCenter defaultCenter]postNotificationName:kAppUpDateCurrentPosition object:nil];
        }else{
            [self mars];
        }
    }];
}

-(void)mars{
    self.currentCity = @"火星";
    self.longitude = 0.01;
    self.latitude = 0.01;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppUpDateCurrentPosition object:nil];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

@end



@interface YZGAppSetting ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic , weak) UIResponder *firstResponder;
@property (nonatomic , weak) UIView *firstResponderSuperView;
@property (nonatomic , weak) UIView *firstResponderControllerView;
@property (nonatomic , weak) UIView *needAutoUpSpringView;
@property (nonatomic , weak) UINavigationBar *firstResponderControllerNavBar;

@end

@implementation YZGAppSetting

-(instancetype)init{
    if (self = [super init]) {
        self.giftList = [NSMutableArray array];
    }
    return self;
}

-(NSString *)appApi{
    return AppApi;
}
-(NSString *)appUrl{
    return AppUrl;
}
-(NSString *)appName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

-(NSString *)currentAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}



-(NSString *)currentCity{
    return self.locationService.currentCity;
}

- (CLPlacemark *)placemark{
    
    return self.locationService.placemark;
}

- (CLLocationDegrees)longitude{
    
    return self.locationService.longitude;
    
}

- (CLLocationDegrees)latitude{
    
    return  self.locationService.latitude;
}


-(BOOL)checkIsNewVersion{
    //判断是不是新版本
    NSString *previousAppVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"previousAppVersion"];
    if ([previousAppVersion isEqualToString:self.currentAppVersion]) {
        return  NO;
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:self.currentAppVersion forKey:@"previousAppVersion"];
        return YES;
    }
}

-(BOOL)isInAppleStore{
    return [[NSUserDefaults standardUserDefaults] boolForKey:AppIsInAppleStore];
}

-(void)getGiftListArray{
    GiftListRequest *giftListRequest = [[GiftListRequest alloc] initWithRequestParam:@{@"limit_num":@"100"}];
    [giftListRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request){
        self.giftList = request.item;
    } failure:nil];
}


-(void)appisPromotion:(void(^)(BOOL isPromotion))success{
    
    //token：token 当前位置（中国-广东省-深圳市）：location   经度：longitude 纬度：latitude

    YZGRequest *request = [[YZGRequest alloc] initWithRequestParam:nil];
    request.requestUrl = @"getPromotion";
    request.requestMethod = YZGRequestMethodGET;
    [request startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        
        if ([request.responseObject[@"data"] boolValue] == YES) {
            success(YES);
        }else{
             success(NO);
            
        }
        
    } failure:nil];
    
}

-(void)checkIsInAppleStore:(void (^)(BOOL))success{
    NSString * check = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",AppleIdInItunes];
    NSURL *requestURL = [NSURL URLWithString:check];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *appStoreVersion = nil;
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            appStoreVersion = [[dic[@"results"] firstObject] objectForKey:@"version"];
            if (![appStoreVersion isKindOfClass:[NSString class]]) {
                appStoreVersion = @"0";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processAppStoreVersion:appStoreVersion success:success];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processAppStoreVersion:@"0" success:success];
            });
            NSLog(@"didCompleteWithError:%@",[error localizedDescription]);
        }
    }];
    [task resume];
}
-(void)processAppStoreVersion:(NSString *)appStoreVersion success:(void(^)(BOOL isInAppStore))success{
    NSString *appStore = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *audit= [self.currentAppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (audit.floatValue > appStore.floatValue) {
        self.isInAppleStore = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AppIsInAppleStore];
    }else{
        self.isInAppleStore = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AppIsInAppleStore];
    }
    if (success) {
        success(self.isInAppleStore);
    }
}

-(void)getCurrentLocation{
    if (!self.locationService) {
        self.locationService = [[LocationService alloc]init];
    }
    [self.locationService startUpdateLocation];
}

-(void)updateCurrentLocationToServer:(void (^)(BOOL, NSString *))success{

    //token：token 当前位置（中国-广东省-深圳市）：location   经度：longitude 纬度：latitude
    NSString *country = self.placemark.country;
    NSString *administrativeArea = self.placemark.administrativeArea;
    NSString *city = self.currentCity;
    NSString *location = [NSString stringWithFormat:@"%@-%@-%@",country,administrativeArea,city];
    NSDictionary *param=@{@"token":[Account shareInstance].token,
                          @"location":location,
                          @"longitude":@(self.locationService.longitude),
                          @"latitude":@(self.locationService.latitude),
                          };
    SetLocationRequest *setLocationRequest = [[SetLocationRequest alloc] initWithRequestParam:param];
    [setLocationRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        YZGLog(@"当前位置：%@",request.responseObject);
        if (success) {
             success(YES,location);
        }
       
    } failure:nil];
}

-(void)setIsAutoUpSpring:(BOOL)isAutoUpSpring{
    _isAutoUpSpring = isAutoUpSpring;
    if (_isAutoUpSpring) {
        //添加键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldHidden:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        self.firstResponder = nil;
        self.firstResponderSuperView = nil;
        self.firstResponderControllerView = nil;
        self.needAutoUpSpringView = nil;
        self.firstResponderControllerNavBar = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void)textFieldShow:(NSNotification *)noti
{
    [self searchFirstResponder];
    CGRect end = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration =  [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat move =  end.origin.y - CGRectGetMaxY(self.needAutoUpSpringView.frame) ;
    BOOL contains = CGRectIntersectsRect(end,self.needAutoUpSpringView.frame);
    if (contains) {
        [self changePositionWithHeight:move withDuration:duration];
    }
}

-(void)textFieldHidden:(NSNotification *)noti
{
    CGFloat duration =  [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.firstResponderControllerNavBar) {
        [self changePositionWithHeight:64 withDuration:duration];
    }else{
        [self changePositionWithHeight:0 withDuration:duration];
    }
}

-(void)changePositionWithHeight:(CGFloat)height withDuration:(CGFloat)duration{
    if (self.isAutoUpSpring) {
        [UIView animateWithDuration:duration animations:^{
            self.firstResponderControllerView.y = height;
        }];
    }
}

-(void)searchFirstResponder{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    _firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    self.firstResponderSuperView = (UIView *)_firstResponder.nextResponder;
    id firstResponder = _firstResponder;
    while (![firstResponder isKindOfClass: [UIViewController class]] && ![firstResponder isKindOfClass: [UIWindow class]])
    {
        firstResponder = [firstResponder nextResponder];
    }
    if ([firstResponder isKindOfClass: [UIViewController class]])
    {
        UIViewController *viewController = (UIViewController *)firstResponder;
        self.firstResponderControllerNavBar = viewController.navigationController.navigationBar;
        self.firstResponderControllerView = viewController.view;
    }
    if (self.firstResponderControllerView == self.firstResponderSuperView) {
        self.needAutoUpSpringView = (UIView *)self.firstResponder;
    }else{
        self.needAutoUpSpringView = self.firstResponderSuperView;
    }
}

#pragma mark - 远程推送通知
-(void)registerForRemoteNotification{
    // iOS10 兼容
    if (kYZGiOS10OrLater) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件
        [uncenter setDelegate:self];
        //iOS10 使用以下方法注册，才能得到授权
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    });
                                    //TODO:授权状态改变
                                    NSLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                }];
        //         获取当前的通知授权状态, UNNotificationSettings
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            /*
             UNAuthorizationStatusNotDetermined : 没有做出选择
             UNAuthorizationStatusDenied : 用户未授权
             UNAuthorizationStatusAuthorized ：用户已授权
             */
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"-----未选择");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"-----未授权");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"-----已授权");
            }
        }];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}


// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 点击通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
    }else {
        // 判断为本地通知 此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:点击通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
     // 系统要求执行这个方法,不执行会报下边的warning
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();
    //ios 10以后,从推送消息打开app 会走这里
    self.remoteNotiUserInfo = userInfo;
}


// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
//应用只在前台时收到推送消息才会走这个方法,在后台或者没有启动,推送消息都会走上边的方法.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}
@end


//
//  YZGAppSetting.h
//  xiuPai
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGSingleton.h"
#import "YZGAppSettingUtilits.h"
#import <CoreLocation/CoreLocation.h>

@interface YZGAppSetting : YZGSingleton
/**
 app的url
 */
@property (nonatomic , copy) NSString *appUrl;
/**
 app的api
 */
@property (nonatomic , copy) NSString *appApi;
/**
 是否成功上架
 */
@property (nonatomic , assign) BOOL isInAppleStore;
/**
 app名称
 */
@property (nonatomic , copy) NSString *appName;
/**
 app版本
 */
@property (nonatomic , copy) NSString *currentAppVersion;
/**
 当前所在城市名称
 */
@property (nonatomic , copy) NSString *currentCity;

@property (nonatomic , assign) CGFloat hotCellWidth;
/**
 礼物信息
 */
@property (nonatomic , strong) NSMutableArray *giftList;
/**
 是否在textFiled出现后,自动弹起当前控制器的view
 */
@property (nonatomic , assign) BOOL isAutoUpSpring;
//
@property(nonatomic) CLLocationDegrees latitude;

@property(nonatomic) CLLocationDegrees longitude;

@property (nonatomic ,strong) CLPlacemark *placemark;



//是否开启开启推广活动
@property (nonatomic , assign) BOOL isPromotion;
@property (nonatomic, strong)NSMutableArray *userAttArray;
@property (nonatomic , assign) BOOL isBig;
@property (nonatomic , assign) BOOL isHot;

/**
 是点击了远程推送消息,从而启动的app,才会有值
 */
@property (nonatomic , strong) NSDictionary *remoteNotiUserInfo;

-(BOOL)checkIsNewVersion;

-(void)checkIsInAppleStore:(void(^)(BOOL isInAppStore))success;

-(void)appisPromotion:(void(^)(BOOL isPromotion))success;

-(void)getCurrentLocation;

-(void)getGiftListArray;

-(void)updateCurrentLocationToServer:(void(^)(BOOL isSuccess,NSString *location))success;

-(void)registerForRemoteNotification;

@end

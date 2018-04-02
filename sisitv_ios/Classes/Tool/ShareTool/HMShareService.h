//
//  HMShareService.h
//  HiloApp
//
//  Created by lushuyuan on 2017/9/28.
//  Copyright © 2017年 Happy Time Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

typedef NS_ENUM(NSUInteger, WX_SHARE_TYPE) {
    WX_SHARE_SESSION_TYPE = 0,//单个对话
    WX_SHARE_TIMELINE_TYPE,//朋友圈
    WX_SHARE_FAVORITE_TYPE,
};

typedef NS_ENUM(NSUInteger, QQ_SHARE_TYPE) {
    QQ_SHARE_FRIENDS_TYPE = 0,
    QQ_SHARE_KONGJIAN_TYPE,
};


@interface HMShareService : NSObject<QQApiInterfaceDelegate>
+(instancetype)shareInstance;


/**
 微信分享图片

 @param shareType 分享到朋友圈或对话
 @param image 图片
 @return YES or NO
 */
-(BOOL)shareToWXType:(WX_SHARE_TYPE)shareType image:(UIImage *)image;

/**
 微信分享

 @param shareType 分享类型
 @return YES or NO
 */
-(BOOL)shareToWXType:(WX_SHARE_TYPE)shareType headUrl:(NSString *)headUrl;


/**
 QQ分享一张图片

 @param shareType 分享到朋友圈或对话
 @param image 图片
 @return YES or NO
 */
-(BOOL)shareToQQType:(QQ_SHARE_TYPE)shareType image:(UIImage *)image;
/**
 QQ分享

 @param shareType 分享类型：好友、空间
 @return YES or NO
 */
-(BOOL)shareToQQType:(QQ_SHARE_TYPE)shareType headUrl:(NSString *)headUrl;


/**
 新浪微博分享

 @return YES or NO
 */
-(BOOL)shareToWBWithHeadUrl:(NSString *)headUrl;
@end

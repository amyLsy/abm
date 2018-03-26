//
//  ShareTool.h
//  com.yxvzb.zhibozhushou
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGShareView.h"
#import "ShareParam.h"

@interface YZGShare : NSObject

/**  分享内容*/
@property (nonatomic , copy) NSString *content;

/** 分享的图片*/
@property (nonatomic , copy) NSString *pic ;

/** 要分享的地址*/
@property (nonatomic , copy) NSString *shareUrl ;

/*** 分享标题*/
@property (nonatomic , copy) NSString *title;



+(void)loginWithPlatformType:(NSInteger )platformType success:(void(^)(id response, BOOL successGetInfo))success;
/**
 * 第三方登录后,发送个人信息
 */
+(void)sendOauthUserInfoWithParam:(ShareParam *)param success:(void(^)(id response, BOOL successGetInfo))success;

/**
 * 获取分享信息
 */
+(void)getShareInfoWithParam:(ShareParam *)param success:(void(^)(id response, BOOL successGetInfo))success;

/**
 * 注册shareSDK
 */
+(void)registerShare;


+(YZGShareView *)yzgShareView;
/**
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容Content就行了
 */
+(void)shareViewButtonClick:(ShareButtonType)btnTag withShareContent:(YZGShare *)content success:(void(^)(BOOL isSuccess ,NSString *result))shareResult;
 
@end

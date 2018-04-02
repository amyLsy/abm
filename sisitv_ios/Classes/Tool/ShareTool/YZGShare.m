//
//  ShareTool.m
//  com.yxvzb.zhibozhushou
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGShare.h"
#import "YZGShareUtilits.h"
#import "Account.h"
#import "HttpTool.h"
#import "YZGAppSetting.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "HMShareService.h"

@implementation YZGShare

+(void)registerShare
{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:YZGShareWeChatAppId
                                      appSecret:YZGShareWeChatAppSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:YZGShareQQAppId
                                     appKey:YZGShareQQAppKey
                                   authType:SSDKAuthTypeBoth];
                break;
                
            default:
                break;
        }
    }];
}



//第三方登录按钮点击调用的事件
+(void)loginWithPlatformType:(NSInteger)platformType success:(void (^)(id,BOOL))success
{
    SSDKPlatformType platform;
    switch (platformType) {
        case 1:
            platform = SSDKPlatformTypeSinaWeibo;
            break;
        case 2:
            platform = SSDKPlatformTypeWechat;
            break;
        case 3:
            platform = SSDKPlatformTypeQQ;
            break;
        default:
            break;
    }
    
    [ShareSDK getUserInfo:platform onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        YZGLog(@"%@--------%@",user.rawData,error);
        if (state == SSDKResponseStateSuccess)
        {
            NSDictionary * param = [self getParamWithSDKUser:user withPlatForm:platform];
            ShareParam *shareParam;
            if ([param isKindOfClass:[NSDictionary class]]) {
                shareParam = [ShareParam mj_objectWithKeyValues:param];
                success(shareParam,YES);
            }else{
                success(@"用户信息获取失败",NO);
            }
        }else if(state ==SSDKResponseStateCancel) {
            success(@"用户取消第三方登录",NO);
        }else if(state ==SSDKResponseStateFail) {
            success(@"第三方登录失败",NO);
        }
    }];
}

+(NSDictionary *)getParamWithSDKUser:(SSDKUser *)user withPlatForm:(SSDKPlatformType )platform
{
    NSString *expires_date  = @"111";
    NSString *access_token = @"111";
    NSString *name = @"111";
    NSString *headImageUrl =@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png";
    NSString *openid = @"111";
    NSString *sex = @"1";
    NSString *from = @"Wechat";
    
    if (![user.credential.rawData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *param = @{@"from":from,@"name":name,
                                @"access_token":access_token,
                                @"expires_date":expires_date,
                                @"head_img":headImageUrl,
                                @"sex":sex,@"openid":openid,
                                };
        return param;
    }
    if (user.credential.rawData[@"expires_in"]) {
       expires_date = user.credential.rawData[@"expires_in"];
    }
    if (user.credential.rawData[@"access_token"]) {
        access_token = user.credential.rawData[@"access_token"];
    }

    if (user.gender == 1) {
        sex = @"女";
    }else{
        sex = @"男";
    }
    if (platform ==SSDKPlatformTypeWechat) {
        if (user.gender == 0) {
            sex = @"1";
        }else{
            sex = @"2";
        }
        if (user.nickname) {
            name = user.nickname;
        }
        if (user.rawData[@"headimgurl"]) {
            headImageUrl = user.rawData[@"headimgurl"];
        }
        if (user.rawData[@"openid"]) {
            openid = user.rawData[@"openid"];
        }
        from = @"Wechat";
    }else if(platform ==SSDKPlatformTypeQQ){
        if (user.gender == 0) {
            sex = @"1";
        }else{
            sex = @"2";
        }
        if (user.nickname) {
            name = user.nickname;
        }
        if (user.rawData[@"figureurl_qq_1"]) {
            headImageUrl = user.rawData[@"figureurl_qq_1"];
        }
        if (user.credential.rawData[@"openid"]) {
            openid = user.credential.rawData[@"openid"];
        }
        from = @"QQ";
        for (NSString *key in user.rawData) {
            if ([key isEqualToString:@"figureurl_qq_2"]) {
                if (user.rawData[@"figureurl_qq_2"]) {
                    headImageUrl = user.rawData[@"figureurl_qq_2"];
                }
                break;
            }
        }
    }else{
        if (user.rawData[@"gender"]) {
            if ([user.rawData[@"gender"] isEqualToString:@"m"]) {
                sex = @"1";
            }else{
                sex = @"2";
            }
        }
        if (user.rawData[@"screen_name"]) {
            name = user.rawData[@"screen_name"];
        }
        if (user.rawData[@"avatar_large"]) {
            headImageUrl = user.rawData[@"avatar_large"];
        }
        if (user.rawData[@"id"]) {
            openid = user.rawData[@"id"];
        }
        from = @"SinaWeibo";
    }
    NSDictionary *param = @{@"from":from,
                            @"name":name,
                            @"access_token":access_token,
                            @"expires_date":expires_date,
                            @"openid":openid,
                            @"head_img":headImageUrl,
                            @"sex":sex
                            };
    YZGLog(@"%@-=-=-=-",param);
    return param;
}

//向服务器发送获取到的第三方用户信息,用以注册账号
+(void)sendOauthUserInfoWithParam:(ShareParam *)param success:(void (^)(id, BOOL))success{
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagSendOauthUserInfo param:param.mj_keyValues success:^(id responseObject) {
        id result = nil;
        BOOL successGetInfo = NO;
        if ([responseObject[@"code"] isEqual:@200]) {
            Account *account = [Account mj_objectWithKeyValues:responseObject[@"data"]];
            account.token = responseObject[@"token"];
            [Account  storeAccount];
            successGetInfo= YES;
        }else{
            result = responseObject[@"descrp"];
        }
        if (success) {
            success(result,successGetInfo);
        }
    } faile:nil];
}

//获取分享信息
+(void)getShareInfoWithParam:(ShareParam *)param success:(void(^)(id response, BOOL successGetInfo))success{
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetShareInfo param:param.mj_keyValues success:^(id responseObject) {
        
        id obj = nil;
        BOOL result = NO;
        if ([responseObject[@"code"] isEqual:@200]) {
            YZGShare *yzgShare = [YZGShare mj_objectWithKeyValues: responseObject[@"data"]];
            obj = yzgShare;
            result = YES;
        }else{
            obj = responseObject[@"descrp"];
        }
        if (success) {
            success(obj,result);
        }
    } faile:nil];
}

//分享界面
+(YZGShareView *)yzgShareView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YZGShareView *shareView = [YZGShareView yzgShareView];
    shareView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);    
    [keyWindow addSubview:shareView];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.alpha = 1.0;
    }];
    return shareView;
}

+(void)shareViewButtonClick:(ShareButtonType)btnTag withShareContent:(YZGShare *)content success:(void (^)(BOOL, NSString *))shareResult{
    
    [[HMShareService shareInstance] shareToWXType:WX_SHARE_SESSION_TYPE headUrl:content.shareUrl];
    
    return;
    int shareType = 0;
    switch (btnTag) {
        case ShareButtonTypeWeChatSession:
        {
            shareType = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case ShareButtonTypeWechatTimeline:
        {
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
//        case ShareButtonTypeTypeSinaWeibo:
//        {
//            shareType = SSDKPlatformSubTypeQQFriend;
//        }
//            break;
        case ShareButtonTypeQQ:
        {
            shareType = SSDKPlatformSubTypeQZone;
        }
            break;
        case ShareButtonTypeQZone:
        {
            shareType = SSDKPlatformSubTypeQZone;
        }
            break;
    }
    /*
     调用shareSDK的无UI分享类型，
     链接地址：http://bbs.mob.com/forum.php?mod=viewthread&tid=110&extra=page%3D1%26filter%3Dtypeid%26typeid%3D34
     */
    [ShareSDK share:shareType parameters:[self shareParamsWithContent:content] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        BOOL isShareSuccess = NO;
        if (state == SSDKResponseStateSuccess)
        {
            NSLog(@"ok");
            isShareSuccess = YES;
        }else if (state == SSDKResponseStateCancel)
        {
            NSLog(@"Cancel");
        }else if (state == SSDKResponseStateFail)
        {
            NSDictionary *errMessage = [error userInfo];
            NSLog(@"%@",errMessage[@"error_message"]);
        }
        if (shareResult) {
            shareResult(isShareSuccess,[error localizedDescription]);
        }
    }];
}

+(NSMutableDictionary *)shareParamsWithContent:(YZGShare *)yzgShare {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    NSString *pic = yzgShare.pic;
    NSString *content = yzgShare.content;
    NSString *shareUrl = yzgShare.shareUrl;
    NSString *title = yzgShare.title;
    [shareParams SSDKSetupShareParamsByText:content images:pic url:[NSURL URLWithString:shareUrl] title:title type:SSDKContentTypeAuto];
    return shareParams;
}

@end

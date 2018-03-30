//
//  ThirdLoginService.m
//  sisitv_ios
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "ThirdLoginService.h"
#import <AFNetworking/AFNetworking.h>
#import "ShareParam.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>

static NSString *const WeChatAppId = @"wx48f78c84a33b7555";
static NSString *const WeChatAppSecret = @"394bf747c0e4f5d8d3e65b4dc66628c7";
static NSString *const QQAppId = @"1106808280";
static NSString *const QQAppKey = @"pGyn09PPeKZdDIQK";

@interface ThirdLoginService()<WXApiDelegate,TencentSessionDelegate,TencentLoginDelegate>
@property (nonatomic, copy) void(^GetUserParam)(BOOL success, ShareParam *param);
@property (nonatomic, strong) ShareParam *userParam;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@end

@implementation ThirdLoginService

static ThirdLoginService *loginService;
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginService = [[ThirdLoginService alloc] init];
    });
    return loginService;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [WXApi registerApp:WeChatAppId];
        _userParam = [[ShareParam alloc] init];
        _userParam.from = @"ios";
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:self];
        return self;
    }
    return nil;
}

#pragma mark - 微信登录

-(BOOL)wechatLogin:(void (^)(BOOL, ShareParam *))userParam{
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"zbmApp";
        req.scope = @"snsapi_userinfo";
        [WXApi sendReq:req];
        _GetUserParam = [userParam copy];
        return YES;
    }
    return NO;
}


-(void)wxGetTokenWithCode:(NSString *)code finishedBlock:(void (^)(NSDictionary *))finishedBlock{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAppId , WeChatAppSecret, code];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"微信登录----- %@",dic);
        _userParam.access_token = dic[@"access_token"];
        _userParam.expires_date = dic[@"expires_in"];
        if (finishedBlock) {
            finishedBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }];
}


-(void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"微信登录：---用户信息：%@",dic);
        //转为ShareParam；
        _userParam.from = @"ios";
        NSNumber *sexNum = dic[@"sex"];
        _userParam.sex = [sexNum intValue] == 2 ? @"女" : @"男";
        _userParam.head_img = dic[@"headimgurl"];
        _userParam.name = dic[@"nickname"];
        _userParam.openid = dic[@"openid"];
        if (_GetUserParam) {
            _GetUserParam(YES,_userParam);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_GetUserParam) {
            _GetUserParam(NO,nil);
        }
    }];
}

- (BOOL)wxHandleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:(id)self];
}

-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        switch (resp.errCode) {
            case 0:
            {
                SendAuthResp *rep = (SendAuthResp *)resp;
                [self wxGetTokenWithCode:rep.code finishedBlock:^(NSDictionary *resultDic) {
                    if (resultDic) {
                        [self getUserInfoWithAccessToken:resultDic[@"access_token"] andOpenId:resultDic[@"openid"]];
                    }else{
                        
                    }
                }];
            }
                break;
            case -4:
            {
                NSLog(@"用户拒绝授权");
                
                if (_GetUserParam) {
                    _GetUserParam(NO,nil);
                }
            }
                break;
            case -2:
            {
                NSLog(@"用户取消登录");
                
                if (_GetUserParam) {
                    _GetUserParam(NO,nil);
                }
            }
                break;
            default:
                break;
        }
        
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        
//        if (resp.errCode == 0) {
//            [UIView addAlertView:@"分享成功" tipsType:TipsTypeSucess];
//            [self performSelector:@selector(notifyRoomShareMsgs) withObject:nil afterDelay:1.0];
//        }else{
//            [UIView addAlertView:@"分享失败" tipsType:TipsTypeError];
//        }
    }
    
}


#pragma mark - QQ登录

- (void)qqlogin:(void(^)(BOOL success, ShareParam *reqParam))userParam{
    
    NSArray *permissArray = [NSMutableArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_INFO, nil];
    [_tencentOAuth authorize:permissArray inSafari:NO];
    _GetUserParam = [userParam copy];
}

-(BOOL)qqHandleLoginOpenURL:(NSURL *)url {
    
//    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    if (_tencentOAuth.accessToken) {
        BOOL result = [_tencentOAuth getUserInfo];
        NSLog(@"getUserInfo result :%d",result);
    }else{
        NSLog(@"accessToken 没有获取成功");
        if (_GetUserParam) {
            _GetUserParam(NO,nil);
        }
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
    if (_GetUserParam) {
        _GetUserParam(NO,nil);
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
    if (_GetUserParam) {
        _GetUserParam(NO,nil);
    }
}

-(void)getUserInfoResponse:(APIResponse *)response{
    NSLog(@"response : %@",response.jsonResponse);
    _userParam.from = @"ios";
    NSString *sex = response.jsonResponse[@"gender"];
    _userParam.sex = sex;
    _userParam.head_img = response.jsonResponse[@"figureurl_1"];
    _userParam.name = response.jsonResponse[@"nickname"];
//    _userParam.openid = response.jsonResponse[@"openid"];
    _userParam.access_token = _tencentOAuth.accessToken;
    _userParam.openid = _tencentOAuth.openId;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *expiresDateString = [dateFormatter stringFromDate:_tencentOAuth.expirationDate];
    _userParam.expires_date = expiresDateString;
    if (_GetUserParam) {
        _GetUserParam(YES,_userParam);
    }
}


@end

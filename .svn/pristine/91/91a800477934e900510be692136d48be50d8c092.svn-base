//
//  HttpTool.m
//  Zhibo
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HttpTool.h"
#import "YZGAppSettingUtilits.h"
#import "AlertTool.h"
#import "NSString+MD5.h"

#import <AFNetworking/AFNetworking.h>

@implementation HttpTool


+(void)requestWithUrlFlag:(HttpRequsetUrlFlag)flag param:(NSMutableDictionary *)param success:(void (^)(id))success faile:(void (^)(void))faile{
    
    [self requestWithUrlFlag:flag param:param witherHeader:nil success:success faile:faile];
}

+(void)requestWithUrlFlag:(HttpRequsetUrlFlag)flag param:(NSMutableDictionary *)param witherHeader:(id)header success:(void (^)(id))success faile:(void (^)(void))faile{
    
    NSString *url = nil;
    switch (flag) {
//            HttpRequsetUrlFlagGetPresentAreaByid
        case HttpRequsetUrlFlagGetPresentAreaByid:{
            
            url = @"get_present_area_byid";
        }
            break;
        case HttpRequsetUrlFlagGetPresentAreaList:{
            
            url = @"get_present_area_list";
        }
            break;
        case HttpRequsetUrlFlagPresentExchange:{
            
            url = @"present_exchange";
        }
            break;
        
        case HttpRequsetUrlFlagSetLocation:{
            
            url = @"setLocation";
        }
            break;
            
            
        case HttpRequsetUrlFlagAddhits:{
            
            url = @"hits";
        }
            break;
        case HttpRequsetUrlFlagGetGuideMsg:{
            
            url = @"get_guide_msg";
        }
            break;
            
        case HttpRequsetUrlFlagShare:{
            
            url = @"share";
        }
            break;
        case HttpRequsetUrlFlagShowSwitch:{
            
            url = @"show_switch";
        }
            break;
        case HttpRequsetUrlFlagGetShowStatus:{
            
            url = @"get_show_status";
        }
            break;
            
        case HttpRequsetUrlFlagDoOrderOshow:{
            
            url = @"do_order_show";
        }
            break;
            
        case HttpRequsetUrlFlagGetUserShow:{
            
            url = @"get_user_show";
        }
            break;
         
        case HttpRequsetUrlFlagUserGetGgmList:{
            
            url = @"get_bgm_list";
        }
            break;
            
        case HttpRequsetUrlFlagOrderhowList:{
            
            url = @"order_show_list";
        }
            break;
            
        case HttpRequsetUrlFlagUserGetBgmTerms:{
            
            url = @"get_bgm_terms";
        }
            break;
        case HttpRequsetUrlFlagAddShow:{
            
             url = @"user_show_add";
        }
          break;
        case HttpRequsetUrlFlagGetComments:{
           url = @"get_comments";
        }
            break;
        case HttpRequsetUrlFlagComment:
        {
            url = @"comment";
        }
            break;
        case HttpRequsetUrlFlagGetviews:
        {
            url = @"get_views";
        }
            break;
        case HttpRequsetUrlFlagGetSts:
        {
            url = @"get_upload_auth";
        }
            break;
        case HttpRequsetUrlFlagUserlike:
        {
            url = @"like";
        }
            break;
            
        case HttpRequsetUrlFlagLogin:
        {
            url = @"login";
        }
            break;
        case HttpRequsetUrlFlagSendOauthUserInfo:
        {
            url = @"sendOauthUserInfo";
        }
            break;
            
        case HttpRequsetUrlFlagRegeist:
        {
            url = @"register";
        }
            break;
        case HttpRequsetUrlFlagGet_Phone_Varcode:
        {
            url = @"get_phone_varcode";
        }
            break;
        case HttpRequsetUrlFlagRetrievePassword:
        {
            url = @"retrievePassword";
        }
            break;
        case HttpRequsetUrlFlagChangePassword:
        {
            url = @"changePassword";
        }
            break;
        case HttpRequsetUrlFlagGetLive:
        {
            url = @"getLive";
        }
            break;
        case HttpRequsetUrlFlagCheckRoomPassword:
        {
            url = @"checkRoomPassword";
        }
            break;
        case HttpRequsetUrlFlagGetAttentionLiveList:
        {
            url = @"getAttentionLiveList";
        }
            break;
        case HttpRequsetUrlFlagEnterLiveRoom:
        {
            url = @"enterLiveRoom";
        }
            break;
        case HttpRequsetUrlFlagGetLiveRoomOnlineUserList:
        {
            url = @"getLiveRoomOnlineUserList";
        }
            break;
        case HttpRequsetUrlFlagExitLiveRoom:
        {
            url = @"exitLiveRoom";
        }
            break;
        case HttpRequsetUrlFlagAddAttention:
        {
            url = @"addAttention";
        }
            break;
        case HttpRequsetUrlFlagCancelAttention:
        {
            url = @"cancelAttention";
        }
            break;
        case HttpRequsetUrlFlagAdd_like:
        {
            url = @"add_like";
        }
            break;
        case HttpRequsetUrlFlagStartLive:
        {
            url = @"startLive";
        }
            break;
        case HttpRequsetUrlFlagStartLivePushCallback:
        {
            url = @"startLivePushCallback";
        }
            break;
        case HttpRequsetUrlFlagStopLive:
        {
            url = @"stopLive";
        }
            break;
        case HttpRequsetUrlFlagSearchUsers:
        {
            url = @"searchUsers";
        }
            break;
        case HttpRequsetUrlFlagGetLiveRoomOnlineNumEarn:
        {
            url = @"getLiveRoomOnlineNumEarn";
        }
            break;
        case HttpRequsetUrlFlagSendGiftToAnchor:
        {
            url = @"sendGiftToAnchor";
        }
            break;
            
        case HttpRequsetUrlFlagGet_recharge_package:
        {
            url = @"get_recharge_package";
        }
            break;
        case HttpRequsetUrlFlagBegin_wxpay:
        {
            url = @"begin_wxpay";
        }
            break;
        case HttpRequsetUrlFlagBegin_alipay:
        {
            url = @"begin_alipay";
        }
            break;
        case HttpRequsetUrlFlagBegin_applepay:
        {
            url = @"begin_applepay";
        }
            break;
        case HttpRequsetUrlFlagCheck_pay:
        {
            url = @"check_pay";
        }
            break;
        case HttpRequsetUrlFlagwGetMyLiveRecordList:
        {
            url = @"getMyLiveRecordList";
        }
            break;
        case HttpRequsetUrlFlagBindingMobile:
        {
            url = @"bindingMobile";
        }
            break;
        case HttpRequsetUrlFlagAdvancedManage:
        {
            url = @"advancedManage";
        }
            break;
            
            
            //add by hao big a fish
        case HttpRequsetUrlFlagwChangeUserInfo:
        {
            
            url = @"change_userinfo";
        }
            break;
        case HttpRequsetUrlFlagwChangeFeedback:
        {
            url = @"submitFeedback";
        }
            break;
        case HttpRequsetUrlFlagwChangePassWord:
        {
            url = @"changePassword";
        }
            break;
        case HttpRequsetUrlFlagwGetUserAttentionList:
        {
            url = @"getUserAttentionList";
        }
            break;
        case HttpRequsetUrlFlagwGetUserFansList:
        {
            url = @"getUserFansList";
        }
            break;
        case HttpRequsetUrlFlagSendReport:
        {
            url = @"sendReport";
        }
            break;
        case HttpRequsetUrlFlagForbiddenSpeak:
        {
            url = @"setDisableSendMsg";
        }
            break;
        case HttpRequsetUrlFlagSetLiveGuard:
        {
            url = @"setLiveGuard";
        }
            break;
        case HttpRequsetUrlFlagCancelLiveGuard:
        {
            url = @"cancelLiveGuard";
        }
            break;
        case HttpRequsetUrlFlagGetGuardList:
        {
            url = @"getLiveGuardList";
        }
            break;
        case HttpRequsetUrlFlagGetShareInfo:
        {
            url = @"getShareInfo";
        }
            break;
        case HttpRequsetUrlFlagGetActivityinfo:
        {
            url = @"getActivityinfo";
        }
            break;
        case HttpRequsetUrlFlagSendDanmuToAnchor://发送弹幕
        {
            url = @"sendDanmuToAnchor";
        }
            break;
        case HttpRequsetUrlFlagSearchSong:
        {
            url = @"searchSong";
        }
            break;
        case HttpRequsetUrlFlagSearchSongLyric:
        {
            url = @"searchSongLyric";
        }
            break;
        case HttpRequsetUrlFlagGetQuestionsTermList:
        {
            url = @"getQuestionsTermList";
        }
            break;
        case HttpRequsetUrlFlagStartMatch:
        {
            url = @"startMatch";
        }
            break;
        case HttpRequsetUrlFlagGetMatchQuestionList:
        {
            url = @"getMatchQuestionList";
        }
            break;
        case HttpRequsetUrlFlagReplyQuestion:
        {
            url = @"replyQuestion";
        }
            break;
        case HttpRequsetUrlFlagFinishReplyQuest:
        {
            url = @"finishReplyQuest";
        }
            break;
        case HttpRequsetUrlFlagVistGetMatchQuestionList:
        {
            url = @"vistGetMatchQuestionList";
        }
            break;
        case HttpRequsetUrlFlagJoinMatch:
        {
            url = @"joinMatch";
        }
            break;
        case HttpRequsetUrlFlagStake:
        {
            url = @"stake";
        }
            break;
        case HttpRequsetUrlFlagConvToOngoingStatus:
        {
            url = @"convToOngoingStatus";
        }
            break;
        case HttpRequsetUrlFlagGetMatchPrice:
        {
            url = @"getMatchPrice";
        }
            break;
        case HttpRequsetUrlFlagUserBlanks:{
            url = @"replyQuestion";
        }
            break;
        case HttpRequsetUrlFlagUserExcludePrice:{
            url = @"get_exclude_price";
        }
            break;
        case HttpRequsetUrlFlagUserExcludeanswer:{
            url = @"exclude_answer";
        }
            break;
        case HttpRequsetUrlFlagUserUpload:{
            url = @"upload_to_user";
        }
         break;
        case HttpRequsetUrlFlagGetUploadInfo:{
            url = @"get_upload_info";
        }
            break;
        case HttpRequsetUrlFlagShowStatus:{
            url = @"user_show_status";
        }
            break;
        case HttpRequsetUrlFlagUserhowEdit:{
            url = @"user_show_edit";
        }
            break;
        case HttpRequsetUrlFlagGetUserInfo:{
            
             url = @"getUserInfo";
        }
            break;
        case HttpRequsetUrlFlagDoShow:{
            
            url = @"do_show";
        }
            break;
        case HttpRequsetUrlFlagGetSubComments:{
            
            url = @"get_sub_comments";
        }
            break;
        case HttpRequsetUrlFlagUploadDelete:{
                
                url = @"upload_delete";
            }
            break;
        case HttpRequsetUrlFlagGetUploadTerms:{
            
            url = @"upload_terms";
        }
            break;
        case HttpRequsetUrlFlagIsJoinMatch:{
            
            url = @"isJoinMatch";
        }
            break;
//           HttpRequsetUrlFlagIsStartMatch
        case HttpRequsetUrlFlagIsStartMatch:{
            
            url = @"isStartMatch";
        }
            break;
         
        case HttpRequsetUrlFlagCheckShowOrder:{
            
            url = @"checkShowOrder";
        }
            break;
//       HttpRequsetUrlFlagCanerrortimes
            
        case HttpRequsetUrlFlagCanerrortimes:{
            
            url = @"canerrortimes";
        }
            break;
        case HttpRequsetUrlFlagGetSensitiveWords:{
            
            url = @"getSensitiveWords";
        }
            break;
            
        default:
            break;
    }
    
    [self requestWithUrl:url WithParam:param withHeader:header succsess:success faile:faile];
}

///上传图片
+(void)uploadImage:(UIImage *)image withUrlFlag:(HttpRequsetUrlFlag)flag param:(NSMutableDictionary *)param success:(void (^)(id))success{
    
    NSString *url;
    switch (flag) {
        case HttpRequsetUrlFlagwChangeUserInfo:
        {
            url = @"change_userinfo";
        }
            break;
        case HttpRequsetUrlFlagwChangeUserBackground:{
            
            url = @"change_background";
        }
            break;
        default:
            break;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self api]]];
    
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [param setObject:[[NSString getSignatureaAndTimeStamp] firstObject] forKey:@"sign"];
    [param setObject:[[NSString getSignatureaAndTimeStamp] lastObject] forKey:@"timestamp"];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(image);
        if (flag == HttpRequsetUrlFlagwChangeUserBackground) {
            [formData appendPartWithFileData:data name:@"background" fileName:@"background.png" mimeType:@"image/png"];
        }else{
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
        }
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

+(void)requestWithUrl:(NSString *)urlString WithParam:(NSMutableDictionary *)param withHeader:(id)header succsess:(void (^)(id responseObject))success faile:(void (^)(void))faile
{
    for (NSString *key in param) {
        param = param.mutableCopy;
        if ([key isEqualToString:@"ID"]) {
            [param setObject:param[key] forKey:@"id"];
            [param removeObjectForKey:key];
        }
    }
    
    [param setObject:[[NSString getSignatureaAndTimeStamp] firstObject] forKey:@"sign"];
    [param setObject:[[NSString getSignatureaAndTimeStamp] lastObject] forKey:@"timestamp"];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self api]]];
    
    [manager.requestSerializer setTimeoutInterval:60];
    
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    
    if (header) {
        for (NSString *key in header) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //处理网络请求失败结果
        YZGLog(@"httpt request faile url:%@ --- error info:%@",urlString,[error localizedDescription]);
        if (faile) {
            [AlertTool ShowErrorInView:KKeyWindow withTitle:[error localizedDescription]];
            faile();
        }else{
            [AlertTool ShowErrorInView:KKeyWindow withTitle:@"当前网络连接不好"];
        }
    }];
}
+(void)downLoadMusicWithUrl:(NSString *)urlString toPath:(NSString *)destinationPath downloadProgress:(void (^)(CGFloat))progress completion:(void (^)(BOOL isSuccess,id result))completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = destinationPath;
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            YZGLog(@"downLoadMusicWithError%@-=-=-=-=-=",[error localizedDescription]);
            completion(NO,[error localizedDescription]);
        }else{
            completion(YES,@"歌曲下载成功");
        }
    }];
    [downloadTask resume];
}

+(NSString *)api{
    return AppApi;
}
@end

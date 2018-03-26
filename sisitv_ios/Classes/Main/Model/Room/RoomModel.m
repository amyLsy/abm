//
//  RoomModel.m
//  sisitv
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "RoomModel.h"

#import "HttpTool.h"
#import <MJExtension/MJExtension.h>

@implementation RoomModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"info":@"RoomInfo",@"msg":@"RoomSystemMessage"};
}

+(void)startLiveWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagStartLive withParam:param success:success faile:nil];
}
+(void)startLivePushCallback:(RoomParam *)param success:(requestSuccessBlock)success faile:(void (^)(void))faile{
    [self httprequestWithFlag:HttpRequsetUrlFlagStartLivePushCallback withParam:param success:success faile:faile];
}
+(void)getLiveRoomOnlineList:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetLiveRoomOnlineUserList withParam:param success:success faile:nil];
}

+(void)reportTheRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagSendReport withParam:param success:success faile:nil];
}

+(void)managerLiveGuard:(RoomParam *)param withTitle:(NSString *)title success:(requestSuccessBlock)success{
    if ([title containsString:@"取消"]){
        [self httprequestWithFlag:HttpRequsetUrlFlagCancelLiveGuard withParam:param success:success faile:nil];
    }else{
        [self httprequestWithFlag:HttpRequsetUrlFlagSetLiveGuard withParam:param success:success faile:nil];
    }
}

+(void)getGuardListWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetGuardList withParam:param success:success faile:nil];
}

+(void)forbiddenWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagForbiddenSpeak withParam:param success:success faile:nil];
}

+(void)stopLiveWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagStopLive withParam:param success:success faile:nil];
}

+(void)loadLiveRoomListWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetLive withParam:param success:success faile:nil];
}
+(void)checkRoomPassword:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagCheckRoomPassword withParam:param success:success faile:nil];
}

+(void)loadAttentionRoomListWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetAttentionLiveList withParam:param success:success faile:nil];
}


+(void)loadLiveRoomOnlineNumEarn:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetLiveRoomOnlineNumEarn withParam:param success:success faile:nil];
}


+(void)enterRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagEnterLiveRoom withParam:param success:success faile:nil];
}

+(void)leaveRoomWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagExitLiveRoom withParam:param success:success faile:nil];
}

+(void)getActivityinfoWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagGetActivityinfo withParam:param success:success faile:nil];
}
+(void)administartorManageWithParam:(RoomParam *)param success:(requestSuccessBlock)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagAdvancedManage withParam:param success:success faile:nil];
}

+(void)httprequestWithFlag:(HttpRequsetUrlFlag)httpRequsetUrlFlag withParam:(RoomParam *)param success:(void (^)(id responseObj ,BOOL successGetInfo))success faile:(void(^)(void))faile{
    
    [HttpTool requestWithUrlFlag:httpRequsetUrlFlag param:param.mj_keyValues success:^(id responseObject) {
        BOOL successGetInfo = YES;
        id result;
        if ([responseObject[@"code"] isEqual:@200]) {
            //responseObject有info数组,则返回的是房间列表
            //responseObject有data字典,则返回的是一个房间的信息
            RoomModel *roomModel = [RoomModel mj_objectWithKeyValues:responseObject];
            switch (httpRequsetUrlFlag) {
                case HttpRequsetUrlFlagGetLive:
                case HttpRequsetUrlFlagGetAttentionLiveList:
                {
                    if (roomModel.info.count>0) {
                        result = roomModel.info;
                    }
                }
                    break;
                case HttpRequsetUrlFlagStopLive:
                case HttpRequsetUrlFlagExitLiveRoom:
                case HttpRequsetUrlFlagGetLiveRoomOnlineNumEarn:
                {
                    if(roomModel.data){
                        result = roomModel.data;
                    }
                }
                    break;
                case HttpRequsetUrlFlagStartLive:
                case HttpRequsetUrlFlagEnterLiveRoom:
                {//包含房间信息(roomModel.data)和公告信息(roomModel数组.msg)
                    result = roomModel;
                }
                    break;
                case HttpRequsetUrlFlagStartLivePushCallback:
                {
                    result = responseObject;
                }
                    break;
                case HttpRequsetUrlFlagGetLiveRoomOnlineUserList:
                {
                    //房间观众数组
                    NSMutableArray *userlist = [NSMutableArray array];
                    for (NSDictionary *dic in [responseObject[@"data"] mj_JSONObject]) {
                        AudienceInfo *audienceInfo = [AudienceInfo mj_objectWithKeyValues:dic];
                        [userlist addObject:audienceInfo];
                    };
                    result = userlist;
                }
                    break;
                case HttpRequsetUrlFlagSendReport:
                case HttpRequsetUrlFlagForbiddenSpeak:
                {
                    result = responseObject[@"descrp"];
                }
                    break;
                case HttpRequsetUrlFlagSetLiveGuard:
                {
                    result = responseObject[@"descrp"];
                }
                    break;
                case HttpRequsetUrlFlagCancelLiveGuard:
                {
                    result = responseObject[@"descrp"];
                }
                    break;
                case HttpRequsetUrlFlagGetGuardList:
                {
                    result = [BaseUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                }
                    break;
                case HttpRequsetUrlFlagGetActivityinfo:
                {
                    result = responseObject[@"data"];
                }
                    break;
                case HttpRequsetUrlFlagAdvancedManage:
                {
                    result = responseObject[@"descrp"];
                }
                    break;
                default:
                    break;
            }
            
        }else {
            successGetInfo = NO;
            if (responseObject[@"data"]){
                RoomModel *roomModel = [RoomModel mj_objectWithKeyValues:responseObject];
                result = roomModel;
            }else{
                result = responseObject[@"descrp"];
            }
        }
        if (success) {
            success(result,successGetInfo);
        }
    } faile:^{
        if (faile) {
            faile();
        }
    }];
}
@end

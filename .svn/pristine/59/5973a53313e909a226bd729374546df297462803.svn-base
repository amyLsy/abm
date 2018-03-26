
//
//  Account.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Account.h"
#import "HttpTool.h"
#import "FMDB.h"
#import "BaseUserRequset.h"


static FMDatabase *dataBase = nil;

static Account *_instance = nil;

@implementation Account

MJCodingImplementation

+(Account *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:zone]init];
    });
    return _instance;
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"data":@"BaseUser"};
}



-(void)loginWithParam:(AccountParam *)param success:(requestSuccess)success{
    
    if (!param.mobile_num.length  || !param.password.length) {
        if (success) {
            success(NO,@"请填写完整的信息");
        }
    }
    else{
        [self httprequestWithFlag:HttpRequsetUrlFlagLogin withParam:param success:success faile:nil];
    }
}


-(void)regeistWithParam:(AccountParam *)param success:(requestSuccess)success{
    
    if ( !param.mobile_num.length ||  !param.password.length ||  !param.varcode.length ||!param.repassword.length) {
        if (success) {
            success(NO,@"请填写完整的信息");
        }
    }
    else{
        [self httprequestWithFlag:HttpRequsetUrlFlagRegeist withParam:param success:success faile:nil];
    }
}

-(void)forgetPasswordWithParam:(AccountParam *)param success:(requestSuccess)success{
    
    if (!param.mobile_num.length ||  !param.password.length ||  !param.varcode.length ||!param.repassword.length) {
        if (success) {
            success(NO,@"请填写完整的信息");
        }
    }
    else{
        [self httprequestWithFlag:HttpRequsetUrlFlagRetrievePassword withParam:param success:success faile:nil];
    }
}

-(void)changePasswordWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagChangePassword withParam:param success:success faile:nil];
}

-(void)getVarcodeWithParam:(AccountParam *)param success:(requestSuccess)success{
    if (!param.mobile_num.length){
        if (success) {
            success(NO,@"请填写手机号");
        }
    }else{
        [self httprequestWithFlag:HttpRequsetUrlFlagGet_Phone_Varcode withParam:param success:success faile:nil];
    }
}

-(void)changeAvtar:(UIImage *)avatar success:(requestSuccess)success{
    AccountParam *param = [AccountParam accountParam];
    param.avatar = @"avatar";
    [HttpTool uploadImage:avatar withUrlFlag:HttpRequsetUrlFlagwChangeUserInfo param:param.mj_keyValues success:^(id responseObject) {
        success(YES,responseObject[@"descrp"]);
    }];
}

-(void)changeUserBackground:(UIImage *)background success:(requestSuccess)success{
    
    AccountParam *param = [AccountParam accountParam];
    param.background = @"background";
    [HttpTool uploadImage:background withUrlFlag:HttpRequsetUrlFlagwChangeUserBackground param:param.mj_keyValues success:^(id responseObject) {
        success(YES,responseObject[@"descrp"]);
    }];
    
}


-(void)bindingMobileWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagBindingMobile withParam:param success:success faile:nil];
}

-(void)attentionPeopleWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagAddAttention withParam:param success:success faile:nil];
}

-(void)cancelAttentionPeopleWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagCancelAttention withParam:param success:success faile:nil];
}


-(void)attentionOrCancelAttentionWithCurrentButtonTitle:(NSString *)buttonTitle WithParam:(AccountParam *)param success:(requestSuccess)success{
    if ([buttonTitle containsString:@"已关注"]) {
        [self cancelAttentionPeopleWithParam:param success:success];
    }else{
        [self attentionPeopleWithParam:param success:success];
    }
}

-(void)zanWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagAdd_like withParam:param success:success faile:nil];
}
//发送弹幕
-(void)sendDanmuToAnchorWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagSendDanmuToAnchor withParam:param success:success faile:nil];
}
-(void)sendGiftWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagSendGiftToAnchor withParam:param success:success faile:nil];
}

-(void)getAccountInfoSuccess:(void (^)(void))success faile:(void (^)(void))faile{
    BaseParam *userParam = [[BaseParam alloc] initWithUserId:self.ID];
    BaseUserRequset *userRequset = [[BaseUserRequset  alloc] initWithRequestParam:userParam];
    [userRequset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        NSString *token = self.token;
        Account *account = [Account mj_objectWithKeyValues:request.responseObject[@"data"]];
        account.token = token;
        success();
    } failure:^(__kindof YZGRequest * _Nonnull request) {
        [Account removeAccount];
        if (faile) {
            faile();
        }
    }];
}

-(void)getMyLiveRecordListWithParam:(AccountParam *)param success:(requestSuccess)success{
    [self httprequestWithFlag:HttpRequsetUrlFlagwGetMyLiveRecordList withParam:param success:success faile:nil];
}

-(void)httprequestWithFlag:(HttpRequsetUrlFlag)httpRequsetUrlFlag withParam:(AccountParam *)param success:(requestSuccess)success faile:(void (^)(void))faile{
    
    [HttpTool requestWithUrlFlag:httpRequsetUrlFlag param:param.mj_keyValues success:^(id responseObject) {
        BOOL isSuccess = YES;
        id result;
        if ([responseObject[@"code"] isEqual:@200]) {
            //info是登陆后返回的信息
            switch (httpRequsetUrlFlag) {
                case HttpRequsetUrlFlagLogin:
                {   _instance = [Account mj_objectWithKeyValues:[responseObject[@"info"] firstObject]];
                    _instance.token = responseObject[@"token"];
                    [Account  storeAccount];
                }
                    break;
                case HttpRequsetUrlFlagSendDanmuToAnchor://发送弹幕
                {
                    NSNumber *number = responseObject[@"data"] [@"balance"];
                    NSString *balance = [NSString  stringWithFormat:@"%@",number ];
                    self.balance = balance;
                    result = balance;
                }
                    break;
                case HttpRequsetUrlFlagRegeist://发送弹幕
                {
                    
                    result = responseObject;
                }
                    break;
                    
                    //data是字典的话就是用户信息
                case HttpRequsetUrlFlagSendGiftToAnchor:
                {
                    result = responseObject[@"data"][@"total_earn"];
                    _instance = [Account mj_objectWithKeyValues:responseObject[@"data"]];
                }
                    break;
                case HttpRequsetUrlFlagAddAttention:
                case HttpRequsetUrlFlagCancelAttention:
                {
                    if ([responseObject[@"descrp"] containsString:@"取消"]) {
                        result = @"关注";
                    }else{
                        result = @"已关注";
                    }
                }
                    break;
                case HttpRequsetUrlFlagChangePassword:
                {
                    result = responseObject[@"descrp"];
                }
                    break;
                case HttpRequsetUrlFlagwGetMyLiveRecordList:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }else{
            isSuccess = NO;
            result = responseObject[@"descrp"];
        }
        //回调
        if (success) {
            success(isSuccess,result);
        }

    } faile:^() {
        if (faile) {
            faile();
        }
    }];
    
    
}


+ (void)initialize
{
    if (self == [Account class]) {
        dataBase = [FMDatabase databaseWithPath:dataBasePath];
        if ([dataBase open]) {
            if ([dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_account ( token text  , ID text );"]) {
                YZGLog(@"创建表成功");
            }else{
                YZGLog(@"创建表失败");
            }
        }
    }
}

+(Account *)isLogined
{
    Account *account = [Account shareInstance];
    FMResultSet *set = [dataBase executeQuery:@"select * from t_account"];
    [set next];
    NSString *token = [set stringForColumn:@"token"];
    NSString *ID = [set stringForColumn:@"ID"];
    if (token)
    {
        account.token = token;
        account.ID = ID;
    }
    return account;
}



+(void)storeAccount{
    Account *account = [Account shareInstance];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO t_account (token ,ID ) VALUES (?, ?)",  account.token,account.ID];
    if (success) {
        YZGLog(@"success");
    }
    else{
        
        YZGLog(@"faile");
    }
}


+(NSString *)updateTableWithKey:(NSString *)key withvalue:(NSString *)value{
    return [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@'",@"t_account",key,value];
}


+(void)changeAccountTableValue:(NSString *)value forKey:(NSString *)key{
    NSString *updateSql = [self updateTableWithKey:key withvalue: value];
    BOOL res = [dataBase executeUpdate:updateSql];
    if (res) {
        YZGLog(@"success update db table");
        [Account  storeAccount];
    } else {
        YZGLog(@"error to update db table");
    }
}

+(void)removeAccount{
    _instance.token = nil;
    _instance.ID = nil;
    if ([dataBase executeUpdate:@"DELETE FROM t_account"]) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

+ (void)firstRegister{
    //首次注册
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetGuideMsg param:param success:^(id responseObject) {
        
    } faile:^{
        
    }];
    
    
}

@end

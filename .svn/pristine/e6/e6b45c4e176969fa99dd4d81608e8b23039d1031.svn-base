//
//  BaseParam.m
//  sisitv
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseParam.h"
#import "Account.h"
@implementation BaseParam


-(instancetype)init{
    if (self = [super init]) {
        self.os = @"ios";
        self.soft_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        self.token = [Account shareInstance].token;
    }
    return self;
}
-(instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        self.ID = userId;
        self.os = @"ios";
        self.soft_ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        self.token = [Account shareInstance].token;
    }
    return self;
}
@end

//
//  BaseUserRequset.m
//  sisitv_ios
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseUserRequset.h"

@implementation BaseUserRequset

-(NSString *)requestUrl{
    return @"getUserInfo";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    BaseUser *user = [BaseUser mj_objectWithKeyValues:self.responseObject[@"data"]];
    self.item = user;
}

@end

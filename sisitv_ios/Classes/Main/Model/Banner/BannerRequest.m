//
//  BannerRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/22.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BannerRequest.h"

@implementation BannerRequest
-(NSString *)requestUrl{
    return @"getBanner";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    NSArray *modelArray = [BannerRowItem mj_objectArrayWithKeyValuesArray:self.responseObject[@"data"]];
    self.item = modelArray;
}

@end

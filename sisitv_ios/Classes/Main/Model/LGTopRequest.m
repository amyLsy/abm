//
//  LGTopRequest.m
//  sisitv_ios
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGTopRequest.h"

@implementation LGTopRequest


-(NSString *)requestUrl{
    return @"upload_terms";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    NSArray *modelArray = [TopicRowItem mj_objectArrayWithKeyValuesArray:self.responseObject[@"data"]];
    self.item = modelArray;
}

@end

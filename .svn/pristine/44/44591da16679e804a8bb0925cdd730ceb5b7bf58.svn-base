//
//  ShowingTagRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "TopicRequest.h"

@implementation TopicRequest


-(NSString *)requestUrl{
    return @"getChannelTermList";
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

//
//  RankRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "RankRequest.h"

@implementation RankRequest

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    NSArray *contributionArray = [RankRowItem mj_objectArrayWithKeyValuesArray:self.responseObject[@"data"]];
    self.item = contributionArray;
}

@end

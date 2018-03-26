//
//  LGMediaListRequest.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGMediaListRequest.h"

@implementation LGMediaListRequest

-(NSString *)requestUrl{
    return @"get_views";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    NSArray *modelArray = [LGMediaListModel mj_objectArrayWithKeyValuesArray:self.responseObject[@"data"]];
    self.item = modelArray;
}

@end

//
//  ADRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ADRequest.h"

@implementation ADRequest

-(NSString *)requestUrl{
    return @"getLaunchScreen";
}
-(BOOL)jsonValidator{
    if ([self.responseObject isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    ADItem *adItem = [ADItem mj_objectWithKeyValues:self.responseObject];
    self.item = adItem;
}

@end

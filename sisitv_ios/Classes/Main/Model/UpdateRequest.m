//
//  UpdateRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/22.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "UpdateRequest.h"

@implementation UpdateRequest

-(NSString *)requestUrl{
    return @"getGiftList";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    self.item = self.responseObject[@"data"];
}
@end

//
//  GiftListRequest.m
//  sisitv_ios
//
//  Created by apple on 17/3/22.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "GiftListRequest.h"

@implementation GiftListRequest
-(NSString *)requestUrl{
    return @"getGiftList";
}

-(BOOL)jsonValidator{
    if ([self.responseObject[@"data"] isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

-(void)serializedResponseObjectToModel{
    NSArray *giftInfoArray = [GiftInfo mj_objectArrayWithKeyValuesArray:self.responseObject[@"data"]];

    self.item = giftInfoArray;
}
@end

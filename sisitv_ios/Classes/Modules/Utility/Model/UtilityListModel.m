//
//  UtilityListModel.m
//  sisitv_ios
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "UtilityListModel.h"

@implementation UtilityListModel

-(void)parseServerData:(NSDictionary *)responseObject{
    NSArray * utilityRowItem = [UtilityRowItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:utilityRowItem];
}

@end
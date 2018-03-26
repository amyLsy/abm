//
//  SearchListModel.m
//  sisitv_ios
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "SearchListModel.h"

@implementation SearchListModel

-(void)parseServerData:(NSDictionary *)responseObject{
    NSArray * rowItems = [UtilityRowItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:rowItems];
}
@end

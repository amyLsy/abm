//
//  MainModel.m
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "MainListModel.h"

@implementation MainListModel

-(void)parseServerData:(NSDictionary *)responseObject{
    NSArray * roomInfo = [RoomInfo mj_objectArrayWithKeyValuesArray:responseObject[@"info"]];
    [self.responseObject addObjectsFromArray:roomInfo];
}

@end

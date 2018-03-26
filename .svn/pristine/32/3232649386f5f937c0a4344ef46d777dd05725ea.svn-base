//
//  MYGiftModel.m
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MYGiftModel.h"

@implementation MYGiftModel


- (void)parseServerData:(NSDictionary *)responseObject{
    
  
    NSArray * model = [MYGiftModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:model];
    
}


@end

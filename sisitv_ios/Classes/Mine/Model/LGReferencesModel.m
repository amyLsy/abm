


//
//  LGReferencesModel.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGReferencesModel.h"

@implementation LGReferencesModel


- (void)parseServerData:(NSDictionary *)responseObject{
    
    NSArray * model = [LGReferencesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:model];
    
}

@end

//
//  LGShowListModel.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGShowListModel.h"

@implementation LGShowListModel



- (void)parseServerData:(NSDictionary *)responseObject{
    
    [LGShowListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"desc":@"description"};
    }];
    NSArray * model = [LGShowListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:model];
    
}

@end

//
//  RankListModel.m
//  sisitv_ios
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "RankListModel.h"

@implementation RankListModel

-(void)parseServerData:(NSDictionary *)responseObject{
    NSArray * rankRowItem = [RankRowItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    if ([self.listParam isKindOfClass:[RankListParam class]]) {
        RankListParam *param = (RankListParam *)self.listParam;
        NSString *type = param.type;
        [self setType:type forRankRowItemArray:rankRowItem];
        [self.responseObject addObjectsFromArray:rankRowItem];
    }
}

-(void)setType:(NSString *)type forRankRowItemArray:(NSArray *)rankRowItemArray{
    for (RankRowItem *rankRowItem in rankRowItemArray) {
        rankRowItem.type = type;
    }
}
@end

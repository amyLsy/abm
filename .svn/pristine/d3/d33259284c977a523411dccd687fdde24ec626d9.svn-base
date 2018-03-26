//
//  RankListParam.h
//  sisitv_ios
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGListParam.h"

@interface RankListParam : YZGListParam

/**
 1:当为系统全局收益榜或贡献打赏榜时,type代表的是榜单类型（收益榜benefit,打赏榜contribution）
 2:当为个人贡献榜类型时,type代表的是榜单获取的方式(总榜all/月榜month/周榜week/日榜day）
 */
@property (nonatomic , strong) NSString *type;

/**
 获取系统全局收益榜或贡献打赏榜的方式(总榜all/月榜month/周榜week/日榜day）
 */
@property (nonatomic , strong) NSString *order;

-(instancetype)initWithId:(NSString *)userId type:(NSString *)type order:(NSString *)order;

@end

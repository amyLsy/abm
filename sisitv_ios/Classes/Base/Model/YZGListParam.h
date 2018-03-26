//
//  YZGListParam.h
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseParam.h"

@interface YZGListParam : BaseParam
//limit_begin：从第几条开始取(默认从第0条开始取)
@property (nonatomic , copy) NSString *limit_begin;

//limit_num：需要取几条(默认取20条)
@property (nonatomic , copy) NSString *limit_num;

@end

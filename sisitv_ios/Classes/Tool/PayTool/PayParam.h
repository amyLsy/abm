//
//  PayParam.h
//  sisitv
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseParam.h"

#define productId_6 @"longchenglive6600"
#define productId_30 @"longchenglive33000"
#define productId_98 @"longchenglive989800"
#define productId_298 @"longchenglive29800"
#define productId_588 @"longchenglive58800"
#define productId_1598 @"longchenglive159800"
//#define productId_1998 @"longchenglive199800"
//#define productId_2298 @"longchenglive229800"
//#define productId_2998 @"longchenglive299800"

@interface PayParam : BaseParam

/**
 *商品id：item_id
 **/
@property (nonatomic , copy) NSString * item_id;

/**
 *苹果账单凭证
 **/
@property (nonatomic , copy) NSString * receipt;

@end

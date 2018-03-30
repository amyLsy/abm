//
//  DiamondModel.m
//  sisitv
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "CostModel.h"
#import "HttpTool.h"
@implementation CostModel

+(void)getDiamondListSuccess:(void (^)(BOOL, NSArray *))succcess{
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGet_recharge_package param:nil success:^(id responseObject) {
        BOOL isSuccess;
        NSLog(@"==%@", responseObject);
        id result;
        if ([responseObject[@"code"] isEqual:@200]) {
            isSuccess = YES;
            NSMutableArray *rowItems = [CostRowItem mj_objectArrayWithKeyValuesArray:responseObject[@"info"]];
            result = rowItems;
        }
        succcess(isSuccess,result);
    } faile:nil];
    
    
//    BOOL isSuccess = YES;
//    NSArray *rowItems =[CostRowItem mj_objectArrayWithKeyValuesArray:@[
//                                                                       @{
//                                                                           @"diamond_num" : @42,
//                                                                           @"id" : @61,
//                                                                           @"money_num" : @"6元"
//                                                                           },
//                                                                       @{
//                                                                           @"diamond_num" : @210,
//                                                                           @"id" : @62,
//                                                                           @"money_num" : @"30元"
//                                                                           },
//                                                                       @{
//                                                                           @"diamond_num" : @686,
//                                                                           @"id" : @63,
//                                                                           @"money_num" : @"98元"
//                                                                           },
//                                                                       @{
//                                                                           @"diamond_num" : @2086,
//                                                                           @"id" : @64,
//                                                                           @"money_num" : @"298元"
//                                                                           },
//                                                                       @{
//                                                                           @"diamond_num" : @4116,
//                                                                           @"id" : @65,
//                                                                           @"money_num" : @"588元"
//                                                                           },
//                                                                       @{
//                                                                           @"diamond_num" : @11186,
//                                                                           @"id" : @66,
//                                                                           @"money_num" : @"1598元"
//                                                                           }]];
//    id result = rowItems;
//    
//    succcess(isSuccess,result);
}

@end

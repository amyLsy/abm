//
//  DiamondModel.h
//  sisitv
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CostRowItem.h"

@interface CostModel : NSObject

+(void)getDiamondListSuccess:(void(^)(BOOL successGetInfo ,NSArray *costRowItems))succcess;

@end

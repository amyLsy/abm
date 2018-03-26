//
//  GameModelList.m
//  sisitv_ios
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "GameModelList.h"
#import <MJExtension/MJExtension.h>

@implementation GameSelectGameTypeModel

@end
@implementation GameArea

+ (void)load{
    
    [GameArea mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
    [GameArea mj_setupObjectClassInArray:^NSDictionary *{
       
        
        return @{@"rank_present_list":[RankPresentModel class]};
        
    }];
    
    
}


@end
@implementation RankPresentModel

@end




//
//  UtilityController.h
//  xiuPai
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGRefreshTableViewController.h"

typedef NS_ENUM(NSUInteger, UtilityStyle) {
    UtilityAttention,
    UtilityFans
};

@interface UtilityController : YZGRefreshTableViewController

@property (nonatomic , copy) NSString *ID;

-(instancetype)initWithUtilityStyle:(UtilityStyle)utilityStyle;
-(instancetype)initWithTitle:(UtilityStyle)utilityStyle name:(NSString *)titleName;
@end

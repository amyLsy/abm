//
//  BaseScrollView.m
//  sisitv_ios
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

-(instancetype)init{
    
    if (self = [super init]) {
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
@end

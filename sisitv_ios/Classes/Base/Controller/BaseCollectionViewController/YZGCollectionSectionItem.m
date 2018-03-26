//
//  YZGCollectionItem.m
//  sisitv
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGCollectionSectionItem.h"

@implementation YZGCollectionSectionItem

-(instancetype)init{
    if (self = [super init]) {
        self.rowItems = [NSMutableArray array];
    }
    return self;
}
@end

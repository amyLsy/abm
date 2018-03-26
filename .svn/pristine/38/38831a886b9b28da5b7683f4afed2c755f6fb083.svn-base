//
//  YZGTableViewSectionObject.m
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGTableViewSectionItem.h"

@implementation YZGTableViewSectionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.footerTitle = @"";
        self.rowItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithItemsArray:(NSMutableArray *)items {
    self = [self init];
    if (self) {
        [self.rowItems addObjectsFromArray:items];
    }
    return self;
}

@end

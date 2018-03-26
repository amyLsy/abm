//
//  YZGTableViewSectionObject.h
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGTableViewSectionItem : NSObject

@property (nonatomic , strong) id sectionHeaderItem;

@property (nonatomic , copy) NSString *footerTitle;


//数组里的每一个元素就是一个row的数据
@property (nonatomic , strong) NSMutableArray *rowItems;


-(instancetype)initWithItemsArray:(NSMutableArray *)items;

@end

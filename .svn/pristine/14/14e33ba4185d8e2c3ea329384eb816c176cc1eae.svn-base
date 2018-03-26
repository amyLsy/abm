//
//  YZGTableViewDataSource.m
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGTableViewDataSource.h"

 

@implementation YZGTableViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionItems = [NSMutableArray array];
    }
    return self;
}

-(instancetype)initWithController:(UIViewController<YZGTableViewCellDelegate> *)viewController{
    self = [super init];
    if (self) {
        self.sectionItems = [NSMutableArray array];
        self.delegateController = viewController;
    }
    return self;
}

-(void)clearAllItems{
    for (YZGTableViewSectionItem *sectionItem in self.sectionItems) {
        [sectionItem.rowItems  removeAllObjects];
    }
}

// 以下两个方法会子类有机会重写，默认的 Cell 类型是 YZGTableViewCell
- (Class)tableView:(UITableView*)tableView cellClassForSection:(NSInteger )section{
    return [YZGTableViewCell class];
}

-(YZGHeaderView *)tableView:(UITableView *)tableView sectionHeaderViewForHeaderItem:(id)sectionHeaderItem{
    return nil;
}
-(YZGHeaderView *)headerViewForTableView:(UITableView *)tableView{
    return nil;
}

////datasource
-(YZGTableViewRowItem *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sectionItems.count > indexPath.section) {
        YZGTableViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:indexPath.section];
        if (sectionItem.rowItems.count >indexPath.row) {
            return [sectionItem.rowItems objectAtIndex:indexPath.row];
        }
    }
    return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionItems.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sectionItems.count >0) {
        YZGTableViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:section];
        return sectionItem.rowItems.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cellClass;
    if ([self respondsToSelector:@selector(tableView:cellClassForItem:)]) {
        cellClass = [ self tableView:tableView cellClassForItem:item];
    }else{
        cellClass = [self tableView:tableView cellClassForSection:indexPath.section];
    }
    NSString *className = NSStringFromClass(cellClass);
    YZGTableViewCell *cell = (YZGTableViewCell *)[tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
        if (self.delegateController) {
            cell.delegate = self.delegateController;
        }else{
            YZGLog(@"not set delegateController!!!!!!!!!");
        }
     }
    [cell setItem:item forIndexPath:indexPath];
    return cell;
}

-(void)dealloc{
    self.delegateController = nil;
}

@end

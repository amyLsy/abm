//
//  YZGTableViewDataSource.h
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGTableViewCell.h"
#import "YZGHeaderView.h"
#import "YZGTableViewSectionItem.h"

@protocol YZGTableViewDataSource <UITableViewDataSource>

@optional

- (YZGTableViewRowItem *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *根据item获取cellClass
 */
-(Class)tableView:(UITableView *)tableView cellClassForItem:(id)item;

/**
 *根据section获取cellClass
 */
-(Class)tableView:(UITableView *)tableView cellClassForSection:(NSInteger)section;
/**
 *根据sectionHeaderItem获取sectionHeaderView
 */
-(YZGHeaderView *)tableView:(UITableView *)tableView sectionHeaderViewForHeaderItem:(id)sectionHeaderItem;
/**
 *获取tableViewHeaderView
 */
-(YZGHeaderView *)headerViewForTableView:(UITableView *)tableView;
@end



@interface YZGTableViewDataSource : NSObject<YZGTableViewDataSource>

@property (nonatomic , strong) NSMutableArray *sectionItems;
@property (nonatomic , strong) id headerItem;

@property (nonatomic , weak) UIViewController<YZGTableViewCellDelegate> *delegateController;

-(instancetype)initWithController:(UIViewController<YZGTableViewCellDelegate> *)viewController;

/**
 清除所有数据
 */
- (void)clearAllItems;

@end

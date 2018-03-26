//
//  YZGTableViewCell.h
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGTableViewRowItem.h"
#import "YZGTableViewCellDelegate.h"

#import "UIImageView+Rouding.h"

@interface YZGTableViewCell : UITableViewCell

@property (nonatomic , weak) id<YZGTableViewCellDelegate> delegate;

-(void)setItem:(id )item forIndexPath:(NSIndexPath *)indexPath;

/**rowHeight*/
+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath;
/**sectionHeaderHeight*/
+(CGFloat)tableView:(UITableView *)tableView sectionHeaderHeightForSectionHeaderItem:(id)sectionHeaderItem;
@end

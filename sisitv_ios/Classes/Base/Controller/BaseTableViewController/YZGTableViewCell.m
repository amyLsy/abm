//
//  YZGTableViewCell.m
//  tableView解耦
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGTableViewCell.h"

@interface YZGTableViewCell ()

@end
@implementation YZGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
}



+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 0.0;
}
+(CGFloat)tableView:(UITableView *)tableView sectionHeaderHeightForSectionHeaderItem:(id)sectionHeaderItem{
    return 0.0f;
}

@end

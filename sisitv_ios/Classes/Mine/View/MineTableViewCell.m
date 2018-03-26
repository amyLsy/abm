//
//  MineTableViewCell.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MineTableViewCell.h"
#import "RankRowItem.h"

@interface MineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *descrp;
@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    MineRowItem *rowItem = (MineRowItem *)item;
    self.avatar.image = [UIImage imageNamed:rowItem.avatar];
    self.descrp.text = rowItem.descrp;
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 45.0*k5sHeightScale;
}

@end

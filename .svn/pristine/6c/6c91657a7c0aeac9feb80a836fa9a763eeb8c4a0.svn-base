//
//  MineCostBalanceDiamond.m
//  sisitv
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "MineBalanceDiamondCell.h"

@interface MineBalanceDiamondCell ()
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *blanceName;

@end

@implementation MineBalanceDiamondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.blanceName.text = [NSString stringWithFormat:@"%@%@",kBalance,@"余额"];
}


-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    CostRowItem *costRowItem = (CostRowItem *)item;
     self.balance.text = costRowItem.balance;
}
+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return  220.0f;
}

@end

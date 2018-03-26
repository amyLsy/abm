//
//  CostMineDiamondCell.m
//  sisitv
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "MineDiamondListCell.h"

@interface MineDiamondListCell ()
@property (weak, nonatomic) IBOutlet UIButton *diamondCount;
@property (weak, nonatomic) IBOutlet UIButton *price;

@end

@implementation MineDiamondListCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.price.backgroundColor = [UIColor whiteColor];
    [self.price setTitleColor:kNavColor forState:UIControlStateNormal];
    self.price.layer.cornerRadius = 5;
    self.price.layer.borderColor = [kNavColor CGColor];
    self.price.layer.borderWidth = 1;
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    if ([item isKindOfClass:[CostRowItem class]]) {
        CostRowItem * costRowItem = (CostRowItem *)item;
        [self.diamondCount setTitle:costRowItem.diamond_num forState:UIControlStateNormal];
        [self.price setTitle:costRowItem.money_num forState:UIControlStateNormal] ;
    }
}


+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

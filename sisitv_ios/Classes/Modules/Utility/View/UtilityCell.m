//
//  UtilityCell.m
//  xiuPai
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UtilityCell.h"
#import "UIImageView+Rouding.h"
#import "UtilityRowItem.h"
@interface UtilityCell()
@property (weak, nonatomic) IBOutlet UIImageView *avtar;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet UIButton *attentionState;
@property (weak, nonatomic) IBOutlet UILabel *stateAndSignature;

@property (nonatomic , strong) UtilityRowItem *utilityRowItem;
@end

@implementation UtilityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.avtar roundingImage];
}


-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    UtilityRowItem *utilityRowItem = (UtilityRowItem *)item;
     self.utilityRowItem = utilityRowItem;
    [self.avtar sd_setImageWithURL:[NSURL URLWithString:utilityRowItem.avatar] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
    self.name.text = utilityRowItem.user_nicename;
    [self.level setTitle: utilityRowItem.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:utilityRowItem.userLevelImageName] forState:UIControlStateNormal];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    self.gender.image = [UIImage imageNamed:utilityRowItem.sex];
    //认证
//    if (attentionOrFansRowItem.is_truename) {
//        _tureNameImageView.image = [UIImage imageNamed:attentionOrFansRowItem.is_truename];
//    }else{
//        _tureNameImageView.image = nil;
//    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",utilityRowItem.channel_status,utilityRowItem.signature]];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(utilityRowItem.channel_status.length, utilityRowItem.signature.length)];
    self.stateAndSignature.attributedText = attString;
    
    [self.attentionState  setTitle:utilityRowItem.attention_status forState:UIControlStateNormal];
    [self.attentionState  setTitleColor:utilityRowItem.attentionStatusColor forState:UIControlStateNormal];
    if (utilityRowItem.attentionStatusImageName) {
    [self.attentionState  setImage:[UIImage imageNamed:utilityRowItem.attentionStatusImageName] forState:UIControlStateNormal];
    }else{
        [self.attentionState  setImage:nil forState:UIControlStateNormal];
    }
}

- (IBAction)attentionStateClick {
    [self.delegate tableViewCell:self clickAttentionStatusWithTitle:self.attentionState.titleLabel.text withItem:self.utilityRowItem];
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end

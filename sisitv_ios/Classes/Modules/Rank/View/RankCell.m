//
//  ContributionTableViewCell.m
//  liveFrame
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RankCell.h"
#import "UIImageView+Rouding.h"
@interface RankCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatrToLeft;


@property (weak, nonatomic) IBOutlet UIImageView *avtar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *rank;
@property (weak, nonatomic) IBOutlet UIImageView *topOfThreeRank;

@end

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avtar roundingImage];
    self.rank.layer.cornerRadius = 7.5;
    self.rank.clipsToBounds = YES;
    self.info.text = [NSString stringWithFormat:@"%@0",kBenefit];//源代码默认显示每条数据的具体值
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>2) {//现在统一高度
        return 56.0;//三排之后低行距？？？
    }
    return 56.0;//三排之前高行距？？？
}


-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath
{
    RankRowItem *rankRowItem = (RankRowItem *)item;

    NSString *rankOrder = [NSString stringWithFormat:@"%ld",indexPath.row +4];
        [self.rank setImage:nil forState:UIControlStateNormal];
        [self.rank setTitle:rankOrder forState:UIControlStateNormal];
        self.avatrToLeft.constant = 15;
//    }
    [self.avtar sd_setImageWithURL:rankRowItem.avatar];
    self.gender.image = [UIImage imageNamed:rankRowItem.sex];
    [self.level setTitle:rankRowItem.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:rankRowItem.userLevelImageName] forState:UIControlStateNormal];
    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    self.name.text = rankRowItem.user_nicename;
    // 收益榜、打赏榜、智者榜每条数据的前缀描述文字
    if ([rankRowItem.type isEqualToString:@"benefit"]) {
        self.info.text = [NSString stringWithFormat:@"收益了%@%@",rankRowItem.money_num,kBalance];
    }else if([rankRowItem.type isEqualToString:@"contribution"]){
        self.info.text = [NSString stringWithFormat:@"贡献了%@%@",rankRowItem.money_num,kBalance];
    }else if([rankRowItem.type isEqualToString:@"wiserank"]){//wiserank
//        智者榜暂时不在下方显示获得排名的具体数据
//        self.info.text = [NSString stringWithFormat:@"答对了%@%@",rankRowItem.correct_num,kTitle];//添加“智力”文字，源代码send_num
        self.info.text = [NSString stringWithFormat:@""/*,rankRowItem.correct_num,kTitle*/];
    }else{
        self.info.text = [NSString stringWithFormat:@"贡献了%@%@",rankRowItem.send_num,kBalance];//个人粉丝贡献榜里面的粉丝贡献活力值
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

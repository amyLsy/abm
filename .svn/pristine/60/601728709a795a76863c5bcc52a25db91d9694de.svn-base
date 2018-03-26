//
//  GameTheEndListTableViewCell.m
//  sisitv_ios
//
//  Created by 悟不透。 on 2017/11/9.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "GameTheEndListTableViewCell.h"
#import "LGGameListView.h"

@implementation GameTheEndListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.clipsToBounds = YES;
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
}

-(void)setD:(NSDictionary *)d
{
    if (d) {
        _noLabel0.text=d[@"user_nicename"];
        _noLabel1.text = [NSString stringWithFormat:@"活动收益：%@    押注花费：%@\n回答正确：%@题    回答错误：%@题", d[@"earn"], d[@"stake"], d[@"correct_num"], d[@"error_times"]];
        [_noImage0 sd_setImageWithURL:[NSURL URLWithString:d[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
        NSDictionary *presentDict = d[@"present"];
        if (presentDict) {
            self.rankLabel.text = [NSString stringWithFormat:@"排名第%@名 游戏奖励",presentDict[@"rank"]];
            self.giftName.text = presentDict[@"giftname"];
            self.needCoin.text = [NSString stringWithFormat:@"价值:%zd",[presentDict[@"needcoin"] integerValue]];
            [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:presentDict[@"gifticon"]]];
        }
    
//
        int status = [d[@"status"] intValue];
        if (_index<4) {
            NSString *iurl = @"";
            switch (_index) {
                case 1:
                    iurl = @"第1名头像";
                    break;
                case 2:
                    iurl = @"第2名头像";
                    break;
                case 3:
                    iurl = @"第3名头像";
                    break;
            }
            [_noImage1 setImage:[UIImage imageNamed:iurl]];
        }else{
            _noImage1.hidden=YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

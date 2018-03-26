



//
//  LGGameListView.m
//  sisitv_ios
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGGameListView.h"
#import "UIImageView+LGUIimageView.h"

@implementation LGGameListView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)config:(NSDictionary *)userDict index:(NSInteger)index{
    
    _userDict = userDict;
    
    
    _nameLbl.text = userDict[@"user_nicename"];
    //    [_userAvatarImageView setHeader:userDict[@"userDict"]];
    [_userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:userDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
    NSString *gameInfo = [NSString stringWithFormat:@"正确:%@ 错误:%@",userDict[@"correct_num"],userDict[@"error_times"]];
    
    _gameInfoLabel.text = gameInfo;
    if ([userDict[@"status"] integerValue] == 4) {
        
        _statusLable.text = @"进行中";
    }else if([userDict[@"status"] integerValue] == 4 ){
        
        _statusLable.text = @"淘汰";
        
    }else{
        
        _statusLable.text = @"";
        
    }
    
    if (index<3) {
        NSString *iurl = @"";
        switch (index) {
            case 0:
                iurl = @"第1名头像";
                break;
            case 1:
                iurl = @"第2名头像";
                break;
            case 2:
                iurl = @"第3名头像";
                break;
        }
        [_noImage1 setImage:[UIImage imageNamed:iurl]];
    }else{
        _noImage1.hidden=YES;
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"NO.%zd",index + 1];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

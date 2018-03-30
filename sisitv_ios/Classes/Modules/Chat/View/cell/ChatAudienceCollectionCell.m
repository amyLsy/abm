//
//  ChatAudienceCollectionCell.m
//  liveFrame
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatAudienceCollectionCell.h"
#import "AudienceInfo.h"
#import "UIImageView+Rouding.h"

@interface ChatAudienceCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UIButton *level;

@end

@implementation ChatAudienceCollectionCell


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.avatar roundingImage];
}


-(void)setAudienceInfo:(AudienceInfo *)audienceInfo
{
    _audienceInfo = audienceInfo;

    [self.avatar sd_setImageWithURL:audienceInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
    
    [self.level setTitle:audienceInfo.localProcessedUserLevel  forState:UIControlStateNormal];

    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:audienceInfo.userLevelImageName] forState:UIControlStateNormal];

}

@end

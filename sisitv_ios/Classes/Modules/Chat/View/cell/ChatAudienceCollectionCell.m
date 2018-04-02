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

@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelHegithConstraint;

@end

@implementation ChatAudienceCollectionCell


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.avatar roundingImage];
    [self bringSubviewToFront:self.level];
    self.level.font = [UIFont boldSystemFontOfSize:8];
    self.level.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.level.layer.cornerRadius = 5.1;
    self.level.clipsToBounds = YES;
}


-(void)setAudienceInfo:(AudienceInfo *)audienceInfo
{
    _audienceInfo = audienceInfo;

    [self.avatar sd_setImageWithURL:audienceInfo.avatar placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
    self.level.text = [NSString stringWithFormat:@"Lv.%@",audienceInfo.localProcessedUserLevel];
}

@end

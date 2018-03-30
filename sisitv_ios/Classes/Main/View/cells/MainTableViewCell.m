//
//  MainTableViewCell.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MainTableViewCell.h"
#import "BaseButton.h"
#import "UIImageView+Rouding.h"
@interface MainTableViewCell ()
 
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *avtar ;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location ;
@property (weak, nonatomic) IBOutlet UILabel *people;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *level;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.status.layer.cornerRadius = 3;
    self.status.layer.masksToBounds = YES;
    self.status.layer.borderWidth = 1.0;
    self.status.layer.borderColor = [UIColor colorWithHexString:@"f12a6b"].CGColor;
    
    self.avtar.layer.masksToBounds = YES;
    self.avtar.layer.cornerRadius = 45.0/2;
    self.avtar.layer.borderWidth = 1.0;
    self.avtar.layer.borderColor = [kNavColor CGColor];
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return KScreenWidth;
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath
{
   
    RoomInfo *roomInfo = (RoomInfo *)item;
    
    self.name.text =  roomInfo.user_nicename  ;
    [self.preImageView sd_setImageWithURL:roomInfo.smeta];
    [self.avtar sd_setImageWithURL:[NSURL URLWithString: roomInfo.avatar ]];
    [self.location setText:roomInfo.location];
    
    [self.people setText:roomInfo.online_num];
    [self.people setTextColor:kNavColor];
    
    [self.title setText:roomInfo.channel_title];
    
    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.level setTitle:roomInfo.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:roomInfo.userLevelImageName] forState:UIControlStateNormal];
   
}

  

@end

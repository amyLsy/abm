//
//  ChatGuardListCell.m
//  sisitv
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 JLXX-YZG. All rights reserved.
//

#import "ChatGuardListCell.h"
#import "BaseUser.h"
@interface ChatGuardListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic , strong) id item;
@end

@implementation ChatGuardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.iconImageView roundingImage];
    [self.cancelButtton setTitleColor:kNavColor forState:UIControlStateNormal];
    [self.cancelButtton layoutIfNeeded];
    self.cancelButtton.layer.cornerRadius = self.cancelButtton.height/2.0;
    self.cancelButtton.layer.masksToBounds = YES;
    self.cancelButtton.layer.borderColor = [UIColor colorWithHexString:@"ff4081"].CGColor;
    self.cancelButtton.layer.borderWidth = 1.0;
    self.nameLabel.textColor = kNavColor;
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
- (IBAction)cancelAdmin:(UIButton *)sender {
    [self.delegate didClickCancelButton:sender withUserId:[self.item ID]];
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    BaseUser *user = (BaseUser *)item;
    self.item = item;
    self.nameLabel.text = user.user_nicename;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    [self.cancelButtton setTitle:@"取消场控" forState:UIControlStateNormal];
}

@end

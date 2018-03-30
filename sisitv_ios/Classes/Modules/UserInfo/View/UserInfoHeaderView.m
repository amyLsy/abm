//
//  UserInfoHeaderView.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UserInfoHeaderView.h"
#import "UIImageView+Rouding.h"
#import "UIImageView+LGUIimageView.h"
#import "BaseUser.h"
@interface UserInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *dropDown;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *attention;
@property (weak, nonatomic) IBOutlet UIButton *livingStatus;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *video;
@property (weak, nonatomic) IBOutlet UILabel *image;

@end

@implementation UserInfoHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    self.needAmplificationView = self.dropDown;
    _livingStatus.layer.cornerRadius = 5;
    _livingStatus.layer.masksToBounds = YES;
    [self.avatar roundingImage];
    for (UIView *view in self.bottomView.subviews) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomViewClcik:)];
        [view addGestureRecognizer:tap];
    }
}


-(CGFloat)headerHeightForTableView:(UITableView *)tableView{
    return 290.0*KHeightScale;
}

-(void)setInfomation:(id)infomation{
    if (!infomation) {
        return;
    }
    BaseUser *user = (BaseUser *)infomation;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    self.name.text = user.user_nicename;
    self.ID.text = user.ID;
    self.signature.text = user.signature;
    self.gender.image = [UIImage imageNamed:user.sex];
    self.fans.text = user.fans_num;
    self.attention.text = user.attention_num;
    self.video.text = user.video_num;
    self.image.text = user.photo_num;
    [self.backgroundImageView lg_setImageWithurl:user.background placeholderImage:nil];
    [self.level setTitle:user.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:user.userLevelImageName] forState:UIControlStateNormal];
    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    if ([user.channel_status isEqualToString:@"正在直播"]) {
        self.livingStatus.hidden = NO;
        [self.livingStatus setTitle:user.channel_status forState:UIControlStateNormal];
    }
}

- (IBAction)privateClick {
    [self.delegate headerView:self didClickButton:UserInfoHeaderViewButtonPrivate];
}

- (IBAction)backClick{
    [self.delegate headerView:self didClickButton:UserInfoHeaderViewButtonBack];
}

- (IBAction)livingClick {
    [self.delegate headerView:self didClickButton:UserInfoHeaderViewButtonLiving];
}

-(void)bottomViewClcik:(UITapGestureRecognizer *)ges{
    if (ges.view.tag == 2){
        [self.delegate headerView:self didClickButton:UserInfoHeaderViewButtonFans];

    }else if(ges.view.tag == 3){
        [self.delegate headerView:self didClickButton:UserInfoHeaderViewButtonAttention];
    }else if (ges.view.tag == 4){
        
         [self.delegate headerView:self didClickButton:MineHeaderViewButtonVideo];
    }else if (ges.view.tag == 5){
        
        [self.delegate headerView:self didClickButton:MineHeaderViewButtonPhoto];
    }
}

@end

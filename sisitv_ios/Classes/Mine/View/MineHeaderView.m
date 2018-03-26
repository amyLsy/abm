//
//  YZGHeaderView.m
//  xiuPai
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MineHeaderView.h"
#import "UIImageView+Rouding.h"
#import "Account.h"
#import "LeanCloudTool.h"
#import "UIImageView+LGUIimageView.h"
@interface MineHeaderView ()


@property (weak, nonatomic) IBOutlet UIView *dropDown;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UIView *signatureView;

@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIButton *zan;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *attention;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *picImageLabel;



@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomViewSubViews;

@end

@implementation MineHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.needAmplificationView = self.dropDown;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.width * 0.5;
    self.avatar.layer.borderWidth = 2.0;
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.signatureView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    for (UIView *view in self.bottomViewSubViews) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BottomViewClcik:)];
        [view addGestureRecognizer:tap];
    }
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BottomViewClcik:)];
    self.userBgImageView.tag = 6;
    self.userBgImageView.userInteractionEnabled = YES;
    [self.userBgImageView addGestureRecognizer:tap];
    
    
}
-(CGFloat)headerHeightForTableView:(UITableView *)tableView{
    return 290.0*KHeightScale;
}

-(void)setInfomation:(id)infomation{
    Account *user = (Account *)infomation;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    self.name.text = user.user_nicename;
    self.ID.text = [NSString stringWithFormat:@"ID: %@",user.ID];
    self.signature.text = user.signature;
    self.signatureView.layer.cornerRadius = self.signatureView.height/3.0;
    self.gender.image = [UIImage imageNamed:user.sex];
    self.fans.text = user.fans_num;
    self.attention.text = user.attention_num;
    self.videoLabel.text = user.video_num;
    self.picImageLabel.text = user.photo_num;
    [self.bigImageView lg_setImageWithurl:user.background placeholderImage:[UIImage imageNamed:@"me_bg"]];
    [self.level setTitle:user.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setBackgroundImage:[UIImage imageNamed:user.userLevelImageName] forState:UIControlStateNormal];
    KWeakSelf;
    [[LeanCloudTool leanCloudTool] setUnreadCountBlock:^(NSInteger totalUnreadCount) {
        if (totalUnreadCount <=0) {
            ws.unreadMessage.hidden = YES;
        }else{
            ws.unreadMessage.hidden = NO;
        }
    }];
}

- (IBAction)editClick{
    [self.delegate headerView:self didClickButton:MineHeaderViewButtonEdit];
}

- (IBAction)messageClick {
    [self.delegate headerView:self didClickButton:MineHeaderViewButtonMessage];
}

-(void)BottomViewClcik:(UITapGestureRecognizer *)ges{

    if (ges.view.tag == 2){
        [self.delegate headerView:self didClickButton:MineHeaderViewButtonFans];
    }else if(ges.view.tag == 3){
        [self.delegate headerView:self didClickButton:MineHeaderViewButtonAttention];
    }else if(ges.view.tag == 4){
        [self.delegate headerView:self didClickButton:MineHeaderViewButtonVideo];
    }else if(ges.view.tag == 5){
       [self.delegate headerView:self didClickButton:MineHeaderViewButtonPhoto];
    }else{
        
        [self.delegate headerView:self didClickButton:MineHeaderViewUploadImage];
    }
}
@end

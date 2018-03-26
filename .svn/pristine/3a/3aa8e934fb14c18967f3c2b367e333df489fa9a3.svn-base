//
//  ALinChatDetialUserView.m
//  MiaowShow
//
//  Created by ALin on 16/6/28.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ChatAlertInfomationView.h"
#import "Account.h"
#import "RankRowItem.h"
#import "AlertTool.h"
#import "UIImageView+Rouding.h"


@interface ChatAlertInfomationView()
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *signatureView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shouhuImageViewArray;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *level;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumber;
@property (weak, nonatomic) IBOutlet UILabel *fansNumber;
@property (weak, nonatomic) IBOutlet UIButton *priviate;
@property (weak, nonatomic) IBOutlet UIButton *attention;
@end

@implementation ChatAlertInfomationView

+ (instancetype)infomationView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
     self.backgroundColor = [UIColor clearColor];
    self.infoView.layer.cornerRadius = 10;
    self.infoView.layer.masksToBounds = YES;
    self.infoView.backgroundColor = kNavColor;
    [self.avatar roundingImage];
    self.signatureView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.user.attention_status = change[@"new"];
}

-(void)setShouHu:(NSArray *)shouHu{
    for (NSInteger i =0; i<shouHu.count; i++) {
        RankRowItem *rankRowItem = shouHu[i];
        UIImageView *shouhuImageView = self.shouhuImageViewArray[i];
        [shouhuImageView roundingImage];
        [shouhuImageView sd_setImageWithURL:[NSURL URLWithString:rankRowItem.avatar]];
    }
}

-(void)setUser:(BaseUser *)user{
    _user = user;
     //性别
    [self.avatar sd_setImageWithURL:_user.avatar placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
    self.gender.image = [UIImage imageNamed:_user.sex];
    self.name.text = _user.user_nicename;
    [self.level setTitle: _user.localProcessedUserLevel forState:UIControlStateNormal];
    [self.level setBackgroundImage:[UIImage imageNamed:_user.userLevelImageName] forState:UIControlStateNormal];
    self.userId.text = [NSString stringWithFormat:@"ID: %@",_user.ID];
    self.signature.text = _user.signature;
    self.signatureView.layer.cornerRadius = self.signatureView.height/3.0;
    self.attentionNumber.text = _user.attention_num;
    self.fansNumber.text = _user.fans_num;
    [self.attention  setTitle:_user.attention_status forState:UIControlStateNormal];
}



- (IBAction)managerButtonClick:(UIButton *)button {
    [self.delegate chatAlertInfomationView:self didClickButton:button withTypeName:ChatAlertInfomationManager];
}
//关闭
- (IBAction)closeButtonClick:(UIButton *)sender {
    [self.delegate chatAlertInfomationView:self didClickButton:nil withTypeName:ChatAlertInfomationClose];

}
//私信
- (IBAction)private:(UIButton *)button {
    if ([self isSelfWithTitle:@"不能给自己私信"]) {
        return;
    }
    [self.delegate chatAlertInfomationView:self didClickButton:button withTypeName:ChatAlertInfomationPrivate];
}
//关注
- (IBAction)attention:(UIButton *)button {
    if ([self isSelfWithTitle:@"不能关注自己"]) {
        return;
    }
    [self.delegate chatAlertInfomationView:self didClickButton:button withTypeName:ChatAlertInfomationAttentionOrCancel];
}

//是否是自己
-(BOOL)isSelfWithTitle:(NSString *)title{
    if ([[Account shareInstance].ID isEqualToString:self.user.ID]) {
       [AlertTool ShowInView:self onlyWithTitle:title hiddenAfter:1.0];
       return  YES;
    }else{
        return  NO;
    }
}


-(void)dealloc{
    YZGLog(@"%@",self);
}

@end

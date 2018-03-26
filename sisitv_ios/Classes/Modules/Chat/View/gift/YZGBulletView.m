//
//  TCMsgBulletView.m
//  TCLVBIMDemo
//
//  Created by zhangxiang on 16/8/3.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "YZGBulletView.h"
#import "YZGBulletAnimationView.h"

#define MSG_ANIMATE_DURANTION     8  //默认一个弹幕View的运行速度为： 2*SCREEN_WIDTH/MSG_ANIMATE_DURANTION

 
@interface YZGBulletView ()


@end
@implementation YZGBulletView


-(void)bulletNewMessage:(ChatMessage *)chatMessage{
    if (chatMessage){
         YZGBulletAnimationView *view = [self creatAnimateView];
        [self animateView:view chatMessage:chatMessage];
    }
}

-(YZGBulletAnimationView *)creatAnimateView{
    YZGBulletAnimationView *bulletAnimationView =  [[[NSBundle mainBundle]loadNibNamed:@"YZGBulletAnimationView" owner:nil options:nil]lastObject];
    bulletAnimationView.frame = CGRectMake(self.width, 0, 0, self.height);
    [self addSubview:bulletAnimationView];
    return bulletAnimationView;
}

-(void)animateView:(YZGBulletAnimationView *)bulletAnimationView chatMessage:(ChatMessage *)msgModel{
    bulletAnimationView = [self resetViewFrame:bulletAnimationView msg:msgModel];
     CGFloat duration =  5.0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame =  bulletAnimationView.frame;
        bulletAnimationView.frame = CGRectMake(-frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [bulletAnimationView removeFromSuperview];
    }];
}

-(YZGBulletAnimationView *)resetViewFrame:(YZGBulletAnimationView *)bulletAnimationView msg:(ChatMessage *)msgModel{
    NSAttributedString *userName = [self getAttributedUserNameFromModel:msgModel];
    CGRect nameRect = [userName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    NSAttributedString *userMsg = [self getAttributedUserMsgFromModel:msgModel];
    CGRect msgRect = [userMsg boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height - 14) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    UIImageView *headImageView = bulletAnimationView.avatar;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:
                                           msgModel.avatar]];
        
    UILabel *userNamelabel = bulletAnimationView.name;
    userNamelabel.attributedText = userName;
    userNamelabel.width = nameRect.size.width;
    UILabel *userMsgLabel = bulletAnimationView.message;
    userMsgLabel.attributedText = userMsg;
    userMsgLabel.width = msgRect.size.width;
    bulletAnimationView.width = headImageView.width + 5 + (userNamelabel.width > userMsgLabel.width ? userNamelabel.width : userMsgLabel.width);
     return bulletAnimationView;
}

-(NSAttributedString *)getAttributedUserNameFromModel:(ChatMessage *)msgModel{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *userName = [[NSMutableAttributedString alloc] initWithString:msgModel.userName];
    [attribute appendAttributedString:userName];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,userName.length)];
    return attribute;
}
-(NSAttributedString *)getAttributedUserMsgFromModel:(ChatMessage *)chatMessage{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *userMsg = [[NSMutableAttributedString alloc] initWithString:chatMessage.content];
    [attribute appendAttributedString:userMsg];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,userMsg.length)];;
    return attribute;
}
@end

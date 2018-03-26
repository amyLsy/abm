//
//  RankHeadView.m
//  sisitv_ios
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "RankHeadView.h"
#import "RankRowItem.h"
#import "UIImageView+LGUIimageView.h"
#import "UIImage+lg_image.h"
#import "LGButtont.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface RankHeadView()

@property (weak, nonatomic) IBOutlet UIButton *secondLevel;
@property (weak, nonatomic) IBOutlet UIButton *firstLevel;
@property (weak, nonatomic) IBOutlet UIButton *threeLevel;

@property (weak, nonatomic) IBOutlet UIImageView *secondSex;
@property (weak, nonatomic) IBOutlet UIImageView *firstSex;
@property (weak, nonatomic) IBOutlet UIImageView *threeSex;

@end


@implementation RankHeadView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.avatarImageViews = @[self.firstAvatar,self.secondAvatar,self.theThirdAvatar];
    self.nameLables = @[self.firstName,self.secondName,self.theThirdName];
    self.infoLables = @[self.firstInfoLabel,self.secondInfoLabel,self.theThirdInfoLabel];
    self.bgimages = @[self.firstBgImageView,self.secondBgImageView,self.thirdBgimageView];
    self.levels = @[self.firstLevel,self.secondLevel,self.threeLevel];
    self.sexs = @[self.firstSex,self.secondSex,self.threeSex];
}


- (void)setDataArray:(NSArray *)dataArray{
    for (int i = 0; i < 3; i++) {
        UIView *view1 = self.avatarImageViews[i];
        UIView *view2 = self.infoLables[i];
        LGButtont *view3 = self.bgimages[i];
        UIView *view4 = self.nameLables[i];
        UIView *view5 = self.levels[i];
        UIView *view6 = self.sexs[i];
        view1.hidden = YES;
        view2.hidden = YES;
        view3.hidden = YES;
        view3.object = nil;
        view4.hidden = YES;
        view5.hidden = YES;
        view6.hidden = YES;
    }
    
    
    _dataArray = dataArray;
    for (int i = 0; i < dataArray.count; i++) {
        
        [self configHeadData:dataArray[i] avatarImageView:self.avatarImageViews[i] nameLable:self.nameLables[i] infoLabel:self.infoLables[i] bgImageView:self.bgimages[i] levelButton:self.levels[i] suerSexImageView:self.sexs[i]];
        
    }
    
//    RankRowItem *rowItem1 = dataArray[0];
//    [self.firstAvatar setHeader:rowItem1.avatar];
//    self.firstName.text = rowItem1.user_nicename;
//    [self confidata:rowItem1 infoLabel:self.firstInfoLabel];
//
//    RankRowItem *rowItem2 = dataArray[1];
//    [self.secondAvatar setHeader:rowItem2.avatar];
//    self.secondName.text = rowItem2.user_nicename;
//    [self confidata:rowItem2 infoLabel:self.secondInfoLabel];
//
//
//    RankRowItem *rowItem3 = dataArray[2];
//    [self.theThirdAvatar setHeader:rowItem3.avatar];
//    self.theThirdName.text = rowItem3.user_nicename;
//    [self confidata:rowItem3 infoLabel:self.theThirdInfoLabel];
    
    
}

- (void)configHeadData:(RankRowItem *)item  avatarImageView:(UIImageView *)avatarImageView nameLable:(UILabel *)namelable infoLabel:(UILabel *)infoLabel bgImageView:(LGButtont *)bgImageView levelButton:(UIButton *)level suerSexImageView:(UIImageView *)sex{
    
    bgImageView.hidden = NO;
    avatarImageView.hidden = NO;
    infoLabel.hidden = NO;
    namelable.hidden = NO;
    level.hidden = NO;
    sex.hidden = NO;
    [avatarImageView setHeader:item.avatar];
    bgImageView.object = item;
    namelable.text = item.user_nicename;
    [self confidata:item infoLabel:infoLabel];

    [level setTitle:item.localProcessedUserLevel forState:UIControlStateNormal];
    [level setBackgroundImage:[UIImage imageNamed:item.userLevelImageName] forState:UIControlStateNormal];
    sex.image = [UIImage imageNamed:item.sex];
}

- (void)confidata:(RankRowItem *)rankRowItem infoLabel:(UILabel *)infoLabel{
    // 收益榜、打赏榜、智者榜前三名数据的前缀描述文字
    if ([rankRowItem.type isEqualToString:@"benefit"]) {
        infoLabel.text = [NSString stringWithFormat:@"收益了%@%@",rankRowItem.money_num,kBalance];
    }else if([rankRowItem.type isEqualToString:@"contribution"]){
        infoLabel.text = [NSString stringWithFormat:@"贡献了%@%@",rankRowItem.money_num,kBalance];
    }else if([rankRowItem.type isEqualToString:@"wiserank"]){//wiserank
//        智者榜暂时不在下方显示获得排名的具体数据
        infoLabel.text = [NSString stringWithFormat:@""/*,rankRowItem.correct_num,kTitle*/];//添加“智力”文字，源代码send_num
    }else{
        infoLabel.text = [NSString stringWithFormat:@"贡献了了%@%@",rankRowItem.send_num,kBalance];//源代码send_num
    }
    
}

- (IBAction)g2UserInfo:(LGButtont *)sender {
    
    if (_headCallback) {
        
        _headCallback(sender.object);
    }
    
}


@end

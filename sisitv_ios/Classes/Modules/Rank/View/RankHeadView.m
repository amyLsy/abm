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
@property (weak, nonatomic) IBOutlet UIView *switchBgView;

@property (weak, nonatomic) IBOutlet UIImageView *secondSex;
@property (weak, nonatomic) IBOutlet UIImageView *firstSex;
@property (weak, nonatomic) IBOutlet UIImageView *threeSex;
@property (nonatomic, assign) CGFloat originalX;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (weak, nonatomic) IBOutlet UIView *secondStageBgView;
@property (weak, nonatomic) IBOutlet UIView *theThirdStageBgView;
@property (weak, nonatomic) IBOutlet UIView *firstStageBgView;
@property (weak, nonatomic) IBOutlet UIImageView *firstCrownImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondCrownImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdCrownImgView;



@end


@implementation RankHeadView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.avatarImageViews = @[self.firstAvatar,self.secondAvatar,self.theThirdAvatar];
    self.nameLables = @[self.firstName,self.secondName,self.theThirdName];
    self.infoLables = @[self.firstInfoLabel,self.secondInfoLabel,self.theThirdInfoLabel];
    self.bgStageImages = @[self.firstStageBgView,self.secondStageBgView,self.theThirdStageBgView];
    self.levels = @[self.firstLevel,self.secondLevel,self.threeLevel];
    self.sexs = @[self.firstSex,self.secondSex,self.threeSex];
    self.vipImages = @[self.firstVIPImageView,self.secondVIPImageView,self.theThirdVIPImageView];
    self.crownImages = @[self.firstCrownImgView,self.secondCrownImgView,self.thirdCrownImgView];
    self.btnArray = [[NSMutableArray alloc] init];
    [self layoutSwitchView];
}

- (void)layoutSwitchView{
    self.switchBgView.layer.cornerRadius = 18;
    self.switchBgView.clipsToBounds = YES;
    self.switchBgView.layer.borderWidth = 0.8;
    self.switchBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _originalX = 96;
    CGFloat width = (KScreenWidth-192)/3;
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width , 36)];
    [self.switchBgView addSubview:_slideView];
    _slideView.layer.cornerRadius = 18;
    _slideView.clipsToBounds = YES;
    _slideView.backgroundColor = rgba(255, 255, 255, 1);
    UIButton *lastBtn;
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
//        [self.switchBgView addSubview:btn];
        [self.switchBgView insertSubview:btn atIndex:self.switchBgView.subviews.count -1];
        if (lastBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastBtn.mas_right);
                make.top.mas_equalTo(self.switchBgView);
                make.bottom.mas_equalTo(self.switchBgView);
                make.width.mas_equalTo(width);
            }];
            lastBtn = btn;
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.switchBgView);
                make.top.mas_equalTo(self.switchBgView);
                make.bottom.mas_equalTo(self.switchBgView);
                make.width.mas_equalTo(width);
            }];
            btn.selected = YES;
            lastBtn = btn;
        }
        NSString *title = i == 0 ? @"月榜":@"周榜";
        if (i==2) {
            title = @"日榜";
        }
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(switchType:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
    }
    
    [self.slideView.superview sendSubviewToBack:self.slideView];
}

- (void)switchType:(UIButton *)btn{
    NSString *type = btn.tag == 0 ? @"month" : @"week";
    if (btn.tag == 2) {
        type = @"day";
    }
    for (UIButton *button in self.btnArray) {
        if (button.tag != btn.tag) {
            button.selected = NO;
        }else{
            button.selected = YES;
        }
    }
    CGFloat width = (KScreenWidth-192)/3;
    [UIView animateWithDuration:0.3 animations:^{
        [self.slideView.superview sendSubviewToBack:self.slideView];
        self.slideView.frame = CGRectMake(btn.tag * width, 0, width, 36);
    }];
    if (_switchRankType) {
        _switchRankType(type);
    }
}


- (void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    if (dataArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        UIImageView *avatarImageView = self.avatarImageViews[i];
        avatarImageView.hidden = NO;
        UILabel *infoLabel = self.infoLables[i];
        UILabel *nameLabel = self.nameLables[i];
        UIButton *levelBtn = self.levels[i];
        UIImageView *sexImgView = self.sexs[i];
        UIView *stageView = self.bgStageImages[i];
        stageView.hidden = NO;
        UIImageView *crownImgView = self.crownImages[i];
        crownImgView.hidden = NO;
        RankRowItem *item = dataArray[i];
        [avatarImageView setHeader:item.avatar];
        nameLabel.text =  item.user_nicename;
        [levelBtn setTitle:item.localProcessedUserLevel forState:UIControlStateNormal];
        [self confidata:item infoLabel:infoLabel];
        sexImgView.image = [UIImage imageNamed:item.sex];
    }
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

//
//  ShareView.m
//  com.yxvzb.zhibozhushou
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGShareView.h"
#import "BaseButton.h"
#import <FDStackView/FDStackView.h>
@interface YZGShareView ()

@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet UIView *buttonsSuperView;

@end

@implementation YZGShareView


+(instancetype)yzgShareView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.alpha = 0.0;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView)];
//    [self addGestureRecognizer:tap];
    self.buttomView.backgroundColor = [UIColor whiteColor];
     [self setShareButtons:@[@"share_wechat",@"share_wechatmoments",@"share_qq",@"share_qqzone"]];
}
-(void)setShareButtons:(NSArray<NSString *> *)buttonArray{
    FDStackView *buttonStackView =  [[FDStackView alloc] init];
    [self.buttonsSuperView addSubview:buttonStackView];
    [buttonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buttonsSuperView);
    }];
    buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    buttonStackView.alignment = UIStackViewAlignmentFill;
    buttonStackView.distribution = UIStackViewDistributionFillEqually;
    buttonStackView.spacing = 10;
    NSArray *titleArray = @[@"发送给\n微信好友",@"分享到\n朋友圈",@"发送给\nQQ好友",@"分享到\nQQ空间"];
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        BaseButton *shareButton = [BaseButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
//        NSString *title = [buttonArray[i] stringByReplacingOccurrencesOfString:@"分享" withString:@""];
        [shareButton setTitle:titleArray[i] forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [shareButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        shareButton.tag = i+1;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton adjustTitleBlowImageView];
        [buttonStackView addArrangedSubview:shareButton];
    }
}
- (IBAction)closeBtnAction:(id)sender {
    [self removeShareView];
}

- (void)shareButtonClick:(UIButton *)button {
    [self.delegate yzgShareView:self clickShareButtonType:button.tag];
    [self removeFromSuperview];
}

-(void)removeShareView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)dealloc
{
    
}

@end

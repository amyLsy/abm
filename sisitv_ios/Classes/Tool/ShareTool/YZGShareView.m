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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView)];
    [self addGestureRecognizer:tap];
    self.buttomView.backgroundColor = RGB_COLOR(0, 0, 0, 0.8);
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
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        BaseButton *shareButton = [BaseButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
        NSString *title = [buttonArray[i] stringByReplacingOccurrencesOfString:@"分享" withString:@""];
        [shareButton setTitle:title forState:UIControlStateNormal];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        shareButton.tag = i+1;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton adjustTitleBlowImageView];
        [buttonStackView addArrangedSubview:shareButton];
    }
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

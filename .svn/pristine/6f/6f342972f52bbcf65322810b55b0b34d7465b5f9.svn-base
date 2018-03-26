//
//  ShowingTypeView.m
//  sisitv_ios
//
//  Created by Apple on 17/1/5.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ShowingTypeView.h"
#import "BaseButton.h"
#import <FDStackView/FDStackView.h>

@interface ShowingTypeView()

@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet UIView *buttonsSuperView;

@end

@implementation ShowingTypeView

+ (instancetype)showingTypeView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShowingTypeView)];
    [self addGestureRecognizer:tap];
    self.buttomView.backgroundColor = RGB_COLOR(0, 0, 0, 0.8);
}
-(void)setShowingTypeButtons:(NSArray<NSString *> *)buttonArray{
    FDStackView *buttonStackView =  [[FDStackView alloc] init];
    [self.buttonsSuperView addSubview:buttonStackView];
    [buttonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buttonsSuperView);
    }];
    buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    buttonStackView.alignment = UIStackViewAlignmentFill;
    buttonStackView.distribution = UIStackViewDistributionFillEqually;
    buttonStackView.spacing = 5;
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        BaseButton *shareButton = [BaseButton buttonWithType:UIButtonTypeCustom];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        shareButton.tag = i+1;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
        NSString *title = buttonArray[i];
        [shareButton setTitle:title forState:UIControlStateNormal];
        [shareButton adjustTitleBlowImageView];
        [buttonStackView addArrangedSubview:shareButton];
    }
}

- (void)shareButtonClick:(UIButton *)button {
    [self.delegate clickShowingTypeButton:button.tag];
    [self removeFromSuperview];
}

-(void)removeShowingTypeView
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

//
//  ChatAlertManagerView.m
//  sisitv_ios
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatAlertManagerView.h"
#import "BaseButton.h"
#import <FDStackView/FDStackView.h>
@interface ChatAlertManagerView ()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *managerView;

@end

@implementation ChatAlertManagerView

+(instancetype)managerView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.managerView.backgroundColor = RGB_COLOR(0, 0, 0, 0.8);

    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
    [self addGestureRecognizer:ges];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 1.0;
    }];
}

-(void)setManagerButtonArray:(NSArray *)managerButtonArray{
    
    for (UIView *view in self.buttonView.subviews) {
        
        if ([view isKindOfClass:[FDStackView class]]) {
            [view removeFromSuperview];
        }
    }
    _managerButtonArray = managerButtonArray;
    FDStackView *buttonStackView =  [[FDStackView alloc] init];
    CGFloat width = _managerButtonArray.count * 70;
    [self.buttonView addSubview:buttonStackView];
    [buttonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.buttonView);
        make.height.equalTo(self.buttonView);
        make.width.mas_equalTo(width);
    }];
    buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    buttonStackView.alignment = UIStackViewAlignmentFill;
    buttonStackView.distribution = UIStackViewDistributionFillEqually;
    buttonStackView.spacing = 10;
    for (NSInteger i = 0; i < _managerButtonArray.count; i++) {
        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
        [buttonStackView addArrangedSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [button setImage:[UIImage imageNamed:_managerButtonArray[i]] forState:UIControlStateNormal];
        [button setTitle:_managerButtonArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(managerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button adjustTitleBlowImageView];
    }
}

- (void)managerButtonClick:(UIButton *)button {
    ///举报/拉黑/禁言/场控/连麦
    ChatAlertManagerType type;
    if ([button.titleLabel.text isEqualToString:@"举报"]) {
        type = ChatAlertManagerReport;
    }else if ([button.titleLabel.text isEqualToString:@"拉黑"]){
        type = ChatAlertManagerBlackList;
    }else if ([button.titleLabel.text isEqualToString:@"禁言"]){
        type = ChatAlertManagerForbidden;
    }else if ([button.titleLabel.text isEqualToString:@"场控"]){
        type = ChatAlertManagerSetGuard;
    }else if ([button.titleLabel.text isEqualToString:@"连麦"]){
        type = ChatAlertManagerLianMai;
    }
    [self.delegate chatAlertManagerView:self clickManagerButtonType:type];
    [self remove];
}
-(void)remove{
    [self removeFromSuperview];
}

-(void)dealloc
{
    YZGLog(@"%@",self);
}
@end

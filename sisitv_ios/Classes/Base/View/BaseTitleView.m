//
//  BaseTitleView.m
//  xiuPai
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "BaseTitleView.h"

@interface BaseTitleView ()

@property (nonatomic , strong) UIButton *selecedButton;
@property (nonatomic , assign) CGFloat defaultButtonFontSize;
@property (nonatomic , strong) UIView *underLine;
@property (nonatomic , weak) UIView *underLineSuperView;
@end

@implementation BaseTitleView

+(instancetype)titleViewFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

-(void)setButtonArray:(NSArray<UIButton *> *)buttonArray{
    _buttonArray = buttonArray;
    for (UIButton *button in _buttonArray) {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        if (!self.underLineSuperView) {
            self.underLineSuperView = button.superview;
            self.defaultButtonFontSize = button.titleLabel.font.pointSize;
        }
    }
}

#pragma mark ===titleView上的按钮的点击事件
- (void)buttonClick:(UIButton *)button{
    if (self.selecedButton == button) return;
    self.selecedButton.selected = NO;
    self.selecedButton.titleLabel.font = [UIFont systemFontOfSize:self.defaultButtonFontSize];
    [self.selecedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.selecedButton = button;
    self.selecedButton.selected = YES;
    self.selecedButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:self.defaultButtonFontSize];
    [self.selecedButton setTitleColor:[self selectedColorOrDefaultColor] forState:UIControlStateSelected];
    
    [self changeUnderLineXWithButton:button];
    //传出当前选中按钮的tag
    if (self.currentButtonIndex)
    {
        self.currentButtonIndex(button.tag);
    }
}
//自动划到相对应index的按钮
-(void)selectedButtonWithIndex:(NSInteger)index
{
    UIButton *button = self.buttonArray[index];
    [self buttonClick:button];
}

-(void)changeUnderLineXWithButton:(UIButton *)button
{
    [self.underLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_left);
        make.width.equalTo(button.mas_width);
        make.height.equalTo(@3);
        make.bottom.equalTo(self.underLineSuperView);
    }];
}

-(UIView *)underLine{
    if (!_underLine) {
        NSAssert(self.buttonArray, @"buttonArray没有赋值..请在初始化该titleView后赋值");
        _underLine = [[UIView alloc] init];
        [self.underLineSuperView  addSubview:_underLine];
        self.underLine.backgroundColor = [self selectedColorOrDefaultColor];
    }
    return _underLine;
}

-(UIColor *)selectedColorOrDefaultColor{
    if (!self.selectedColor) {
        return  [UIColor blackColor];
    }
    return self.selectedColor;
}

@end

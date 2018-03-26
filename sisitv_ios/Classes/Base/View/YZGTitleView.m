//
//  YZGTitleView.m
//  sisitv_ios
//
//  Created by apple on 17/3/22.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGTitleView.h"

@interface YZGTitleView ()
// 所有button
@property (nonatomic, strong) NSMutableArray *allButtons;

@property (nonatomic , strong) UIView *underLine;

@property (nonatomic , copy) void(^clickButtonBlock)(NSInteger clickedIndex);
/* 所有title */
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic , strong) UIButton *selecedButton;

@end

@implementation YZGTitleView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles clickButton:(void(^)(NSInteger clickedIndex))clickButtonBlock{
    
    if (self = [super initWithFrame:frame]) {
        self.clickButtonBlock = clickButtonBlock;
        self.titles = titles;
        self.normalColor = kNavDarkColor;
        self.selectedColor = [UIColor whiteColor];

        [self constructionSubviews];
    }
    return self;
}

-(void)constructionSubviews{
    // 创建底部滑块
    self.underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / self.titles.count, self.frame.size.height)];
    [self addSubview:self.underLine];
    self.underLine.backgroundColor = self.selectedColor;
    // 创建所有按钮
    NSInteger count = self.titles.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        CGFloat x = i * self.frame.size.width / count;
        CGFloat y = 0;
        CGFloat w = self.frame.size.width / count;
        CGFloat h = self.frame.size.height;
        button.frame = CGRectMake(x, y, w, h);
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setAdjustsImageWhenHighlighted:NO];
        // 添加到数组中
        [self.allButtons addObject:button];
    }
}
- (void)buttonClick:(UIButton *)button {
    [self.selecedButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
    self.selecedButton = button;
    CGFloat offsetx = (button.tag - 10) * (self.frame.size.width) / self.titles.count;
    [self setContentOffset:(CGPoint){offsetx, 0}];
    
    NSInteger selectIndex = button.tag - 10;
    //block
    if (self.clickButtonBlock) {
        self.clickButtonBlock(selectIndex);
    }
}

-(void)setContentOffset:(CGPoint)contentOffset{
    // 改变底部滑块的x值
    CGRect frame = self.underLine.frame;
    frame.origin.x = contentOffset.x;
    self.underLine.frame = frame;
    
    // 重新设置选中的button
    NSInteger selecedButtonTag = (10 + self.underLine.center.x / (self.frame.size.width / self.titles.count));
    self.selecedButton = [self viewWithTag:selecedButtonTag];
}

@end

//
//  ShowingFuncTypeView.m
//  sisitv_ios
//
//  Created by ming on 17/12/18.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ShowingFuncTypeView.h"

@interface ShowingFuncTypeView()
@property(nonatomic, strong) UIView *indicaView;
@property(nonatomic, weak) UIButton *lastBtn;
@end

@implementation ShowingFuncTypeView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.indicaView.width = 25;
    self.indicaView.height = 3;
    self.indicaView.backgroundColor = [UIColor redColor];
    self.indicaView.y = self.height - self.indicaView.height;
    [self addSubview:self.indicaView];
    
    NSArray *titileArray = @[@"图片",@"直播",@"拍摄"];
    CGFloat btnW = KScreenWidth/3;
    CGFloat btnH = self.height;
    
    for (int i = 0; i < titileArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.x = btnW * i;
        button.y = 0;
        button.width = btnW;
        button.height = btnH;
        [button addTarget:self action:@selector(selectedFunc:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitle:titileArray[i] forState:UIControlStateNormal];
        button.tag = i+1;
        if (i == 1) {
            self.indicaView.yzgCenterX = button.yzgCenterX;
            [self selectedFunc:button];
            
        }
        [self addSubview:button];
        
    }
    
    
    
}


- (void)selectedFunc:(UIButton *)btn{
    
  
   
    if (btn.tag == 2) {
         btn.selected = YES;
        self.indicaView.yzgCenterX = btn.yzgCenterX;
    }
    if (_selectedCallBack) {
        
        _selectedCallBack(btn);
        
    }
    _lastBtn = btn;
    
}

- (UIView *)indicaView{
    
    if (_indicaView == nil) {
        _indicaView = [[UIView alloc] init];
    }
    
    return _indicaView;
}


@end

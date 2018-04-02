//
//  MMHeaderView.m
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MMHeaderView.h"
#import "CostRowItem.h"

@interface MMHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *money100Btn;
@property (weak, nonatomic) IBOutlet UIButton *money200Btn;
@property (weak, nonatomic) IBOutlet UIButton *money300Btn;
@property (strong, nonatomic) NSArray *btnArray;
@end

@implementation MMHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.btnArray = @[self.money100Btn,self.money200Btn,self.money300Btn];
    for (UIButton *button in self.btnArray) {
        button.layer.cornerRadius = 34/2;
        button.clipsToBounds = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [button addTarget:self action:@selector(moneyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.productArray = [[NSMutableArray alloc] init];
}

- (void)moneyBtnAction:(UIButton *)btn{
    for (UIButton *button in self.btnArray) {
        if (button.tag == btn.tag) {
            button.backgroundColor = rgba(221, 207, 252, 1);
        }else{
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    if (self.productArray.count == 0) {
        return;
    }
    if (_moneyValue) {
        CostRowItem *product = self.productArray[btn.tag];
        _moneyValue(product);
    }
}

-(void)setProductArray:(NSMutableArray *)productArray{
    _productArray = productArray;
    NSInteger index = 0;
    for (CostRowItem *product in _productArray) {
        UIButton *btn = self.btnArray[index];
        [btn setTitle:product.diamond_num forState:UIControlStateNormal];
        btn.hidden = NO;
        index++;
    }
}

@end

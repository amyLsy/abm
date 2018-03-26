//
//  ChatAdministratorView.m
//  sisitv_ios
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatAdministratorView.h"
#import <FDStackView/FDStackView.h>
@implementation ChatAdministratorView

+(instancetype)administratorView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];

    FDStackView *buttonStackView =  [[FDStackView alloc] init];
    [self addSubview:buttonStackView];
    [buttonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    buttonStackView.axis = UILayoutConstraintAxisVertical;
    buttonStackView.alignment = UIStackViewAlignmentFill;
    buttonStackView.distribution = UIStackViewDistributionFillEqually;
    buttonStackView.spacing = 10;
    NSArray *buttonArray = @[@"中断直播",@"封禁主播",@"设置热门"];
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        UIButton *adminButton = [UIButton buttonWithType:UIButtonTypeCustom];
        adminButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        adminButton.tag = i;
        [adminButton addTarget:self action:@selector(adminButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = buttonArray[i];
        [adminButton setTitle:title forState:UIControlStateNormal];
        [buttonStackView addArrangedSubview:adminButton];
    }
}

- (void)adminButtonClick:(UIButton *)button {
    if (button.tag == 0) {
        self.clickInterrupt();
    }else if (button.tag == 1){
        self.clickBlock();
    }else if (button.tag == 2){
        self.clickHot();
    }
}

@end

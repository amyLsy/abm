//
//  MMRechargeFooterView.m
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MMRechargeFooterView.h"
#import "UIImage+Image.h"
#import "UIImage+lg_image.h"

@interface MMRechargeFooterView()
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation MMRechargeFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UIImage *image = self.rechargeBtn.currentBackgroundImage;
    
//    CGFloat w = image.size.width * 0.5;
//    CGFloat h = image.size.height;
//    UIEdgeInsets insets = UIEdgeInsetsMake(w, h, w, h);
//    [image resizableImageWithCapInsets:insets];
    
//    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
//    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [_rechargeBtn setBackgroundImage:[UIImage imageNamed:@"login_bt_press"] forState:UIControlStateSelected];
    [_rechargeBtn setBackgroundImage:[UIImage imageNamed:@"login_bt_normal"] forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(rechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rechargeBtnAction {
    if (_btnAction) {
        _btnAction();
    }
}
@end

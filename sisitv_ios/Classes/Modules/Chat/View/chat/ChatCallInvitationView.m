//
//  PlayerLianMaiInvitationView.m
//  sisitv_ios
//
//  Created by apple on 17/1/13.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatCallInvitationView.h"

@implementation ChatCallInvitationView

+(instancetype)invitationView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    if (self.clickCancelButton) {
        self.clickCancelButton();
    }
    [self removeFromSuperview];
}
- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.clickConfirmButton) {
        self.clickConfirmButton();
    }
    [self removeFromSuperview];
}

@end

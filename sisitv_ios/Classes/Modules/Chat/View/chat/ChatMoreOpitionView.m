//
//  ChatMoreOpitionView.m
//  sisitv_ios
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatMoreOpitionView.h"

@interface ChatMoreOpitionView ()
@property (weak, nonatomic) IBOutlet UIButton *camera;
@property (weak, nonatomic) IBOutlet UIButton *torch;
@property (weak, nonatomic) IBOutlet UIButton *beauty;
@property (weak, nonatomic) IBOutlet UIButton *myGuards;
@property (weak, nonatomic) IBOutlet UIButton *bgmButton;

@end

@implementation ChatMoreOpitionView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
    [self addGestureRecognizer:tap];
}

-(void)remove{
    [self removeFromSuperview];
    [self.delegate chatMoreOpitionView:self didClickButton:nil buttonType:ChatMoreOpitionClose];
}

+(instancetype)moreOpitionView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
- (IBAction)clickButton:(UIButton *)button {
    [self.delegate chatMoreOpitionView:self didClickButton:button buttonType:button.tag];
    [self removeFromSuperview];
}

@end

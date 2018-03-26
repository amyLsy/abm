//
//  ChatChangeVoiceView.m
//  sisitv_ios
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatChangeVoiceView.h"

@interface ChatChangeVoiceView ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ChatChangeVoiceView

+(instancetype)chatChangeVoiceView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchDown];
}
- (IBAction)changeSliderValue:(UISlider *)sender {
    self.changeVoice(sender.value);
}

-(void)remove{
    [self removeFromSuperview];
}
@end

//
//  ChatBottomView.m
//  liveFrame
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatBottomView.h"

@interface ChatBottomView ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UIButton *private;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIButton *bgm;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIButton *gift;
@property (weak, nonatomic) IBOutlet UIImageView *unReadMessage;
@property (weak, nonatomic) IBOutlet UIButton *show;

@end

@implementation ChatBottomView


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

-(void)bgmPlayerIsPlying:(BOOL)isPlying{
    if (isPlying){
        self.bgm.selected = YES;
    }else{
        self.bgm.selected = NO;
    }
    
 }

-(void)hadUnReadMessage:(BOOL)unReadMessage{
    self.unReadMessage.hidden = !unReadMessage;
}
- (IBAction)gameButtonClick:(UIButton *)sender
{
    [self.delegate chatBottomView:self didClickGameButton:sender];
}

- (IBAction)giftButtonClick:(UIButton *)sender
{
    [self.delegate chatBottomView:self didClickGiftButton:sender];
}

- (IBAction)moreOpitionButtonButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.clickMoreOpition) {
        self.clickMoreOpition();
    }
}

- (IBAction)closeButtonClick{
    if (self.clickClose) {
        self.clickClose();
    }
}

- (IBAction)shareButtonClick:(UIButton *)sender
{
    if (self.clickShare)
    {
        self.clickShare();
    }
}

- (IBAction)privateListButtonClick {
    if (self.clickConversionList)
    {
        self.clickConversionList();
    }
}

- (IBAction)messageButtonClick
{
    if (self.clickMessage)
    {
        self.clickMessage();
    }
}

- (IBAction)show:(id)sender {
    if (self.clickShow) {
        
        self.clickShow();
    }
}



- (IBAction)bgmButtonClick:(UIButton *)sender {
//    [self.delegate chatBottomView:self  didClickBgmButton:sender];
}

-(void)dealloc
{
    YZGLog(@"%@",self);
}

@end

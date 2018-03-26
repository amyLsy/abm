//
//  ChatSendMessageView.m
//  xiuPai
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatSendMessageView.h"

@interface ChatSendMessageView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *broadcast;
@property (weak, nonatomic) IBOutlet UIButton *sendMessage;

@end

@implementation ChatSendMessageView

+(instancetype)chatSendMessageView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.messsageText.returnKeyType = UIReturnKeySend;
    self.messsageText.autocapitalizationType  = UITextAutocapitalizationTypeNone;
    self.messsageText.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButtonClick:self.sendMessage];
    return YES;
}


- (IBAction)broadcastButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        //sender.backgroundColor = kNavColor;
        [sender setBackgroundImage:[UIImage imageNamed:@"toggle_danmu_on"] forState:UIControlStateNormal];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"toggle_danmu_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)sendButtonClick:(UIButton *)sender
{
    if (self.messsageText.text.length == 0) return;
    self.sendMesssage(self.messsageText.text,self.broadcast.isSelected);
    [self resignInputTextFliedFirstResponder];
}

-(void)textFieldShow:(NSNotification *)noti
{
    CGRect begin = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat move = end.origin.y - begin.origin.y;
    [self.delegate chatSendMessageView:self inputTextFieldMoveDistance:move];
}

-(void)textFieldHidden:(NSNotification *)noti
{
    CGRect begin = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat move = end.origin.y - begin.origin.y;
    [self.delegate chatSendMessageView:self inputTextFieldMoveDistance:move];
    [self removeFromSuperview];
}

-(void)appResignActive{
    [self resignInputTextFliedFirstResponder];
}

-(void)resignInputTextFliedFirstResponder
{
//    [self.messsageText resignFirstResponder];
    self.messsageText.text = nil;
}

-(void)keyBoardAnimationDuration:(CGFloat)duration animationMove:(CGFloat)move{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(move);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)dealloc
{
    YZGLog(@"%@",self);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

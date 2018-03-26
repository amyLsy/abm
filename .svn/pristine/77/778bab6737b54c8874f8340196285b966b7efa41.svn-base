//
//  LGBottonCommentView.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/26.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGBottonCommentView.h"

@implementation LGBottonCommentView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.viewBottomMargin.constant = -150;
    [self.commentTexf becomeFirstResponder];
    [self layoutIfNeeded];
}

- (IBAction)submitAtion:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(submitComment:)]) {
        [self.delegate submitComment:self];
    }
}



- (void)textViewFrameChange:(NSNotification *)noti{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    CGFloat offset = self.height - rect.origin.y;
    
    self.viewBottomMargin.constant = offset;
    
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self layoutIfNeeded];
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.commentTexf resignFirstResponder];
   
    [self removeFromSuperview];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

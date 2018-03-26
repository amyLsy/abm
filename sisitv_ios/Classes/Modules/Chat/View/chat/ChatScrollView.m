//
//  ChatScrollView.m
//  sisitv_ios
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatScrollView.h"

@implementation ChatScrollView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    BOOL isChangeVoiceView = [result isKindOfClass:NSClassFromString(@"ChatChangeVoiceView")];
    BOOL isChatScrollView = [result  isKindOfClass:[UISlider class]];

    if (isChatScrollView||isChangeVoiceView)
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    return result;
}

@end

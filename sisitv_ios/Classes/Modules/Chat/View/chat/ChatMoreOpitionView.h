//
//  ChatMoreOpitionView.h
//  sisitv_ios
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewUtilits.h"

@class ChatMoreOpitionView;
@protocol ChatMoreOpitionViewDelegate <NSObject>

-(void)chatMoreOpitionView:(ChatMoreOpitionView *)moreOpitionView didClickButton:(UIButton *)button buttonType:(ChatMoreOpitionViewType)opitionViewType;

@end

@interface ChatMoreOpitionView : UIView

@property (nonatomic , weak) id<ChatMoreOpitionViewDelegate> delegate;

+(instancetype)moreOpitionView;

@end

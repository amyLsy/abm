//
//  ChatSendMessageView.h
//  xiuPai
//
//  Created by apple on 16/11/10.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatSendMessageView;

@protocol ChatSendMessageViewDelegate <NSObject>

-(void)chatSendMessageView:(ChatSendMessageView *)chatSendMessageView inputTextFieldMoveDistance:(CGFloat)distance;

@end

@interface ChatSendMessageView : UIView

/**输入框*/
@property (weak, nonatomic) IBOutlet UITextField *messsageText;
/**回调,返回输入框内容*/
@property (nonatomic , copy) void (^sendMesssage)(NSString *messageString , BOOL isBroadcast);

@property (nonatomic , weak) id<ChatSendMessageViewDelegate> delegate;

+(instancetype)chatSendMessageView;

@end

//
//  ChatConversationView.h
//  sisitv_ios
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickUser)(NSString *userId);

@class ChatMessage;

@interface ChatConversationView : UIView

-(void)clearChatConversionData;

-(void)startShowMessage:(ChatMessage *)chatMessage;

@property (nonatomic , copy) ClickUser clickUser;


@end

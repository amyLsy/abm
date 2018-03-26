//
//  SisiConversationListController.h
//  cooluck
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 JLXX-YZG. All rights reserved.
//

#import <ChatKit/LCCKConversationListViewController.h>


@interface SisiConversationListController : LCCKConversationListViewController

@property (nonatomic , assign) BOOL needLeftBackButon;

@property (nonatomic , copy) void(^yzgDismissToPresenting)(void);

@end

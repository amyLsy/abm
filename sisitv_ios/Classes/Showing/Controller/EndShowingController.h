//
//  EndShowingController.h
//  sisitv
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatViewUtilits.h"

@class RoomInfo;
@interface EndShowingController : BaseViewController

@property (nonatomic , strong) RoomInfo *roomInfo;

//错误信息
@property (nonatomic , copy) NSString *errorInfo;


-(instancetype)initWithChatViewStyle:(ChatViewStyle)chatViewStyle withController:(UIViewController *)fromViewController;

@end

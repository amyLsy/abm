//
//  ShowingController.h
//  liveFrame
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowControl.h"
@interface ShowingController : BaseViewController
@property (nonatomic , strong) ShowControl *showControl;
@property (nonatomic , assign) BOOL isLive;
@property (nonatomic , weak) UIView *typeView;
-(void)cleanShowControl;
- (void)beginStartShow;
@end

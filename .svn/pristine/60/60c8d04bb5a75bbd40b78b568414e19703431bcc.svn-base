//
//  YZGInputAlertController.h
//  xiuPai
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//
#import "BaseViewController.h"

@class  RoomInfo ;

typedef void(^ChatAlertSetGuardCallBack)(void);

@interface ChatAlertController : BaseViewController

/**
 点击头像,弹出infomationView时候所需要的id
 */
@property (nonatomic , copy) NSString *ID;
/**
 是否是房管
 */
@property (nonatomic , copy) NSString *guardStatus;
/**
 *点击关注按钮的回调
 */
@property (nonatomic , copy) void(^atentionClick)();
/**
 设置场控
 */
@property (nonatomic , copy) ChatAlertSetGuardCallBack setGuardCallBack;

/**
 点击连麦选项
 */
@property (nonatomic , copy) void(^startLianMai)();

-(instancetype)initWithRoomInfo:(RoomInfo *)roomInfo;

@end

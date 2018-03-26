//
//  ChatAlertManagerView.h
//  sisitv_ios
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewUtilits.h"

@class ChatAlertManagerView;

@protocol ChatAlertManagerViewDelegate <NSObject>

-(void)chatAlertManagerView:(ChatAlertManagerView *)managerView clickManagerButtonType:(ChatAlertManagerType)managerButtonType;

@end

@interface ChatAlertManagerView : UIView

@property (nonatomic , weak) id<ChatAlertManagerViewDelegate> delegate;

+(instancetype)managerView;

@property (nonatomic , strong) NSArray *managerButtonArray;

@end

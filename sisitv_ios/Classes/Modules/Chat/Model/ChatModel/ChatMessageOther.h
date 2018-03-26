//
//  ChatMessageOther.h
//  sisitv
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftInfo.h"

@interface ChatMessageOther : NSObject

+(instancetype)other;

@property (nonatomic , strong) GiftInfo *giftInfo;
/**
 主播所赚的钱
 */
@property (nonatomic , copy) NSString *totalEarn;

@end

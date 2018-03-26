//
//  GiftCache.h
//  sisitv
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGSingleton.h"

@interface GiftCache : YZGSingleton

/**
 * 连送的礼物个数
 */
@property (nonatomic , copy) NSString *countOfGift;

/**
 * 上一个发送的礼物消息
 */
@property (nonatomic , copy) NSString *lastChatMessageIdentifie;

/**
 * 连送的最大间隔时间
 */
@property (nonatomic , assign) NSInteger timeOfInterval;

-(void)startTimner;

-(void)stopTimner;

@end

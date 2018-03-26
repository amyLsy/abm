//
//  ChatGiftView.h
//  liveFrame
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GiftInfo;

typedef void(^ChatGiftListSendedGift)(GiftInfo* giftInfo);
typedef void(^DidClickChongZhi)(void);
typedef void(^ChatGiftListViewClose)(void);


@interface ChatGiftListView : UIView
@property (nonatomic , copy) ChatGiftListSendedGift didSendedGift;
@property (nonatomic , copy) DidClickChongZhi clickChongZhi;
@property (nonatomic , copy) ChatGiftListViewClose removeGiftListView;

+(instancetype)giftListView;


-(void)giftSendSuccess:(BOOL)success;

@end

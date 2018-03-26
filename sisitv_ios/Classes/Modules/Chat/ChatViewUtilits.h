//
//  ChatViewUtilits.h
//  liveFrame
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef ChatViewUtilits_h
#define ChatViewUtilits_h


typedef NS_ENUM(NSInteger,ChatViewStyle) {
    ChatViewStyleHost = 0,
    ChatViewStyleAudience
};


typedef NS_ENUM(NSUInteger, ChatAlertInfomationType) {
    ChatAlertInfomationAttentionOrCancel,
    ChatAlertInfomationPrivate,
    ChatAlertInfomationManager,
    ChatAlertInfomationClose
};

typedef NS_ENUM(NSUInteger, ChatAlertManagerType) {
    ChatAlertManagerReport = 1,
    ChatAlertManagerBlackList,
    ChatAlertManagerForbidden,
    ChatAlertManagerSetGuard,
    ChatAlertManagerLianMai
};

typedef NS_ENUM(NSUInteger, ChatAdministratorType) {
    ChatAdministratorInterrupt = 1,
    ChatAdministratorBlock,
    ChatAdministratorHot
};

typedef NS_ENUM(NSUInteger, ChatViewTouchEventType) {
    ChatViewEventClickAttentionHost,
    ChatViewEventClickCancelLianMai,
    ChatViewEventClickChongZhi,
    ChatViewEventClickShare,
    ChatViewEventClickClose,
    ChatViewEventClickConversationList,
    ChatViewEventClickZan,
    ChatViewEventClickPlayBgm,
    ChatViewEventClickStopBgm,
    ChatViewEventClickActivity,
    ChatViewEventClickShow,
    ChatViewEventClickLianMai,
    ChatViewEventClickList,
    ChatViewEventClickGift
};

typedef NS_ENUM(NSUInteger, ChatMoreOpitionViewType) {
    ChatMoreOpitionClose,
    ChatMoreOpitionChangeCamera = 1,
    ChatMoreOpitionChangeTorch,
    ChatMoreOpitionChangeBeauty,
    ChatMoreOpitionMyGuards,
    ChatMoreOpitionBgmMusic,
};


#endif /* ButtonAndLabelType_h */

//
//  YZGPay.h
//  sisitv
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayParam.h"
typedef NS_ENUM(NSUInteger, PayPlatForm) {
    WeChatPayPlat,
    AliPayPlat,
    ApplePayPlat,
};

typedef void(^PayCallBack)(BOOL isSuccess,NSString *errString);

FOUNDATION_EXPORT NSString *const kBuyProductEnd;


@interface YZGPay : NSObject

@property (nonatomic , assign) BOOL notCrash;

+(instancetype)shareInstance;


-(void)payWithPlatForm:(PayPlatForm)platForm withParam:(PayParam *)param;

-(BOOL)handleOpenURL:(NSURL *)url;

@end

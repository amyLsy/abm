//
//  ThirdLoginService.h
//  sisitv_ios
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>



@class ShareParam;
@interface ThirdLoginService : NSObject

+(instancetype)sharedInstance;

-(BOOL)wechatLogin:(void(^)(BOOL success, ShareParam *reqParam))userParam;
@end

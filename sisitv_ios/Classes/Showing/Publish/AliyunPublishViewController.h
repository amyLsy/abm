//
//  AliyunPublishViewController.h
//  qusdk
//
//  Created by Worthy on 2017/11/7.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDKPro/AliyunVideoSDKPro.h>
#else
#import "AliyunMediator.h"
#import "AliyunMediaConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoCropParam.h"
#endif

#define DEBUG_TEST 0
#import "AliyunIConfig.h"

@interface AliyunPublishViewController : UIViewController
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSString *taskPath;
@property (nonatomic, strong) AliyunIConfig *config;
@property (nonatomic, assign) CGSize outputSize;
@end

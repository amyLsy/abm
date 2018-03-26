//
//  OAuthViewController.h
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@class ADItem;

@interface ADController : BaseViewController

@property (nonatomic , strong) ADItem *adItem;

-(instancetype)initWithTimeInterval:(NSTimeInterval)ti disappearHandler:(void(^)(void))disappearHandler;

@end

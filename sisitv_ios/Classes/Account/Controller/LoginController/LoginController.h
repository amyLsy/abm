//
//  LoginController.h
//  liveFrame
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginController : BaseViewController 

-(instancetype)initWithSuccessLogin:(void(^)(void))successLogin;

@end
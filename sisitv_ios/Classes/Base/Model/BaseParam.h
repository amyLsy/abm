//
//  BaseParam.h
//  sisitv
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
typedef void(^requestSuccess) (BOOL isSuccess,id result );

@interface BaseParam : NSObject
@property (nonatomic , copy) NSString *os;
@property (nonatomic , copy) NSString *soft_ver;
@property (nonatomic , copy) NSString *ID;
@property (nonatomic , copy) NSString *token;

/**
 1:用户名或主播ID
*/
@property (nonatomic , copy) NSString *keyword;

-(instancetype)initWithUserId:(NSString *)userId;

@end

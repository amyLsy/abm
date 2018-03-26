//
//  MainListParam.h
//  sisitv_ios
//
//  Created by apple on 17/2/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGListParam.h"

@interface MainListParam : YZGListParam
/**
 类型：1:获取直播间时type(默认1热门，2最新）
      2:超管时type(断流中断直播1000、封禁2000、推热门3000、取消热门4000)
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , copy) NSString *location;

/**
 type为2(最新)时的话题类型(根据getChannelTermList返回的数据 1:所有,其它待定)
 */
@property (nonatomic , copy) NSString *term_id;


@property (nonatomic , copy) NSString *sortby;

@end

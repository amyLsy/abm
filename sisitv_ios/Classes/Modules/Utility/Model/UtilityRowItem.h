//
//  UtilityRowItem.h
//  xiuPai
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGTableViewRowItem.h"

@interface UtilityRowItem : YZGTableViewRowItem

@property (nonatomic , copy) NSString *is_truename;
/**签名*/
@property (nonatomic , copy) NSString *signature;
/**直播状态*/
@property (nonatomic , copy) NSString *channel_status;
 
@end

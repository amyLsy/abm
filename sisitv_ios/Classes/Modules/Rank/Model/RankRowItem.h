//
//  ContributionInfo.h
//  
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseItem.h"

@interface RankRowItem : BaseItem

@property (nonatomic , copy) NSString *send_num;

@property (nonatomic , copy) NSString *receive_num;

@property (nonatomic , copy) NSString *money_num;

@property (nonatomic , copy) NSString *correct_num;//智者榜排行

/**系统全局收益榜或贡献打赏榜*/
@property (nonatomic , copy) NSString *type;


@end

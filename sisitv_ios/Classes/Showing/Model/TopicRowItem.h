//
//  ShowingTopicRowItem.h
//  sisitv_ios
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionRowItem.h"

@interface TopicRowItem : YZGCollectionRowItem
/**
 tag id
 */
@property (nonatomic , copy) NSString *term_id;
@property (nonatomic , copy) NSString *id;

/**
 tag name
 */
@property (nonatomic , copy) NSString *name;

@property (nonatomic , assign) BOOL selected;

@end

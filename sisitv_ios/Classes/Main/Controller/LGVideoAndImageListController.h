//
//  LGVideoAndImageListController.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGRefreshCollectionController.h"

@interface LGVideoAndImageListController : YZGRefreshCollectionController
- (instancetype)initWithVcType:(NSInteger)vcType;

@property(nonatomic,assign) BOOL isMe;

@end

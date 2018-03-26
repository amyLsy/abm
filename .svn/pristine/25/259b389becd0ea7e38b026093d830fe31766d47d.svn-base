//
//  LGHotDataSource.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/8.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//


#import "YZGCollectionDataSource.h"
@class HotTopTypeCell;

@protocol LGHotDataSourceHeadViewDelegate


- (void)headViewAtionWithType:(NSInteger)actionType headView:(HotTopTypeCell *)headView;
-(void)tableViewCell:(HotTopTypeCell *)headView tapBanner:(BannerRowItem *)banner;

@end

@interface LGHotDataSource : YZGCollectionDataSource

@property(nonatomic,weak) id<LGHotDataSourceHeadViewDelegate>headViewDelegate;

@end


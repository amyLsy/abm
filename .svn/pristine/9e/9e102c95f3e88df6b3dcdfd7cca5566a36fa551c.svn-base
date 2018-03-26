//
//  MainScrollView.h
//  liveFrame
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseScrollView.h"
@class ShowingModel,RoomInfo;

typedef  void(^scrollViewCurrentIndex)( NSInteger index);


typedef  void(^clickPlayButton)(RoomInfo * roomInfo);

typedef void (^OffsetX)(CGFloat offestX);

@interface MainScrollView : BaseScrollView

@property (nonatomic , strong) NSArray *channeArray;

@property (nonatomic , copy) scrollViewCurrentIndex currentIndex;

@property (nonatomic , copy) clickPlayButton playButtonClick;

@property (nonatomic , copy) OffsetX xOffest;

-(void)scrollToTableViewWithTag:(NSInteger )tag;

@end

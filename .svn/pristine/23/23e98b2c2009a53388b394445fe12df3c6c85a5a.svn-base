//
//  LGPlayScrollView.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/12.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGVideoPlayCell.h"


@class LGPlayScrollView;

@protocol LGPlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(LGPlayScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;

@end



@interface LGPlayScrollView : UIScrollView

@property (nonatomic, assign) id<LGPlayerScrollViewDelegate> playerDelegate;
@property (nonatomic, strong) LGVideoPlayCell *upperImageView, *middleImageView, *downImageView;
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;



@end

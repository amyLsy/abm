//
//  PageContentView.h
//  sisitv_ios
//
//  Created by Apple on 17/4/13.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController, MainViewController, PageContentView;

@protocol PageContentViewDelegate <NSObject>

@optional

-(void)pageContentViewWithContentView:(PageContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
-(void)pageContentViewWithContentView:(PageContentView *)contentView index:(NSInteger)index;

@end


@interface PageContentView : UIView

@property (nonatomic , weak) id<PageContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSMutableArray *)childVcs parentViewController:(MainViewController *)parentViewController;

- (void)setCurrentIndex:(NSInteger)currentIndex;

@end

//
//  PageTitleView.h
//  sisitv_ios
//
//  Created by Apple on 17/4/13.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageTitleView;

@protocol PageTitleViewDelegate <NSObject>

@optional

-(void)pageTitleViewWithTitleView:(PageTitleView *)PageTitleView selectedIndex:(NSInteger)index;

@end

@interface PageTitleView : UIView

@property (nonatomic , weak) id<PageTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

- (void)setTitleWithIndex:(NSInteger)index;

@end

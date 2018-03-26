//
//  MainScrollView.m
//  liveFrame
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MainScrollView.h"

@class ShowingModel;

@interface MainScrollView ()<UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger times;

@property (nonatomic , assign) CGFloat lastOffenst;

@end

@implementation MainScrollView

-(instancetype)init
{
    if ( self = [super init])
    {            
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    CGFloat width = scrollView.frame.size.width;

    CGFloat offsetX = scrollView.contentOffset.x;

    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;

    // 传出当前的index
    if (self.currentIndex)
    {
        self.currentIndex(index);
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollToTableViewWithTag:(NSInteger)tag
{
    CGPoint point = CGPointMake(self.width * tag, 1);
    
    [self setContentOffset:point animated:YES];
}

@end

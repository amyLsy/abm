//
//  TabBarButton.m
//  JLZhiBo
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TabBarButton.h"

#import "BadgeViewButton.h"


#define kTabBarButtonNormalColor [UIColor grayColor]
#define kTabBarButtonSelectedColor kNavColor

#define ImageRidio 0.7

@interface TabBarButton ()

@property (nonatomic , weak) BadgeViewButton *badgeViewButton;

@end

@implementation TabBarButton

// 重写setHighlighted，取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted{}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setTitleColor:kTabBarButtonNormalColor forState:UIControlStateNormal];
        [self setTitleColor:kTabBarButtonSelectedColor forState:UIControlStateSelected];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont(12);
    }
    return self;
}


-(BadgeViewButton *)badgeViewButton
{
    if (_badgeViewButton == nil) {
        BadgeViewButton *btn = [BadgeViewButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        _badgeViewButton = btn;
    }
    return _badgeViewButton;
}
-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self setTitle:_item.title forState:UIControlStateNormal];
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    // 设置badgeValue
    self.badgeViewButton.badgeValue = _item.badgeValue;
}
// 修改按钮内部子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    //1.imageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * ImageRidio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY -1;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    // 3.badgeView
    self.badgeViewButton.x = self.width - self.badgeViewButton.width - 10*KWidthScale;
    self.badgeViewButton.y = 0;
}



@end

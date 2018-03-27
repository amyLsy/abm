//
//  TabBar.m
//  JLZhiBo
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "YZGTabBar.h"
#import "BaseButton.h"
#import "TabBarButton.h"
#import "UIButton+MBHExpand.h"
//中心按钮向上偏移的高度
//#define MoveHeight 20

#define kCenterBackgroundImage [UIImage imageNamed:@"icon_xiangji1"]
#define kCenterHighlightedBackgroundImage [UIImage imageNamed:@"icon_xiangji2"]
#define kCenterImage [UIImage imageNamed:@"底部直播"]
#define kCenterHighlightedImage [UIImage imageNamed:@"底部直播"]

@interface YZGTabBar ()

@property (nonatomic , strong) UIButton *centerButton;
@property (nonatomic , strong) UIButton *czButton;
@property (nonatomic , strong) UIButton *dhButton;

@end

static YZGTabBar *tabBar = nil;


@implementation YZGTabBar

-(instancetype)init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)centerButtonClick
{
    if ([self.yzgDelegate respondsToSelector:@selector(yzgTabBar:didClickCenterButton:)])
    {
        [self.yzgDelegate yzgTabBar:self didClickCenterButton:_centerButton];
    }
}

-(void)czButtonClick
{
    if ([self.yzgDelegate respondsToSelector:@selector(yzgTabBar:didClickCzButton:)])
    {
        [self.yzgDelegate yzgTabBar:self didClickCzButton:_czButton];
    }
}

-(void)dhButtonClick
{
    if ([self.yzgDelegate respondsToSelector:@selector(yzgTabBar:didClickDhButton:)])
    {
        [self.yzgDelegate yzgTabBar:self didClickDhButton:_czButton];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];

//    int btnIndex = 0;
//    for (UIView *btn in self.subviews) {
        //遍历tabbar的子控件
        //btn是_UIBarBackground,则btn.superclass是UIView,排除.
        //btn是UITabBarButton则btn.superclass是UIControl,调整子控件位置，空出中间位置.
//        if ([btn.superclass isSubclassOfClass:[UIControl class]]) {
//            btn.width = self.width / 5;
//            btn.x = btn.width * btnIndex;
//            btnIndex += 1;
//            if (btnIndex==1) {
//                btnIndex += 3;
//            }
//        }
//    }
//    [self addSubview:self.dhButton];
//    [self addSubview:self.czButton];
    [self addSubview:self.centerButton];
    [self bringSubviewToFront:self.centerButton];
//    UIImage *image = [UIImage imageNamed:@"menu_commence"];
    
//    self.centerButton.width = image.size.width * 0.7;
//     self.centerButton.height = image.size.height * 0.7;
    self.centerButton.yzgCenterX = self.center.x;
    self.centerButton.yzgCenterY = self.height/2.0 - 12;
    
    CGFloat w = self.width / 5;
    self.dhButton.frame = (CGRect){1*w,0,w,self.height};
    [self setButtonContentCenter:self.dhButton];
    self.czButton.frame = (CGRect){3*w,0,w,self.height};
    [self setButtonContentCenter:self.czButton];
}

-(void)setButtonContentCenter:(UIButton *) btn
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(-heightSpace+9,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace-2, - imgViewSize.width, 0.0, 0.0);
    [btn setTitleEdgeInsets:titleEdge];
}

-(UIButton *)centerButton{
    if(!_centerButton){
        UIButton *centerButton = [[UIButton alloc] init];
        [centerButton setImage:[UIImage imageNamed:@"menu_commence"] forState:UIControlStateNormal];
        [centerButton setImage:[UIImage imageNamed:@"menu_commence"] forState:UIControlStateHighlighted];
        [centerButton setTitle:@"直播" forState:UIControlStateNormal];
        centerButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [centerButton setTitleColor:RGBToColor(140, 69, 222) forState:UIControlStateSelected];
        [centerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [centerButton sizeToFit];
        [centerButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
        [centerButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.centerButton = centerButton;
    }
    return _centerButton;
}

-(UIButton *)dhButton{
    if(!_czButton){
        UIButton *dhButton = [[UIButton alloc] init];
        [dhButton setImage:[UIImage imageNamed:@"menu_attention_normal"] forState:UIControlStateNormal];
        [dhButton setImage:[UIImage imageNamed:@"menu_attention_elect"] forState:UIControlStateHighlighted];
        [dhButton setTitle:@"关注" forState:(UIControlStateNormal)];
        
        [dhButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        dhButton.titleLabel.font = kFont(12);
        
        [dhButton addTarget:self action:@selector(dhButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.dhButton = dhButton;
    }
    return _dhButton;
}

-(UIButton *)czButton{
    if(!_czButton){
        UIButton *czButton = [[UIButton alloc] init];
        [czButton setImage:[UIImage imageNamed:@"menu_message_normal"] forState:UIControlStateNormal];
        [czButton setImage:[UIImage imageNamed:@"menu_message_elect"] forState:UIControlStateHighlighted];
        [czButton setTitle:@"消息" forState:(UIControlStateNormal)];
        
        [czButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [czButton setTitleColor:kNavColor forState:UIControlStateSelected];
//        czButton.imageView.contentMode = UIViewContentModeCenter;
//        czButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        czButton.titleLabel.font = kFont(12);
        
//        [czButton sizeToFit];
        [czButton addTarget:self action:@selector(czButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.czButton = czButton;
    }
    return _czButton;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden) {
        return [super hitTest:point withEvent:event];
    }else{
        CGRect plusButtonFrame = self.centerButton.frame;
        BOOL isInPlusButtonFrame = CGRectContainsPoint(plusButtonFrame, point);
        
        if (isInPlusButtonFrame){
            return self.centerButton;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
}

-(void)dealloc{
    YZGLog(@"%@",[self class]);
}

@end

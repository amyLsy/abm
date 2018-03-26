//
//  BaseTitleView.h
//  xiuPai
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Highlighted.h"

@interface BaseTitleView : UIView

@property (strong, nonatomic) NSArray<UIButton *> *buttonArray;

+(instancetype)titleViewFromXib;

//选中后的颜色
@property (nonatomic , strong) UIColor *selectedColor;

//传出当前选中的按钮的tag
@property (nonatomic , copy) void(^currentButtonIndex)(NSInteger tag);
//当前直播列表的标号，然后让标题按钮选到相应的tag上
-(void)selectedButtonWithIndex:(NSInteger )index;
@end

//
//  TitleView.h
//  JLZhiBo
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseTitleView.h"

@interface MainTitleView : BaseTitleView
//传出当前选中的按钮的tag
@property (nonatomic , copy) void(^search)();
//传出当前选中的按钮的tag
@property (nonatomic , copy) void(^rank)();
@end

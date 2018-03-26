//
//  ShowingFuncTypeView.h
//  sisitv_ios
//
//  Created by ming on 17/12/18.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLSelectFunc) (UIButton *btn);

@interface ShowingFuncTypeView : UIView

@property(nonatomic, copy) JLSelectFunc selectedCallBack;

@end

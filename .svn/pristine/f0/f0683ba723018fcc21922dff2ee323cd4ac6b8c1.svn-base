//
//  LGTermsTypeView.h
//  sisitv_ios
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGTermsTypeView,LGButtont;
@protocol LGTermsViewDelegate


- (void)termsViewAtionWithType:(LGButtont *)actionType headView:(LGTermsTypeView *)termsView;


@end


@interface LGTermsTypeView : UIView

@property(nonatomic,copy) NSArray *typeStrArray;
@property(nonatomic,weak) id<LGTermsViewDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *btns;
- (void)didClick:(LGButtont *)button;
- (void)defaultSelect;
@end

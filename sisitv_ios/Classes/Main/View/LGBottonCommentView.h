//
//  LGBottonCommentView.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/26.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMediaListModel.h"

@class LGBottonCommentView;
@protocol LGBottmCommentViewDelegate <NSObject>

- (void)submitComment:(LGBottonCommentView *)edtiorView;

@end

@interface LGBottonCommentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *commentTexf;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomMargin;
@property(nonatomic, weak) id <LGBottmCommentViewDelegate> delegate;
@property(nonatomic, strong) LGMediaListModel *mediaModel;

@end

//
//  LGShowAddView.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGShowAddView : UIView
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic ,copy) void(^submit)(LGShowAddView *view);
@property (nonatomic ,copy) void(^edit)(LGShowAddView *view);

@property (nonatomic ,copy) void(^cancel)(LGShowAddView *view);
@property (assign, nonatomic)  BOOL isEditor;
@end

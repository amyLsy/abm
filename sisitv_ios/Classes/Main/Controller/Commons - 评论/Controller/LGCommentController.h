//
//  LGCommentController.h
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"
#import "LGMediaListModel.h"
#import "LGButtont.h"
typedef void (^LGSubmitCaback)();
typedef void (^LGG2SubCommtCaback)();
typedef void (^LGCommentSuccess)();
@interface LGCommentController : LGBasiController
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) LGMediaListModel *model;
@property (nonatomic, copy) LGSubmitCaback submitCaback;
@property (nonatomic, copy) LGG2SubCommtCaback g2SubCommtCaback;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign)  NSInteger limit_end;
@property(nonatomic, weak) UIView *commentView;
@property(nonatomic, weak) LGButtont *commentSendButton;
@property(nonatomic, weak) UITextField *commentTextField;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) LGCommentSuccess commentSuccess;

-(void)sendComments:(LGButtont *)butn;
@end

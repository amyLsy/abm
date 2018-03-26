//
//  LGShareController.h
//  ifaxian
//
//  Created by ming on 16/12/1.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGBasiController.h"
#import "LGMediaListModel.h"
#import "LGCommentController.h"
#import "LGComment.h"
@interface LGShareController :LGCommentController
@property(nonatomic, strong) LGMediaListModel *model;
@property(nonatomic, strong) LGComment *commentModel;
@property(nonatomic, assign) BOOL isHeadView;
@end

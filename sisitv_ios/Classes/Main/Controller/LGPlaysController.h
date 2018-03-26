//
//  LGPlaysController.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/25.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseViewController.h"
#import "LGMediaListModel.h"

typedef void (^LGLoadData) (NSInteger index);
typedef void (^LGSetOffset) (NSInteger index);
@interface LGPlaysController : BaseViewController
@property(nonatomic,strong) LGMediaListModel *model;
@property(nonatomic,strong) NSMutableArray *videoListArray;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property (assign ,nonatomic) NSInteger viewType;
@property(nonatomic,copy) LGLoadData loadData;
@property(nonatomic,copy) LGSetOffset setOffset;

@end

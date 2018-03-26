//
//  LGShowListController.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGRefreshTableViewController.h"
typedef void(^Bcak) ();

@interface LGShowListController : YZGRefreshTableViewController

@property(nonatomic,copy) Bcak backFinish;

@end

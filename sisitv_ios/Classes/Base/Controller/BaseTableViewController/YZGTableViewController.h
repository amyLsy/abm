//
//  YZGTableViewController.h
//  sisitv
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BaseViewController.h"
#import "YZGTableView.h"

@class YZGTableViewDataSource;

@protocol YZGTableViewControllerDelegate <NSObject>

@required
- (void)createDataSource;

@end


@interface YZGTableViewController : BaseViewController<YZGTableViewDelegate,YZGTableViewControllerDelegate,YZGTableViewCellDelegate>

@property (nonatomic , strong) YZGTableView *tableView;
@property (nonatomic , strong) YZGTableViewDataSource *dataSource;

@end

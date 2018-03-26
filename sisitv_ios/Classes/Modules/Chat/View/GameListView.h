//
//  GameListView.h
//  sisitv_ios
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameListView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *userList;
@property (weak, nonatomic) IBOutlet UILabel *viewTitleLable;

@end

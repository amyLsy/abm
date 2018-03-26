//
//  LGDoOrderShowView.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/30.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGShowListModel;
typedef void (^UserDoOrderShow)(LGShowListModel *model, UIView *view);
typedef void (^UserDoShow)(NSString *itemId, UIView *view);
typedef void (^ShowSwitchCallback)(UISwitch *swith);
@interface LGDoOrderShowView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *showSwitch;
@property (copy, nonatomic)  NSString *uid;
@property (copy, nonatomic) UserDoOrderShow userDoOrderShowCallback;
//主播操作
@property (copy, nonatomic) UserDoShow userDohowCallback;
@property (copy, nonatomic) ShowSwitchCallback showSwitchCallback;
- (void)loadData;
- (void)refresh;
- (void)refreshDoShowList;
@end

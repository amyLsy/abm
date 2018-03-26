//
//  LGUserLianMaiListView.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/19.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
@class LGUserLianMaiListView;
@protocol LGUserLianMaiListViewDelegate

- (void)lianMaiView:(LGUserLianMaiListView *)lianMaiListView ationType:(NSInteger)type message:(ChatMessage *)message;

@end
@interface LGUserLianMaiListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userJoinArray;
@property (weak, nonatomic) id<LGUserLianMaiListViewDelegate> delegate;
@end

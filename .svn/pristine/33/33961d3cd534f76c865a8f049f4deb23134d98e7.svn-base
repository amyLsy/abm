//
//  LGBgmVIew.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGBgmCell.h"
@class LGBgmVIew;
typedef void(^LGBmgPlayCallBack)(NSString *url ,LGBgmCell *cell ,LGBgmVIew *bgmView ,NSArray *bgmDataArray ,NSIndexPath *indexPath);
@interface LGBgmVIew : UIView 
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) LGBmgPlayCallBack bgmPlayCallBack;
@end

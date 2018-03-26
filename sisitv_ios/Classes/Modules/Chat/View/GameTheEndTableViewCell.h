//
//  GameTheEndTableViewCell.h
//  sisitv_ios
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GameTheEndCloseBlock)();

@interface GameTheEndTableViewCell : UITableViewCell
{
    NSMutableArray *list;
}
@property (nonatomic, copy) GameTheEndCloseBlock gameTheEndCloseBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak,nonatomic) IBOutlet UITableView *tbView;
@property (weak,nonatomic) IBOutlet UILabel *tbText;
@property (nonatomic,strong) NSString *dictJson;
@property (nonatomic,strong) NSArray *userList;
@end

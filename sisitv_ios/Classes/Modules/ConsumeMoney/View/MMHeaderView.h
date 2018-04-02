//
//  MMHeaderView.h
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CostRowItem;
typedef void(^BackMoneyValue)(CostRowItem *moneyValue);

@interface MMHeaderView : UIView
@property (nonatomic, copy)BackMoneyValue moneyValue;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (weak, nonatomic) IBOutlet UILabel *meimeiValueLabel;

@end

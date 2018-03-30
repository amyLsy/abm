//
//  MMRechargeFooterView.h
//  sisitv_ios
//
//  Created by Luuu.SY on 2018/3/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RechargeBtnAction)(void);
@interface MMRechargeFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (copy, nonatomic) RechargeBtnAction btnAction;
@end

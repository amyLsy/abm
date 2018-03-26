//
//  HotTopTypeCell.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/5.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGTermsTypeView.h"
@class BannerRowItem;
typedef void(^LGSelectAtion)(NSInteger type);
typedef void(^LGBigOrSmallAtion)(NSInteger type);
typedef void(^LGTapBann)(BannerRowItem *bannerItem);
@interface HotTopTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bigOrSmallButton;
@property (copy, nonatomic) LGSelectAtion selectAtion;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (copy, nonatomic) LGBigOrSmallAtion bigOrSmallAtion;
@property (copy, nonatomic) LGTapBann tapBann;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet LGTermsTypeView *termaTypwView;
@property (weak, nonatomic) IBOutlet UIButton *samllButton;


-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath;
@end
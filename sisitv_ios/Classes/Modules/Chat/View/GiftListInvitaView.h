//
//  GiftListInvitaView.h
//  sisitv_ios
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSelectGameView.h"
typedef void(^JoinBlock)(BOOL isJoin);

@interface GiftListInvitaView : UIView

@property (weak, nonatomic) IBOutlet UIView *giftListBgView;
@property (strong, nonatomic) NSArray *dataArray;
@property (copy, nonatomic) JoinBlock joinBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property(nonatomic,strong) LGSelectGameView *giftListView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *joinbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelListViewButton;

@end

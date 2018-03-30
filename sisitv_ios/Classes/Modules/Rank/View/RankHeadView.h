//
//  RankHeadView.h
//  sisitv_ios
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGButtont.h"
#import "RankRowItem.h"

typedef void (^LGHeadCallback)(RankRowItem *item);
typedef void(^SwitchRankType)(NSString *type);
@interface RankHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *secondAvatar;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *secondInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondVIPImageView;


@property (weak, nonatomic) IBOutlet UIImageView *theThirdAvatar;
@property (weak, nonatomic) IBOutlet UILabel *theThirdName;
@property (weak, nonatomic) IBOutlet UILabel *theThirdInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theThirdVIPImageView;

@property (weak, nonatomic) IBOutlet UIImageView *firstAvatar;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstVIPImageView;




@property (weak, nonatomic) IBOutlet LGButtont *firstBgImageView;
@property (weak, nonatomic) IBOutlet LGButtont *thirdBgimageView;
@property (weak, nonatomic) IBOutlet LGButtont *secondBgImageView;

@property (strong, nonatomic) NSArray *nameLables;
@property (strong, nonatomic) NSArray *infoLables;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic)  NSArray *avatarImageViews;
@property (strong, nonatomic)  NSArray *bgStageImages;
@property (strong, nonatomic)  NSArray *vipImages;
@property (strong, nonatomic)  NSArray *crownImages;

@property (strong, nonatomic)  NSArray *sexs;
@property (strong, nonatomic)  NSArray *levels;

@property (copy, nonatomic) LGHeadCallback headCallback;
@property (copy, nonatomic) SwitchRankType switchRankType;


@end

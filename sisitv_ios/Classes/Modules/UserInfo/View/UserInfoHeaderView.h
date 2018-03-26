//
//  UserInfoHeaderView.h
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGHeaderView.h"

typedef NS_ENUM(NSUInteger, UserInfoHeaderViewButtonType) {
    UserInfoHeaderViewButtonBack = 1,
    UserInfoHeaderViewButtonLiving,
    UserInfoHeaderViewButtonFans,
    UserInfoHeaderViewButtonAttention,
    UserInfoHeaderViewButtonPrivate,
    MineHeaderViewButtonVideo,
    MineHeaderViewButtonPhoto,
};

@class UserInfoHeaderView;
@protocol UserInfoHeaderViewDelegate <NSObject>

@optional

-(void)headerView:(UserInfoHeaderView *)headerView didClickButton:(UserInfoHeaderViewButtonType)buttonType;

@end

@interface UserInfoHeaderView : YZGHeaderView
@property (nonatomic , weak) id<UserInfoHeaderViewDelegate> delegate;

@end

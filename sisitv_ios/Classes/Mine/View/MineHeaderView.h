//
//  YZGHeaderView.h
//  xiuPai
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGHeaderView.h"

typedef NS_ENUM(NSUInteger, MineHeaderViewButtonType) {
    MineHeaderViewButtonEdit = 1,
    MineHeaderViewButtonMessage,
    MineHeaderViewButtonFans,
    MineHeaderViewButtonAttention,
    MineHeaderViewButtonVideo,
    MineHeaderViewButtonPhoto,
    MineHeaderViewUploadImage,
};

@class MineHeaderView;
@protocol MineHeaderViewDelegate <NSObject>

@optional
-(void)headerView:(MineHeaderView *)headerView didClickButton:(MineHeaderViewButtonType)buttonType;

@end

@interface MineHeaderView : YZGHeaderView

@property (nonatomic , weak) id<MineHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *unreadMessage;
@property (weak, nonatomic) IBOutlet UIView *userBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@end

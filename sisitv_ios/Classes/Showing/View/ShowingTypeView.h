//
//  ShowingTypeView.h
//  sisitv_ios
//
//  Created by Apple on 17/1/5.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  直播类型
 */
typedef NS_ENUM(NSUInteger, ShowingType){
    /**
     *  关闭
     */
    ShowingTypeClose = 0 ,
    /**
     *  公开
     */
    ShowingTypePublic ,
    /**
     *  私播
     */
    ShowingTypePrivate ,
    /**
     *  付费
     */
    ShowingTypePay,
    /**
     *  密码
     */
    ShowingTypePassword,
    /**
     *  分钟收费
     */
    ShowingTypeMinuteCharge,
};
@protocol ShowingTypeDelegate <NSObject>

-(void)clickShowingTypeButton:(ShowingType)showingType;

@end

@interface ShowingTypeView : UIView

@property (nonatomic , weak) id<ShowingTypeDelegate> delegate;

+(instancetype)showingTypeView;

-(void)setShowingTypeButtons:(NSArray<NSString *> *)buttonArray;
@end

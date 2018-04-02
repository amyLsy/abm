//
//  ShareView.h
//  com.yxvzb.zhibozhushou
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGShareView;

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, ShareButtonType){
 
    /**
     *  微信好友
     */
    ShareButtonTypeWeChatSession = 1 ,
    /**
     *  朋友圈
     */
    ShareButtonTypeWechatTimeline ,
    /**
     *  qq
     */
    ShareButtonTypeQQ,
    /*
     *  QQ空间
     */
    ShareButtonTypeQZone,
};

@protocol YZGShareViewDelegate <NSObject>

-(void)yzgShareView:(YZGShareView *)shareView clickShareButtonType:(ShareButtonType)shareButtonType;

@end

@interface YZGShareView : UIView

@property (nonatomic , weak) id<YZGShareViewDelegate> delegate;

@property (nonatomic , strong) id object;

-(void)setShareButtons:(NSArray<NSString *> *)buttonArray;

+(instancetype)yzgShareView;

@end

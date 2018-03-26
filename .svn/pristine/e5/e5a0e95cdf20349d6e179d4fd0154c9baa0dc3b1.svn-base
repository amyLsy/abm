//
//  ChatBottomView.h
//  liveFrame
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMoreOpition)(void);
typedef void(^ClickClose)(void);
typedef void(^ClickShare)(void);
typedef void(^ClickMessage)(void);
typedef void(^ClickConversionList)(void);
typedef void(^ClickShow)(void);
@class ChatBottomView;

@protocol ChatBottomViewDelegate <NSObject>

-(void)chatBottomView:(ChatBottomView *) chatBottomView didClickGameButton:(UIButton *)giftButton;

-(void)chatBottomView:(ChatBottomView *) chatBottomView didClickGiftButton:(UIButton *)giftButton;

-(void)chatBottomView:(ChatBottomView *)chatBottomView didClickBgmButton:(UIButton *)bgmButton;
@end

@interface ChatBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *moreOption;

@property (nonatomic , weak) id<ChatBottomViewDelegate> delegate;

@property (nonatomic , copy) ClickMoreOpition clickMoreOpition;
@property (nonatomic , copy) ClickClose clickClose;
@property (nonatomic , copy) ClickShare clickShare;
@property (nonatomic , copy) ClickMessage clickMessage;
@property (nonatomic , copy) ClickConversionList clickConversionList;
@property (nonatomic , copy) ClickShow clickShow;

/**
 背景音乐是否正在播放

 @param isPlying 是否正在播放
 */
-(void)bgmPlayerIsPlying:(BOOL)isPlying;
-(void)hadUnReadMessage:(BOOL)unReadMessage;
@end

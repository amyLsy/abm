//
//  ChatFucView.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/16.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatFucView;
@protocol ChatFucViewDelegate <NSObject>

-(void)chatFucView:(ChatFucView *) chatFucView didClickGameButton:(UIButton *)gameButton;

-(void)chatFucView:(ChatFucView *) chatFucView didClickShowButton:(UIButton *)showButton;

-(void)chatFucView:(ChatFucView *)chatFucView didClicLianmaiButton:(UIButton *)lianmai;

-(void)chatFucView:(ChatFucView *)chatFucView didClickShowListButton:(UIButton *)listButton;

-(void)chatFucView:(ChatFucView *)chatFucView didClickShowGiftButn:(UIButton *)giftButn;
@end

@interface ChatFucView : UIView
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *lianmaiButton;
@property (weak, nonatomic) IBOutlet UIButton *lianMaiCountButton;
@property (weak, nonatomic) IBOutlet UIButton *gift;
@property (weak, nonatomic) IBOutlet UILabel *giftLable;

@property (nonatomic , weak) id<ChatFucViewDelegate> delegate;
@end


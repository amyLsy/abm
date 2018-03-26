//
//  ChatChangeVoiceView.h
//  sisitv_ios
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChatChangeVoiceClickChangeVoice)(float value);

@interface ChatChangeVoiceView : UIControl

@property (nonatomic , copy) ChatChangeVoiceClickChangeVoice changeVoice;

+(instancetype)chatChangeVoiceView;

@end

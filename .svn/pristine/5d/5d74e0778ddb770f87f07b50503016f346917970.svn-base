//
//  VideoPlayView.h
//  sisitv_ios
//
//  Created by 廖健 on 2017/11/27.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol videoPlayerDelegate <NSObject>

@optional
- (void)respondsToSelector:(SEL)selector;

@end

@interface VideoPlayView : UIView

@property (weak, nonatomic) id<videoPlayerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andURL:(NSURL *)url;

@end

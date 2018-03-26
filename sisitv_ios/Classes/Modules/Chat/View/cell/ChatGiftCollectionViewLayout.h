//
//  YZGCollectionViewTagLayout.h
//  sisitv_ios
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YZGGiftCollectionViewScrollDirection) {
    YZGGiftCollectionViewScrollVertical,
    YZGGiftCollectionViewScrollHorizontal
};

@interface ChatGiftCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) YZGGiftCollectionViewScrollDirection scrollDirection; // default is YZGTagCollectionViewScrollVertical

@property (nonatomic, assign) UIEdgeInsets contentInset; // Default = (2, 2, 2, 2)

@property (nonatomic, assign) CGFloat horizontalSpacing; // Default = 5

@property (nonatomic, assign) CGFloat verticalSpacing; // Default = 5

@property (nonatomic , assign) NSUInteger numberOfLines;

@end

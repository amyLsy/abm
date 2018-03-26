//
//  SearchBar.h
//  TongYouQuan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBar : UITextField

@property (nonatomic , copy) void(^clickSearchButton)();

@property (nonatomic , copy) NSString *placeholderString;
@end

//
//  LGUserMediaHeadView.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/1.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGUserMediaHeadView.h"

@implementation LGUserMediaHeadView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.focusUserButton.layer.cornerRadius = 3;
    self.focusUserButton.layer.masksToBounds = YES;
    self.isLiveBtton.layer.cornerRadius = 3;
    self.isLiveBtton.layer.masksToBounds = YES;
     
}




@end

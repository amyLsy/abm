


//
//  LGRightImageButton.m
//  tcjjios
//
//  Created by apple on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LGRightImageButton.h"

@implementation LGRightImageButton

- (void)layoutSubviews {
    [super layoutSubviews];
    

    
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    
    titleF.origin.x = 0;
    self.titleLabel.frame = titleF;
    
    imageF.origin.x = CGRectGetMaxX(titleF) + 5;
    self.imageView.frame = imageF;
}



@end

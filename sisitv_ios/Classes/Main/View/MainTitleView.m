//
//  TitleView.m
//  JLZhiBo
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainTitleView.h"
#import "UIButton+Highlighted.h"
@interface MainTitleView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotToPrebuttonMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicToPreButtonMargin;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *xibBttonArray;
@end

@implementation MainTitleView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.hotToPrebuttonMargin.constant =  self.hotToPrebuttonMargin.constant*KWidthScale;
    self.topicToPreButtonMargin.constant =  self.topicToPreButtonMargin.constant*KWidthScale;
    self.buttonArray = self.xibBttonArray;
}
- (IBAction)rankClick {
    self.rank();
}
- (IBAction)searchClick {
    self.search();
}
@end

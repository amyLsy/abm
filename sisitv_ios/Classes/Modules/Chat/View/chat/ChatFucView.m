

//
//  ChatFucView.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/16.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "ChatFucView.h"

@implementation ChatFucView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.lianMaiCountButton.layer.cornerRadius = 10;
    self.lianMaiCountButton.layer.masksToBounds = YES;
    
    
    
}

- (IBAction)showListAtion:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatFucView:didClickShowButton:)]) {
        
        [self.delegate chatFucView:self didClickShowListButton:sender];
    }
    
}

- (IBAction)showAtion:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(chatFucView:didClickShowButton:)]) {
        
        [self.delegate chatFucView:self didClickShowButton:sender];
    }
    
    
}
- (IBAction)gameAtion:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatFucView:didClickGameButton:)]) {
        
        [self.delegate chatFucView:self didClickGameButton:sender];
    }
}
- (IBAction)lianmaiAtion:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatFucView:didClicLianmaiButton:)]) {
        
        [self.delegate chatFucView:self didClicLianmaiButton:sender];
    }
    
}
- (IBAction)gift:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatFucView:didClickShowGiftButn:)]) {
        
        [self.delegate chatFucView:self didClickShowGiftButn:sender];
        
    }
    
}




@end


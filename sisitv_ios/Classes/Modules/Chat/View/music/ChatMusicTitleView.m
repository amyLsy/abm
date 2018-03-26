//
//  RankTitleView.m
//  xiuPai
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatMusicTitleView.h"

@interface ChatMusicTitleView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *xibButtonArray;

@end

@implementation ChatMusicTitleView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.buttonArray = self.xibButtonArray;
}

@end

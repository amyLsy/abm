//
//  ChatGiftCollectionViewCell.m
//  liveFrame
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatGiftCollectionViewCell.h"
#import "GiftInfo.h"

@interface ChatGiftCollectionViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diamondButtonToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diamondButtonHeight;

@property (weak, nonatomic) IBOutlet UIButton *diamondButton;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isContinuaImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftName;

@end


@implementation ChatGiftCollectionViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setLayout];
   
}

-(void)setLayout{
    
    self.giftImageViewWidth.constant = self.giftImageViewWidth.constant*KWidthScale;
    self.diamondButtonToTop.constant = self.diamondButtonToTop.constant*KHeightScale;
    self.diamondButtonHeight.constant = self.diamondButtonHeight.constant*KHeightScale;
}

-(void)setGiftInfo:(GiftInfo *)giftInfo{
    _giftInfo = giftInfo;
    
    [self.diamondButton setTitle:giftInfo.needcoin forState:UIControlStateNormal];
 
    [self adjustButtonWithString:giftInfo.needcoin];

    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftInfo.gifticon]];
    
    self.giftName.text = giftInfo.giftname;
    
    if (_giftInfo.selected) {
        self.isContinuaImageView.image = [UIImage imageNamed:@"icon_continue_gift_chosen"];
    }else{
        [self setContinuaImageView];
    }
}

-(void)setContinuaImageView{
    if (self.giftInfo.continuous.integerValue == 1) {
        self.isContinuaImageView.image = [UIImage imageNamed:@"icon_continue_gift"];
    }else{
        self.isContinuaImageView.image = nil;
    }
}

-(void)adjustButtonWithString:(NSString *)titleString{
    
   CGRect rect = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.diamondButton.titleLabel.font} context:nil];
    [self.diamondButton setImageEdgeInsets:UIEdgeInsetsMake(0,rect.size.width, 0, -rect.size.width)];
    [self.diamondButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-self.diamondButton.imageView.width, 0, self.diamondButton.imageView.width)];
}
@end

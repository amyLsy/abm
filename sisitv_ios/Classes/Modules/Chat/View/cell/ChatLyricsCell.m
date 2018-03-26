//
//  ChatLyricsCell.m
//  sisitv_ios
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatLyricsCell.h"
#import "YZGMusicItem.h"

@interface ChatLyricsCell ()

@property (weak, nonatomic) IBOutlet UILabel *lyric;

@end

@implementation ChatLyricsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.lyric.highlightedTextColor = kNavColor;
}

- (void)setLyricsItem:(YZGMusicItem *)lyricsItem{
    self.lyric.text = lyricsItem.lyric;
}

@end

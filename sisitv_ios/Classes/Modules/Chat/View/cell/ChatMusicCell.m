//
//  ChatSearchMusicCell.m
//  xiuPai
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatMusicCell.h"

@interface ChatMusicCell ()

@property (weak, nonatomic) IBOutlet UILabel *musicName;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic , strong)  YZGMusicItem *rowItem;

@end

@implementation ChatMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    [self.button setTitleColor:kNavColor forState:UIControlStateNormal];
    
    self.button.layer.borderColor = kNavColor.CGColor;
    self.button.layer.borderWidth = 1.0;

    self.button.layer.cornerRadius = self.button.height/3.0;
    self.button.layer.masksToBounds = YES;

}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    self.button.hidden = NO;
    self.progress.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YZGMusicItem *rowItem = (YZGMusicItem *) item;
    self.rowItem = rowItem;
    self.musicName.text = rowItem.song_name ;
 
    if (rowItem.musicStatus == YZGMusicOnline) {
        [self.button setTitle:@"下载" forState:UIControlStateNormal];
    }else if (rowItem.musicStatus == YZGMusicDownLoaded){
        [self.button setTitle:@"播放" forState:UIControlStateNormal];
    }else if(rowItem.musicStatus == YZGMusicDownLoading){
        self.progress.hidden = NO;
        [self.button setTitle:@"下载中" forState:UIControlStateNormal];
    }else if(rowItem.musicStatus == YZGMusicDownDeleting){
        self.button.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        [self.button setTitle:@"下载失败" forState:UIControlStateNormal];
    }
    self.progress.progress = rowItem.currentProgress;
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.rowItem.musicStatus == YZGMusicDownLoaded) {
        [self playMusicWithButton:sender];
    }else if (self.rowItem.musicStatus == YZGMusicOnline){
        [self downLoadMusicWithButton:sender];
    }
}

-(void)playMusicWithButton:(UIButton *) button{
    [self.delegate tableViewCell:self clickPlayMusic:button withItem:self.rowItem];
}

-(void)downLoadMusicWithButton:(UIButton *) button{
    [self.delegate tableViewCell:self clickDownloadMusic:button withItem:self.rowItem];
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

@end

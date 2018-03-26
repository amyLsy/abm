//
//  YZGTableViewCellDelegate.h
//  sisitv
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZGTableViewCell,BannerRowItem;
@protocol YZGTableViewCellDelegate <NSObject>

@optional


//banner触摸事件
-(void)tableViewCell:(YZGTableViewCell *)cell tapBanner:(BannerRowItem *)banner;
//关注
-(void)didClickAttentionButton:(UIButton *)button withUserId:(NSString *)userId;;
//关注
-(void)tableViewCell:(YZGTableViewCell *)cell clickAttentionStatusWithTitle:(NSString *)title withItem:(id)item;

//音乐cell按钮播放
-(void)tableViewCell:(YZGTableViewCell *)cell clickPlayMusic:(UIButton *)button withItem:(id)item;
//音乐cell按钮下载
-(void)tableViewCell:(YZGTableViewCell *)cell clickDownloadMusic:(UIButton *)button withItem:(id)item;
//取消场控
-(void)didClickCancelButton:(UIButton *)button withUserId:(NSString *)userId;

@end

//
//  YZGHeaderView.h
//  xiuPai
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGHeaderView : UIView

+(instancetype)headerView;

@property (nonatomic , weak) UIView *needAmplificationView;

/**headerHeight*/
-(CGFloat)headerHeightForTableView:(UITableView *)tableView;

/**set infomation*/
-(void)setInfomation:(id)infomation;

@end

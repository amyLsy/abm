//
//  MineDataSource.h
//  xiuPai
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGTableViewDataSource.h"
#import "MineTableViewCell.h"
#import "MineHeaderView.h"
@interface MineDataSource : YZGTableViewDataSource

@property (nonatomic , weak) UIViewController<MineHeaderViewDelegate,YZGTableViewCellDelegate> *delegateController;

@end

@interface ReferencesDataSource : YZGTableViewDataSource

@property (nonatomic , weak) UIViewController<MineHeaderViewDelegate,YZGTableViewCellDelegate> *delegateController;

@end

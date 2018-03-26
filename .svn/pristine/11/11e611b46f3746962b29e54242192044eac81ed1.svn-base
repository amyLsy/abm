//
//  LGSelectGameView.h
//  sisitv_ios
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGSelectGameView,GameArea;

@protocol LGSelectGameViewDeleaget

- (void)selectGameView:(LGSelectGameView *)selectGameView selectType:(NSInteger)selectType didClickItem:(GameArea *)gameArea;

@end

@interface LGSelectGameView : UIView
@property (weak, nonatomic) id<LGSelectGameViewDeleaget> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) UIViewController *presenController;
@property (strong, nonatomic) NSArray *dataArray;
- (void)resSet;

@end

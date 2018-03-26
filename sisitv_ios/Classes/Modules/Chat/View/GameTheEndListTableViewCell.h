//
//  GameTheEndListTableViewCell.h
//  sisitv_ios
//
//  Created by 悟不透。 on 2017/11/9.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTheEndListTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *noImage0;
@property (weak,nonatomic) IBOutlet UIImageView *noImage1;
@property (weak,nonatomic) IBOutlet UILabel *noLabel0;
@property (weak,nonatomic) IBOutlet UILabel *noLabel1;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *needCoin;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSDictionary *d;

@end

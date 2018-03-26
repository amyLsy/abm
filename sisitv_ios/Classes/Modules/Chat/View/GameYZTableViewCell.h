//
//  GameYZTableViewCell.h
//  sisitv_ios
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GameYzCloseBlock)();

@interface GameYZTableViewCell : UITableViewCell

@property (nonatomic, copy) GameYzCloseBlock gameYzCloseBlock;

@property (weak,nonatomic) IBOutlet UILabel *gameTit1;
@property (weak,nonatomic) IBOutlet UITextField *gameText1;
@property (weak,nonatomic) IBOutlet UIButton *gameButton1;

@property (weak,nonatomic) IBOutlet UILabel *gameTit2;
@property (weak,nonatomic) IBOutlet UITextField *gameText2;
@property (weak,nonatomic) IBOutlet UIButton *gameButton2;

@property (weak,nonatomic) IBOutlet UILabel *gameTit3;
@property (weak,nonatomic) IBOutlet UITextField *gameText3;
@property (weak,nonatomic) IBOutlet UIButton *gameButton3;

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSString *dictJson;

@end

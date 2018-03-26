//
//  JLGameBlanksCell.h
//  sisitv_ios
//
//  Created by ming on 17/12/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLSubmitBlock)(UIButton *btn ,UITextField *answerTextField);

@interface JLGameBlanksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *answerTextFiekd;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property(nonatomic, copy) JLSubmitBlock submitBlock;
@end

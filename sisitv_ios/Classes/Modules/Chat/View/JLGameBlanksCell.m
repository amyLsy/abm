//
//  JLGameBlanksCell.m
//  sisitv_ios
//
//  Created by ming on 17/12/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "JLGameBlanksCell.h"

@implementation JLGameBlanksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)submitButton:(id)sender {
    
        
    if (_submitBlock) {
        _submitBlock(sender,_answerTextFiekd);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

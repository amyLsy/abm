//
//  LGReferences Cell.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/2.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGReferencesCell.h"
#import "LGReferencesModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "UIImageView+LGUIimageView.h"

@implementation LGReferencesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    LGReferencesModel *mode = item;
    
    [self.avartarImageView setHeader:mode.avatar];
    self.nameLabel.text = mode.user_nicename;
    self.singLable.text = mode.signature;
    if (mode.sex == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"boy"];
    }else{
         self.sexImageView.image = [UIImage imageNamed:@"nv"];
    }
    
    self.levelLabel.text = [NSString stringWithFormat:@"%@",mode.user_level];
    
    
}
+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

@end

//
//  LGShowListCell.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGShowListCell.h"
#import "LGShowListModel.h"
#import "HttpTool.h"
#import "Account.h"
#import "AlertTool.h"

@implementation LGShowListCell{
    
    LGShowListModel *model;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGFloat)tableView:(UITableView *)tableView rowHeightForIndexPath:(NSIndexPath *)indexPath{
    return 102.5;
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    model = item;
    _zansButton.selected = model.is_like;
    self.titleLable.text = [NSString stringWithFormat:@"标题:%@",model.title];
    self.descLabel.text = model.desc;
    
    self.priceLabel.text = [NSString stringWithFormat:@"价格：%.2f",model.price];
    if ([model.likes integerValue] > 0) {
         [self.zansButton setTitle:model.likes forState:UIControlStateNormal];
    }else{
        
         [self.zansButton setTitle:@"" forState:UIControlStateNormal];
    }
   
    if (model.status == 1) {
    
        self.stateLabel.text = @"正常";
        
    }else{
        
         self.stateLabel.text = @"停用";
    }
    
    if (model.show_status) {
        self.recommendedLabel.text = @"演出中";
    }else{
        self.recommendedLabel.text = @"未演出";
    }
   
    self.durationLabel.text = [NSString stringWithFormat:@"时长:%@", model.duration];
}
- (IBAction)zan:(id)sender {
    //节目点赞
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [Account shareInstance].token;
    dict[@"type"] = @"4";
    dict[@"item_id"] = model.id;
    dict[@"owner_id"] = model.uid;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserlike param:dict success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            model.likes = [NSString stringWithFormat:@"%zd",[model.likes integerValue] + 1];
            [_zansButton setTitle:model.likes forState:UIControlStateNormal];
            _zansButton.selected = YES;
        }
        
    } faile:^{
        
        
    }];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

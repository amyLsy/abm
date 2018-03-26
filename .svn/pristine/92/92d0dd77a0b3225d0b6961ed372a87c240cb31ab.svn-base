//
//  GameYZTableViewCell.m
//  sisitv_ios
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "GameYZTableViewCell.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "Account.h"

@implementation GameYZTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(NSDictionary *)tmDict:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
}

-(void)setDictJson:(NSString *)dictJson
{
    if (dictJson) {
        _dict = [self tmDict:dictJson];

        NSArray *list = _dict[@"user_list"];
        int status = 1;
        for (NSDictionary *d in list) {
//            int status = [d[@"status"] intValue];
            NSInteger user_id = [d[@"user_id"] integerValue];
            UILabel *label = nil;
            UITextField *textFile = nil;
            switch (status) {
                case 1:
                    label = _gameTit1;
                    textFile = _gameText1;
                    break;
                case 2:
                    label = _gameTit2;
                    textFile = _gameText2;
                    break;
                case 3:
                    label = _gameTit3;
                    textFile = _gameText3;
                    break;
            }
//            if(status<4){
                label.text = [NSString stringWithFormat:@"玩家：%@  回答正确：%@题    回答错误：%@题", d[@"user_nicename"], d[@"correct_num"], d[@"error_times"]];
                textFile.tag=user_id;
//            }else{
//                label.text = [NSString stringWithFormat:@"玩家：无"];
//            }
            status++;
        }
    }
}

-(IBAction)closeGameYz
{
    _gameYzCloseBlock();
}

-(IBAction)submitGameYz:(UIButton *)b
{
    UITextField *amount = nil;
    if (b.tag==0) {
        amount = _gameText1;
    }else if (b.tag==1){
        amount = _gameText2;
    }else{
        amount = _gameText3;
    }
    if (amount.text.length==0) {
        [self errorMsg:@"请输入金额"];
        return;
    }
    [amount resignFirstResponder];
    
    [AlertTool ShowInView:self.window withTitle:@"押注中"];
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,
                        @"match_id": _dict[@"match_id"],//竞猜id
                        @"be_stacked_uid": @(amount.tag),
                        @"amount": amount.text
                        };
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagStake param:d success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@200])
        {
            [self errorMsg:@"押注成功"];
        }
        else
        {
            [self errorMsg:responseObject[@"descrp"]];
        }
    } faile:^{
        [self errorMsg:@"请重试..."];
    }];
}

-(void)errorMsg:(NSString *)m
{
    [AlertTool ShowErrorInView:self.window withTitle:m];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

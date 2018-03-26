//
//  GameTheEndTableViewCell.m
//  sisitv_ios
//
//  Created by Mac on 2017/10/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "GameTheEndTableViewCell.h"
#import "GameTheEndListTableViewCell.h"

@implementation GameTheEndTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(IBAction)closeGameTheEnd
{
    _gameTheEndCloseBlock();
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


- (void)setUserList:(NSArray *)userList{
    
    list = [[NSMutableArray alloc] initWithArray:userList];;
    
    [_tbView reloadData];
    
}


-(void)setDictJson:(NSString *)dictJson
{
    if (dictJson) {
        
        _tbView.tableFooterView = [UIView new];
        // 告诉tableView的真实高度是自动计算的，根据你的约束来计算
        _tbView.rowHeight = 137;
        // 告诉tableView所有cell的估计行高
  
        // 返回估算告诉,作用:在tablView显示时候,先根据估算高度得到整个tablView高,而不必知道每个cell的高度,从而达到高度方法的懒加载调用
        
        NSDictionary *dict = [self tmDict:dictJson];
        list = [[NSMutableArray alloc] initWithArray:dict[@"user_list"]];
        
//        NSString *msg = [NSString stringWithFormat:@"当前游戏收益情况：\n参赛人数：%@\n平台收益：%@\n主播收益：%@\n押注金币总数：%@\n购买复活卡金币总数：%@\n参赛金币总数：%@",res[@"join_number"],res[@"platform_earn"],res[@"anchor_earn"],res[@"stake"],res[@"buy_card"],res[@"join_money"]];
        NSDictionary *td = dict[@"results"];
        
        if ([dict[@"results"][@"area_id"] integerValue] > 0) {
            _tbView.rowHeight = 137;
        }else{
            
            _tbView.rowHeight = 79;
        }
        
        
        _tbText.text=[NSString stringWithFormat:@"参赛人数：%@       支持总额：%@       \n复活总数：%@", td[@"join_number"], td[@"stake"], td[@"buy_card"]];
    }
}

#pragma mark - 数据源方法

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return list.count;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString *ideitifier = @"subjectCells";
    GameTheEndListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GameTheEndListTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.index = indexPath.row+1;
    cell.d = list[indexPath.row];
    
    return cell;
}

// 选中某行cell时会调用
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

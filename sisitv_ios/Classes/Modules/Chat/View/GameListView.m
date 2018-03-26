
//
//  GameListView.m
//  sisitv_ios
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "GameListView.h"
#import "LGGameListView.h"

@implementation GameListView

static NSString *identifier = @"LGGameListView";

- (void)setUserList:(NSArray *)userList{
    
    _viewTitleLable.text = @"当前游戏排行榜";
    _userList = userList;
    self.tableView.rowHeight = 58;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LGGameListView" bundle:nil] forCellReuseIdentifier:identifier];
    
}

- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    if (_userList.count) {
        
        _viewTitleLable.text = @"当前游戏排行榜";
        
    }else{
        
      _viewTitleLable.text = @"暂无游戏数据";
    }
    
    
    
}

- (IBAction)coseAtion:(id)sender {
    
    self.hidden = YES;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _userList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LGGameListView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell config:self.userList[indexPath.row] index:indexPath.row];
    
    return cell;
    
}





@end

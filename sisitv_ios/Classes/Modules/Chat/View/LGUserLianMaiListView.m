//
//  LGUserLianMaiListView.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/19.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGUserLianMaiListView.h"
#import "LGLianMaiListCell.h"
#import "UIImageView+LGUIimageView.h"
#import "LGButtont.h"

@implementation LGUserLianMaiListView

static NSString *cellID = @"LianMaiID";
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LGLianMaiListCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (void)setUserJoinArray:(NSMutableArray *)userJoinArray{
    
    _userJoinArray = userJoinArray;
    [self.tableView reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _userJoinArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LGLianMaiListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    ChatMessage *message = self.userJoinArray[indexPath.row];
    [cell.userAvatar setHeader:message.avatar];
    cell.userName.text = message.userName;
    cell.join.object = message;
    cell.noJoin.object = message;
    [cell.join addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    [cell.noJoin addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (void)join:(LGButtont *)btn{
    
    [self.delegate lianMaiView:self ationType:1 message:btn.object];
    
}
- (void)cancel:(LGButtont *)btn{
    
    [self.delegate lianMaiView:self ationType:0 message:btn.object];
    
}
- (IBAction)hidenView:(id)sender {
    self.hidden = YES;
}



@end

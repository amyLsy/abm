//
//  ChatConversationView.m
//  sisitv_ios
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ChatConversationView.h"
#import "ChatConversationCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ChatConversationView ()<UITableViewDelegate,UITableViewDataSource>

/**
 数据源
 */
@property (nonatomic , strong) NSMutableArray *chatDataArray;
/**
 聊天view
 */
@property (nonatomic , strong) UITableView *chatConversationView;

@end

@implementation ChatConversationView

-(instancetype)init{
    if (self = [super init]) {
        self.chatDataArray = [NSMutableArray array];
        [self initChatConversationView];
    }
    return self;
}
-(void)initChatConversationView
{
    self.chatConversationView = [[UITableView alloc]init];
    self.chatConversationView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.chatConversationView];
    [self.chatConversationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.chatConversationView registerNib:[UINib nibWithNibName:@"ChatConversationCell" bundle:nil] forCellReuseIdentifier:@"ChatConversationCell"];
    self.chatConversationView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatConversationView.delegate = self;
    self.chatConversationView.dataSource = self;
}

-(void)clearChatConversionData{
    [self.chatDataArray removeAllObjects];
    [self.chatConversationView reloadData];
}
-(void)startShowMessage:(ChatMessage *)chatMessage{
    
    
    //连麦跟游戏消息不提示
//    ChatGameShowQuest = 211,
    //开始音乐类型
//    ChatGameShowMusic
    if (chatMessage.type <= 105 && chatMessage.type >= 100 || chatMessage.type == ChatGameShowQuest || chatMessage.type == ChatGameShowMusic) {
        
        return;
    }
    
    
    if (chatMessage.type != ChatExitMessage) {
        if (self.chatDataArray.count >150) {
            [self.chatDataArray removeAllObjects];
            [self.chatConversationView reloadData];
        }
        [self.chatDataArray addObject:chatMessage];
        [self scrollCoversitionViewToBottom];
    }
}

-(void)scrollCoversitionViewToBottom{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDataArray.count-1 inSection:0];
    [self.chatConversationView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    if (self.chatConversationView.contentSize.height >= self.chatConversationView.height) {
//        CGPoint offset = CGPointMake(0, self.chatConversationView.contentSize.height -  self.chatConversationView.frame.size.height);
//        [self.chatConversationView setContentOffset:offset animated:YES];
//    }
    [self.chatConversationView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark ChatConversationViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"ChatConversationCell" cacheByIndexPath:indexPath configuration:^(ChatConversationCell *cell) {
        cell.chatMessage = self.chatDataArray[indexPath.row];
    }];
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *chatMessage = self.chatDataArray[indexPath.row];
    ChatConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatConversationCell" forIndexPath:indexPath];
    cell.chatMessage = chatMessage;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessage *chatMessage = self.chatDataArray[indexPath.row];
    if (chatMessage.type == ChatNomalMessage){
        self.clickUser(chatMessage.userId);
    }
}

-(void)dealloc
{
    YZGLog(@"%@",self);
}

@end

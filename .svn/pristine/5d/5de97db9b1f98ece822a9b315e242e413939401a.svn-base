//
//  MainNewController.m
//  xiuPai
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MainNewController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "YZGCollectionView.h"
#import "MainNewDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "MainListModel.h"
#import "TopicRequest.h"
@interface MainNewController (){
    
    RoomInfo *_roomInfo;
}

@end

@implementation MainNewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView yzgTriggerRefreshing];
}
    
- (void)createDataSourceAndLayout{
    self.dataSource = [[MainNewDataSource alloc]init];
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
    YZGCollectionSectionItem *sectionItem1 = [[YZGCollectionSectionItem alloc]init];
    YZGCollectionSectionItem *sectionItem2 = [[YZGCollectionSectionItem alloc]init];

    [self.dataSource.sectionItems addObject:sectionItem0];
    [self.dataSource.sectionItems addObject:sectionItem1];
    [self.dataSource.sectionItems addObject:sectionItem2];
    
    CGFloat margin = 5.0;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    
    self.cellClassName = @[@"MainNewCollectionCell",@"MainNewTopicCollectionCell",@"MainNewSepCollectionCell"];
}
-(void)createModel{
    self.listModel = [[MainListModel alloc] initWithDelegate:self];
}
-(void)configForRequest{
    MainListParam *mainListParam = [[MainListParam alloc] init];
    mainListParam.type = @"3";
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"getLive" withRequestParam:mainListParam];
    self.listModel.netRequest = mainListRequest;
}

-(void)handleAfterRequestFaile{
    [super handleAfterRequestFaile];
    [self loadTopic];
}

-(void)requestDidSuccess{
    YZGCollectionSectionItem *sectionItem2 = [self.dataSource.sectionItems objectAtIndex:2];
    [sectionItem2.rowItems addObjectsFromArray:self.listModel.responseObject];
    [self loadTopic];
}
-(void)loadTopic{
    if (self.listModel.isRefresh && self.term_id) {
        YZGCollectionSectionItem *sectionItem0 = [self.dataSource.sectionItems objectAtIndex:0];
        YZGCollectionSectionItem *sectionItem1 = [self.dataSource.sectionItems objectAtIndex:1];
        TopicRequest *topicRequest = [[TopicRequest alloc] init];
        topicRequest.requestParam = @{@"term_id":self.term_id};
        [topicRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
            [sectionItem0.rowItems addObjectsFromArray:request.item];
            [sectionItem1.rowItems addObject:@"this is sepView so that's need no data"];
            [self.collectionView reloadData];
        } failure:nil];
    }
}
    
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    if ([item isKindOfClass:[RoomInfo class]]) {
        RoomInfo *roomInfo = (RoomInfo *)item;
        _roomInfo = roomInfo;
        if (roomInfo.price.integerValue>0) {
            [self enterPriceRoomWithRoomInfo:roomInfo];
        }else if (roomInfo.minute_charge.integerValue>0){
            [self enterMinuteChargeRoomWithRoomInfo:roomInfo];
        }else if ([roomInfo.need_password intValue]){
            [self enterPasswordRoomWithRoomInfo:roomInfo];
        }else{
            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
        }
    }else if ([item isKindOfClass:[TopicRowItem class]]){
        TopicRowItem *topic = (TopicRowItem *)item;
        MainListParam *mainListParam = [[MainListParam alloc] init];
        mainListParam.type = @"2";
        mainListParam.term_id = topic.term_id;

        self.listModel.listParam = mainListParam;
        [self.collectionView yzgTriggerRefreshing];
    }
}

-(void)enterPriceRoomWithRoomInfo:(RoomInfo *)roomInfo{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每次)",roomInfo.price,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

-(void)enterPasswordRoomWithRoomInfo:(RoomInfo *)roomInfo{
    [AlertTool alertWithTitle:nil message:@"进入该直播间需要密码" callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            NSString *room_password = textField.text;
            RoomParam *roomParam = [[RoomParam alloc]init];
            roomParam.room_id = roomInfo.room_id;
            roomParam.room_password = room_password;
            [RoomModel checkRoomPassword:roomParam success:^(id info, BOOL successGetInfo){
                if (successGetInfo) {
                    [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:room_password video_url:roomInfo.channel_source];
                }else{
                    [AlertTool ShowErrorInView:self.view withTitle:info];
                }
            }];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
}
-(void)enterMinuteChargeRoomWithRoomInfo:(RoomInfo *)roomInfo{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每分钟)",roomInfo.minute_charge,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

- (void)persentPlayerControllrWithRoom_id:(NSString *)room_id avatar:(NSString *)avatar room_password:(NSString *)room_password video_url:(NSString *)video_url{
    PlayerViewController *playerControllr = [[PlayerViewController alloc] init];
    playerControllr.room_id = room_id;
    playerControllr.avatar = avatar;
    playerControllr.room_password = room_password;
    playerControllr.chatViewController.roomInfo = _roomInfo;
    playerControllr.video_url = video_url;
    playerControllr.chatViewController.roomInfo = _roomInfo;
    [self presentNeedNavgation:NO presentendViewController:playerControllr];
}

@end

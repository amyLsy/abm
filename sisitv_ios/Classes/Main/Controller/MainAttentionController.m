//
//  MainAttentionController.m
//  sisitv
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "MainAttentionController.h"
#import "PlayerViewController.h"
#import "LGVideoAttentionController.h"
#import "LGLiveAttentionController.h"
#import "RoomModel.h"
#import "Account.h"
#import "MainDataSource.h"
#import "AlertTool.h"
#import "MainListModel.h"
#import "HYPageView.h"

@interface MainAttentionController ()

@property (nonatomic , strong) NSThread *thread;
@end

@implementation MainAttentionController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView yzgStartRefreshing];
      self.view.backgroundColor = [UIColor blackColor];
    HYPageView *pageView = [[HYPageView alloc] initWithFrame:self.view.bounds withTitles:@[@"直播",@"视频",@"图片"] withViewControllers:@[@"LGLiveAttentionController",@"LGVideoAttentionController",@"LGVideoAttentionController"] withParameters:@[@"",@"1",@"2"]];
    [self.view addSubview:pageView];
    
}

//-(void)createModel{
//    self.listModel = [[MainListModel alloc] initWithDelegate:self];
//}
//
//-(void)createDataSource{
//    self.dataSource = [[MainDataSource alloc] initWithController:self];
//    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
//    [self.dataSource.sectionItems addObject:sectionItem];
//}
//
//-(void)configForRequest{
//    MainListParam *mainListParam = [[MainListParam alloc] init];
//    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"getAttentionLiveList" withRequestParam:mainListParam];
//    self.listModel.netRequest = mainListRequest;
//}
//
//-(void)requestDidSuccess{
//    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
//    [sectionItem.rowItems addObjectsFromArray: self.listModel.responseObject];
//
//}
//
////点击的回调
//- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
//
//
//
//    if ([item isKindOfClass:[RoomInfo class]]) {
//        RoomInfo *roomInfo = (RoomInfo *)item;
//        if (roomInfo.price.integerValue>0) {
//            [self enterPriceRoomWithRoomInfo:roomInfo];
//        }else if (roomInfo.minute_charge.integerValue>0){
//            [self enterMinuteChargeRoomWithRoomInfo:roomInfo];
//        }else if ([roomInfo.need_password intValue]){
//            [self enterPasswordRoomWithRoomInfo:roomInfo];
//        }else{
//            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
//        }
//    }
//}
//-(void)enterPriceRoomWithRoomInfo:(RoomInfo *)roomInfo{
//    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每次)",roomInfo.price,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
//        if (index ==1) {
//            if ([[Account shareInstance].balance integerValue] > roomInfo.price.integerValue) {
//                [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
//            }else{
//                [AlertTool ShowErrorInView:self.view withTitle:[NSString stringWithFormat:@"%@不足",kBalance]];
//            }
//        }
//    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
//}
//
//-(void)enterPasswordRoomWithRoomInfo:(RoomInfo *)roomInfo{
//    [AlertTool alertWithTitle:nil message:@"进入该直播间需要密码" callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
//        if (index ==1) {
//            NSString *room_password = textField.text;
//            RoomParam *roomParam = [[RoomParam alloc]init];
//            roomParam.room_id = roomInfo.room_id;
//            roomParam.room_password = room_password;
//            [RoomModel checkRoomPassword:roomParam success:^(id info, BOOL successGetInfo){
//                if (successGetInfo) {
//                    [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:room_password video_url:roomInfo.channel_source];
//                }else{
//                    [AlertTool ShowErrorInView:self.view withTitle:info];
//                }
//            }];
//        }
//    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
//}
//
//-(void)enterMinuteChargeRoomWithRoomInfo:(RoomInfo *)roomInfo{
//    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每分钟)",roomInfo.minute_charge,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
//        if (index ==1) {
//            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
//        }
//    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
//}
//
//- (void)persentPlayerControllrWithRoom_id:(NSString *)room_id avatar:(NSString *)avatar room_password:(NSString *)room_password video_url:(NSString *)video_url{
//    PlayerViewController *playerControllr = [[PlayerViewController alloc] init];
//    playerControllr.room_id = room_id;
//    playerControllr.avatar = avatar;
//    playerControllr.room_password = room_password;
//    playerControllr.video_url = video_url;
//    [self presentNeedNavgation:NO presentendViewController:playerControllr];
//}
@end

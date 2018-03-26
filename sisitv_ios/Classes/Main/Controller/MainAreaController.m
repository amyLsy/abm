//
//  MainNewController.m
//  xiuPai
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MainAreaController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "YZGCollectionView.h"
#import "MainNewDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "MainListModel.h"
#import "TopicRequest.h"
#import "YZGAppSetting.h"
#import "LGUploadTermsModel.h"
#import "LGTopCell.h"
#import "LGButtont.h"
#import "LGVideoListCell.h"
#import "LGMediaListModel.h"
#import "MJRefresh.h"
#import "LGPlaysController.h"
#import "HttpTool.h"

@interface MainAreaController ()<LGTermsViewDelegate>
{
    NSString *location;
    NSString *termId;
}

@end

@implementation MainAreaController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.collectionView yzgTriggerRefreshing];
}

-(void)receiveLocationUpdateMessage{
    location =[YZGAppSetting sharedInstance].currentCity;
    [[YZGAppSetting sharedInstance] updateCurrentLocationToServer:nil];
    
    [self.collectionView yzgTriggerRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    location = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateMessage) name:kAppUpDateCurrentPosition object:nil];
    [[YZGAppSetting sharedInstance] getCurrentLocation];
    termId = 0;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    [self.collectionView yzgTriggerRefreshing];
}
    
- (void)createDataSourceAndLayout{
    self.dataSource = [[MainNewDataSource alloc]init];
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
    YZGCollectionSectionItem *sectionItem1 = [[YZGCollectionSectionItem alloc]init];
    YZGCollectionSectionItem *sectionItem2 = [[YZGCollectionSectionItem alloc]init];

    [self.dataSource.sectionItems addObject:sectionItem0];
    [self.dataSource.sectionItems addObject:sectionItem1];
    [self.dataSource.sectionItems addObject:sectionItem2];
    
    CGFloat margin = 2;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    
    self.cellClassName = @[@"MainNewCollectionCell",@"MainNewTopicCollectionCell",@"MainNewSepCollectionCell",@"LGTopCell",@"LGVideoListCell"];
}
-(void)createModel{
    
    switch ([termId integerValue]) {
            
        case 0:
             self.listModel = [[MainListModel alloc] initWithDelegate:self];
            break;
        case 1:
            self.listModel = [[LGMediaListModel alloc] initWithDelegate:self];
            break;
        case 2:
            self.listModel = [[LGMediaListModel alloc] initWithDelegate:self];;
            break;
            
        default:
            break;
    }
   
}
-(void)configForRequest{
    
    
    switch ([termId integerValue]) {
            
        case 0:
            [self requetAreaLive];
            break;
        case 1:
            [self requetAreaVieo];
            break;
        case 2:
             [self requetAreaIma];
            break;
            
        default:
            break;
    }
    
}

- (void)requetAreaVieo{
    
    MainListParam *mainListParam = [[MainListParam alloc] init];
    mainListParam.type = @"1";
    mainListParam.sortby = @"2";
    mainListParam.term_id = _term_id;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_views" withRequestParam:mainListParam];
    self.listModel.netRequest = mainListRequest;
    
}

- (void)requetAreaIma{
    
    MainListParam *mainListParam = [[MainListParam alloc] init];
    mainListParam.type = @"2";
    mainListParam.sortby = @"2";
    mainListParam.term_id = _term_id;
    YZGRequest *mainListRequest = [[YZGRequest alloc] initWithRequestUrl:@"get_views" withRequestParam:mainListParam];
    self.listModel.netRequest = mainListRequest;
    
}

- (void)requetAreaLive{
    
    MainListParam *mainListParam = [[MainListParam alloc] init];
    mainListParam.type = @"2";
    mainListParam.location = location;
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
    
    NSArray *title = @[@"直播",@"视频",@"图片"];
    NSMutableArray *te = [NSMutableArray arrayWithCapacity:3];
    [te removeAllObjects];
    for (int i = 0; i < 3; i ++) {
        
        LGUploadTermsModel *topModel = [[LGUploadTermsModel alloc] init];
        topModel.name = title[i];
        topModel.id = [NSString stringWithFormat:@"%zd",i];
        [te addObject:topModel];
    }
    YZGCollectionSectionItem *sectionItem0 = [self.dataSource.sectionItems objectAtIndex:0];
    YZGCollectionSectionItem *sectionItem1 = [self.dataSource.sectionItems objectAtIndex:1];
    [sectionItem0.rowItems removeAllObjects];
    [sectionItem0.rowItems addObject:te];
    [sectionItem1.rowItems addObject:@"this is sepView so that's need no data"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:0 inSection:0];

        LGTopCell *topCell =  (LGTopCell *)[self.collectionView cellForItemAtIndexPath:indexPatch];
        topCell.termsTypeView.delegate = self;
    });
    [self.collectionView reloadData];
   
}

- (void)termsViewAtionWithType:(LGButtont *)actionType headView:(LGTermsTypeView *)termsView{
    
    LGUploadTermsModel *model = (LGUploadTermsModel *)actionType.object;
    termId = model.id;
     [self createModel];
    [self configForRequest];
    [self.collectionView.mj_header beginRefreshing];
   
    
}


    
- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    if ([item isKindOfClass:[RoomInfo class]]) {
        RoomInfo *roomInfo = (RoomInfo *)item;
        if (roomInfo.price.integerValue>0) {
            [self enterPriceRoomWithRoomInfo:roomInfo];
            
        }else if (roomInfo.minute_charge.integerValue>0){
            [self enterMinuteChargeRoomWithRoomInfo:roomInfo];
            
        }else if ([roomInfo.need_password intValue])//0不是，1密码房
        {
            [self enterPasswordRoomWithRoomInfo:roomInfo];
        }else{
            [self persentPlayerControllrWithRoom_id:roomInfo.room_id avatar:roomInfo.avatar room_password:nil video_url:roomInfo.channel_source];
        }
    }else if([item isKindOfClass:[LGMediaListModel class]]){
        
        //添加点击量
        
        
        
        LGMediaListModel *model = (LGMediaListModel *)item;
        [self addhits:model];
        LGPlaysController *play = [[LGPlaysController alloc] init];
        play.model = model;
        play.viewType = 1;
        
        YZGCollectionSectionItem *sectionItem1 =  [self.dataSource.sectionItems objectAtIndex:2];
        play.videoListArray = sectionItem1.rowItems;
        play.indexPath = indexPath;
        //    [self.navigationController pushViewController:play animated:YES];
        [self presentNeedNavgation:YES presentendViewController:play];
    }
}

- (void)addhits:(LGMediaListModel *)model{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @"1";
    param[@"item_id"] = model.id;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagAddhits param:param success:^(id responseObject) {
        
    } faile:^{
        
    }];
    
    
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
    playerControllr.video_url = video_url;
    [self presentNeedNavgation:NO presentendViewController:playerControllr];
}

@end

//
//  UserInfoController.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UserInfoController.h"
#import "UserInfoDataSource.h"
#import "UserInfoListModel.h"
#import "UtilityRowItem.h"
#import "SisiConversationViewController.h"
#import "PlayerViewController.h"
#import "Account.h"
#import "BaseUserRequset.h"
#import "AlertTool.H"
#import "RoomModel.h"
#import "SisiConversationListController.h"
#import "LGMediaListModel.h"
#import "LGUserMediaViewController.h"
#import "UtilityController.h"
@interface UserInfoController ()<UserInfoHeaderViewDelegate>

@property (nonatomic , assign) BOOL isAttention;

@property (nonatomic , strong) BaseUser *headerItem;

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self loadHeaderInfo];
    [self refreshNew];
    
}
-(void)loadHeaderInfo{
    
    BaseParam *userParam = [[BaseParam alloc] initWithUserId:self.ID];
    BaseUserRequset *userRequset = [[BaseUserRequset  alloc] initWithRequestParam:userParam];
    [userRequset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        self.headerItem = request.item;
        self.dataSource.headerItem = request.item;
        [self.tableView reloadData];
    } failure:nil];
}

-(void)createDataSource{
    self.dataSource = [[UserInfoDataSource alloc]initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)createModel{
    self.listModel = [[UserInfoListModel alloc] initWithDelegate:self];
}

-(void)configForRequest{}

-(void)requestDidSuccess{
    YZGTableViewSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
    [sectionItem.rowItems addObjectsFromArray:self.listModel.responseObject];
}

-(void)refreshNew{
    NSString *requestUrl;
    if (self.isAttention) {
        requestUrl = @"getUserAttentionList";
    }else{
        requestUrl = @"getUserFansList";
    }
    UserInfoListParam *param = [[UserInfoListParam alloc]init];
    param.ID = self.ID;
    YZGRequest *userInfoRequest = [[YZGRequest alloc] initWithRequestUrl:requestUrl withRequestParam:param];
    self.listModel.netRequest = userInfoRequest;
    [self.tableView yzgStartRefreshing];
}

-(void)headerView:(UserInfoHeaderView *)headerView didClickButton:(UserInfoHeaderViewButtonType)buttonType{
    switch (buttonType) {
        case UserInfoHeaderViewButtonBack:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UserInfoHeaderViewButtonPrivate:
        {
            
            if (![self.headerItem.ID isEqualToString:[Account shareInstance].ID]) {
                SisiConversationViewController *conversation = [[SisiConversationViewController alloc]initWithPeerId:self.ID];
                conversation.title = self.headerItem.user_nicename;
                conversation.needLeftBackButon = YES;
                [self presentNeedNavgation:YES presentendViewController:conversation];
            }else{
                SisiConversationListController *list = [[SisiConversationListController alloc]init];
                [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:list];
            }

        }
            break;
        case UserInfoHeaderViewButtonLiving:
        {
            [self willEnderPlayer];
        }
            break;
        case UserInfoHeaderViewButtonFans:
        {
            self.isAttention = NO;
            [self refreshNew];
        }
            break;
        case UserInfoHeaderViewButtonAttention:
        {
            self.isAttention = YES;
            [self refreshNew];
        }
            break;
            
        case MineHeaderViewButtonVideo:
        {
            //图片
            LGUserMediaViewController *vodeoVc = [[LGUserMediaViewController alloc] initWithVcType:1];
            vodeoVc.navigationItem.title = [Account shareInstance].user_nicename;
            vodeoVc.isME = YES;
            LGMediaListModel *model = [[LGMediaListModel alloc] init];
            model.owner_id = self.ID;
            vodeoVc.mediaModel = model;
            [self presentWithViewController:vodeoVc];
        }
            break;
        case MineHeaderViewButtonPhoto:
        {
            //图片
            LGUserMediaViewController *imageVc = [[LGUserMediaViewController alloc] initWithVcType:2];
            imageVc.navigationItem.title = [Account shareInstance].user_nicename;
            LGMediaListModel *model = [[LGMediaListModel alloc] init];
            model.owner_id = self.ID;
            imageVc.mediaModel = model;
            imageVc.isME = YES;
            [self presentWithViewController:imageVc];
        }
            break;
            
    }
}

-(void)presentWithViewController:(UIViewController *)viewController
{
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:viewController];
}

-(void)tableViewCell:(YZGTableViewCell *)cell clickAttentionStatusWithTitle:(NSString *)title withItem:(id)item{
    UtilityRowItem *utilityRowItem = (UtilityRowItem *)item;
    Account *account = [Account shareInstance];
    AccountParam *param = [AccountParam accountParam];
    param.userid = utilityRowItem.ID;
    KWeakSelf;
    [account attentionOrCancelAttentionWithCurrentButtonTitle:title WithParam:param success:^(BOOL successGetInfo, id responseObj) {
        if (successGetInfo) {
            [item setAttention_status:responseObj];
            [ws.tableView reloadData];
        }else{
            [AlertTool ShowErrorInView:self.tableView withTitle:responseObj];
        }
    }];
}

- (void)willEnderPlayer{
    NSString *room_id =  [self.headerItem room_id];
    if (self.headerItem.price.integerValue>0) {
        [self enterPriceRoom];
    }else if (self.headerItem.minute_charge.integerValue>0){
        [self enterMinuteChargeRoom];
    }else if ([self.headerItem.need_password intValue]){
        [self enterPasswordRoom];
    }else{
        [self persentPlayerControllrWithRoom_id:room_id avatar:self.headerItem.avatar room_password:nil video_url:nil];
    }
}

- (void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    
    BaseItem *userItem = item;
    UserInfoController *infovc = [[UserInfoController alloc] init];
    infovc.ID = userItem.ID;
    [self presentNeedNavgation:NO presentendViewController:infovc];
    
}

-(void)enterMinuteChargeRoom{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每分钟)",self.headerItem.minute_charge,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            [self persentPlayerControllrWithRoom_id:self.headerItem.room_id avatar:self.headerItem.avatar room_password:nil video_url:nil];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

-(void)enterPriceRoom{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每次)",self.headerItem.price,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            if ([[Account shareInstance].balance integerValue] > self.headerItem.price.integerValue) {
                [self persentPlayerControllrWithRoom_id:self.headerItem.room_id avatar:self.headerItem.avatar room_password:nil video_url:nil];
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:[NSString stringWithFormat:@"%@不足",kBalance]];
            }
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

-(void)enterPasswordRoom{
    [AlertTool alertWithTitle:nil message:@"进入该直播间需要密码" callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            NSString *room_password = textField.text;
            RoomParam *roomParam = [[RoomParam alloc]init];
            roomParam.room_id = self.headerItem.room_id;
            roomParam.room_password = room_password;
            [RoomModel checkRoomPassword:roomParam success:^(id info, BOOL successGetInfo){
                if (successGetInfo) {
                    [self persentPlayerControllrWithRoom_id:self.headerItem.room_id avatar:self.headerItem.avatar room_password:room_password video_url:nil];
                }else{
                    [AlertTool ShowErrorInView:self.view withTitle:info];
                }
            }];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:YES presentingController:self otherButtonTitles:nil, nil];
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

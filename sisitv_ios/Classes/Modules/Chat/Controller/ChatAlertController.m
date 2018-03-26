//
//  YZGInputAlertController.m
//  xiuPai
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatAlertController.h"
#import "SisiConversationViewController.h"
#import "RoomModel.h"
#import "BaseUserRequset.h"
#import "Account.h"
#import "ChatAlertInfomationView.h"
#import "ChatAlertManagerView.h"
#import "AlertTool.h"
#import "LeanCloudTool.h"
#import "YZGAppSetting.h"
#import "RankRequest.h"
#import "BaseUserRequset.h"
#import "RankRowItem.h"
@interface ChatAlertController ()<ChatAlertInfomationViewDelegate,ChatAlertManagerViewDelegate>


@property (nonatomic,strong) ChatAlertInfomationView *infomationView;
@property (nonatomic,strong) ChatAlertManagerView *managerView;
/**房间RoomInfo */
@property (nonatomic , strong) RoomInfo *roomInfo;

@property (nonatomic , strong) BaseUser *user;

@end

@implementation ChatAlertController

-(instancetype)initWithRoomInfo:(RoomInfo *)roomInfo{
    if (self = [super init]) {
        self.roomInfo = roomInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestIfomation];
}

-(void)requestIfomation{
    [AlertTool showWithCustomModeInView:self.view];
    RankListParam *rankParam = [[RankListParam alloc] initWithId:self.ID type:@"all" order:nil];
    rankParam.limit_num = @"2";
    RankRequest *rankRequest = [[RankRequest alloc]initWithRequestUrl:@"getUserContributionList" withRequestParam:rankParam];
    [rankRequest startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        self.infomationView.shouHu = request.item;
    } failure:nil];
 
    BaseParam *userParam = [[BaseParam alloc] initWithUserId:self.ID];
    BaseUserRequset *userRequset = [[BaseUserRequset  alloc] initWithRequestParam:userParam];
    [userRequset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        [AlertTool Hidden];
        self.user = request.item;
        [self showInfomationView];
    } failure:^(__kindof YZGRequest * _Nonnull request) {
        [AlertTool ShowErrorInView:KKeyWindow withTitle:[request.error localizedDescription]];
        [self remove];
    }];
}

-(void)showInfomationView{
    [self.view addSubview:self.infomationView];
    self.infomationView.user = self.user;
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.infomationView.frame = self.view.bounds;
    } completion:nil];
}
#pragma mark ---infomationViewAndDelegate
-(void)chatAlertInfomationView:(ChatAlertInfomationView *)chatAlertInfomationView didClickButton:(UIButton *)button withTypeName:(ChatAlertInfomationType)typeName
{
    switch (typeName) {
        case ChatAlertInfomationAttentionOrCancel:
        {
            AccountParam *param = [[AccountParam alloc]init];
            param.userid = self.ID;
            KWeakSelf;
            [[Account shareInstance] attentionOrCancelAttentionWithCurrentButtonTitle:button.titleLabel.text WithParam:param success:^(BOOL successGetInfo,id responseObj){
                if (successGetInfo) {
                    if ([responseObj containsString:@"已关注"] && ws.atentionClick) {
                        if ([ws.ID isEqualToString:ws.roomInfo.channel_creater]) {
                            ws.atentionClick();
                        }
                    }
                    [button setTitle:responseObj forState:UIControlStateNormal];
                }
            }];
        }
            break;
        case ChatAlertInfomationPrivate:
        {
            SisiConversationViewController *conversation = [[SisiConversationViewController alloc]initWithPeerId:self.ID];
            conversation.title = self.user.user_nicename;
            conversation.needLeftBackButon = YES;
            [self presentNeedNavgation:YES presentendViewController:conversation];
        }
            break;
        case ChatAlertInfomationManager:
        {
            [self showManagerView];
        }
            break;
        case ChatAlertInfomationClose:{
            [self remove];
        }
    }
}

-(RoomParam*)configRoomParmWithUserId:(NSString *)userId withRoomId:(NSString *)roomId{
    RoomParam *roomParam = [RoomParam roomParam];
    roomParam.room_id = roomId;
    roomParam.ID = userId;
    return roomParam;
}

#pragma mark ---alertManagerView

-(void)showManagerView{
    
    
    //管理
    BOOL isHostRole = [[Account shareInstance].ID isEqualToString:self.roomInfo.channel_creater];
    BOOL isHostId = [self.ID isEqualToString:self.roomInfo.channel_creater];
    BOOL isGuard = self.guardStatus.integerValue;
    if (isHostRole && !isHostId) {
        //@"连麦",
        self.managerView.managerButtonArray = @[@"场控",@"禁言",@"拉黑"];
    }else if (isHostId){
        self.managerView.managerButtonArray = @[@"举报",@"拉黑"];
    }else if (isGuard){
        self.managerView.managerButtonArray = @[@"举报",@"禁言",@"拉黑"];
    }else{
        self.managerView.managerButtonArray = @[@"举报",@"拉黑"];
    }
    [self.view addSubview:self.managerView];
}

-(void)chatAlertManagerView:(ChatAlertManagerView *)managerView clickManagerButtonType:(ChatAlertManagerType)managerButtonType{
    switch (managerButtonType) {
        case ChatAlertManagerReport:
        {
            [AlertTool alertWithControllerTitle:@"提示" alertMessage:[NSString stringWithFormat:@"确认要举报%@?",self.ID] preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction * _Nullable action) {
                RoomParam *param = [RoomParam roomParam];
                param.room_id = self.roomInfo.room_id;
                param.ID = self.ID;
                [RoomModel reportTheRoomWithParam:param success:^(id responseObj, BOOL successGetInfo) {
                    [AlertTool ShowInView:KKeyWindow onlyWithTitle:responseObj hiddenAfter:1.0];
                }];
            } cancleHandler:nil viewController:self];
        }
            break;
        case ChatAlertManagerBlackList:
        {
            [[LeanCloudTool leanCloudTool] addBlackListWithUserId:self.ID];
            [AlertTool ShowInView:KKeyWindow onlyWithTitle:@"已拉黑,将不会在收到ta的消息!" hiddenAfter:1.0];
        }
            break;
        case ChatAlertManagerForbidden:
        {
            RoomParam *param = [RoomParam roomParam];
            param.room_id = self.roomInfo.room_id;
            param.ID = self.ID;
            [RoomModel forbiddenWithParam:param success:^(id responseObj, BOOL successGetInfo) {
                [AlertTool ShowInView:KKeyWindow  onlyWithTitle:responseObj hiddenAfter:1.0];
            }];
        }
            break;
        case ChatAlertManagerSetGuard:
        {
            [AlertTool showWithCustomModeInView:KKeyWindow];
            [RoomModel managerLiveGuard:[self configRoomParmWithUserId:self.ID withRoomId:nil]  withTitle:nil success:^(id responseObj, BOOL successGetInfo) {
                if (successGetInfo) {
                    self.setGuardCallBack();
                }
                [AlertTool ShowInView:KKeyWindow onlyWithTitle:responseObj hiddenAfter:1.0];
            }];
        }
            break;
        case ChatAlertManagerLianMai:
        {
            self.startLianMai();
            [self remove];
        }
            break;
        default:
            break;
    }

}

-(void)remove{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(ChatAlertInfomationView *)infomationView
{
    if (!_infomationView)
    {
        ChatAlertInfomationView *infomationView = [ChatAlertInfomationView infomationView];
        infomationView.frame =  CGRectMake(0, self.view.height, self.view.width, self.view.height);
        infomationView.delegate = self;
        _infomationView = infomationView;
    }
    return _infomationView;
}
-(ChatAlertManagerView *)managerView{
    if (!_managerView) {
        ChatAlertManagerView *managerView = [ChatAlertManagerView managerView];
        managerView.frame = CGRectMake(0,0, self.view.width, self.view.height);
        managerView.delegate = self;
        _managerView = managerView;
    }
    return _managerView;
}
@end

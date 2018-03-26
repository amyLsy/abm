//
//  EndShowingController.m
//  sisitv
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "EndShowingController.h"
#import "RoomModel.h"
#import "Account.h"
#import "YZGShare.h"
#import "AlertTool.H"
#import "UIImageView+Rouding.h"
#import "ShowingFuncTypeView.h"
@interface EndShowingController ()
@property (weak, nonatomic) IBOutlet UIView *hostEndView;
@property (weak, nonatomic) IBOutlet UILabel *endTitle;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *viewed;
@property (weak, nonatomic) IBOutlet UILabel *zan;
@property (weak, nonatomic) IBOutlet UILabel *benefitName;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonToBottom;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic , strong) UIButton *selectedShareButton;

@property (nonatomic , assign)  ChatViewStyle chatViewStyle;
@property (nonatomic , weak) UIViewController *fromViewController;


@end

@implementation EndShowingController

-(instancetype)initWithChatViewStyle:(ChatViewStyle)chatViewStyle withController:(UIViewController *)fromViewController{
    
    if (self = [super init]) {
        self.chatViewStyle = chatViewStyle;
        self.fromViewController = fromViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayout];

    self.needInteractive = NO;
    if (self.errorInfo) {
        self.endTitle.text = self.errorInfo;
    }else{
        [self normalEnded];
    }
    NSArray *imageArray = @[@"微信",@"朋友圈",@"qq",@"qq空间"];
    for (int i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2.0-140+70*i,0,50,50)];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:0];
        button.tag = 422+i;
        [button addTarget:self action:@selector(shareAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:button];
    }
    
    
    
}


#pragma mark - 分享
- (void)shareAct:(UIButton *)button
{
    
    NSInteger shareButtonType = button.tag-421;
    ShareParam *param = [ShareParam shareParam];
    param.room_id = [Account shareInstance].token;
    [AlertTool showWithCustomModeInView:self.view];
    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
        [AlertTool Hidden];
        if (successGetInfo) {
            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:^(BOOL isSuccess, NSString *result) {
                //                [self startPush];
            }];
        }
    }];
    
}

-(void)normalEnded{
    if (self.chatViewStyle == ChatViewStyleHost) {
        self.hostEndView.hidden = NO;
        RoomParam *roomParam = [[RoomParam alloc]initWithToken:[Account shareInstance].token withRoomId:nil];
        [RoomModel stopLiveWithParam:roomParam success:^(id responseObj, BOOL successGetInfo) {
            if (successGetInfo) {
                self.roomInfo = responseObj;
                [self setInfoWithRoomInfo: self.roomInfo] ;
            }
        }];
    }else{
        [self setInfoWithRoomInfo:self.roomInfo] ;
    }
}

- (void)setLayout{
    self.backButtonToBottom.constant = self.backButtonToBottom.constant *KHeightScale;
    [self viewSetBackgroundColorAndcornerRadius:self.backButton];
    [self.avatar roundingImage];
}

-(void)viewSetBackgroundColorAndcornerRadius:(UIView *)view{
    view.backgroundColor = [UIColor colorWithHexString:@"ff4081"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.height/2.0;
}

-(void)setInfoWithRoomInfo:(RoomInfo *)roomInfo{
    self.benefitName.text = [NSString stringWithFormat:@"%@",kBenefit];
    [self.avatar sd_setImageWithURL: roomInfo.avatar];
    self.name.text =  roomInfo.user_nicename;
    self.zan.text =  roomInfo.channel_like;
    self.viewed.text =  roomInfo.online_num;
    self.income.text =  roomInfo.earn;
    self.time.text =  roomInfo.all_time;
}

- (IBAction)backButtonClick:(UIButton *)button {
    [self backToPre];
}

- (IBAction)shareButtonClick:(UIButton *)button {
    self.selectedShareButton.selected = NO;
    self.selectedShareButton = button;
    self.selectedShareButton.selected =YES;
    NSInteger shareButtonType = button.tag;
    ShareParam *param = [ShareParam shareParam];
    param.room_id = [Account shareInstance].token;
    [AlertTool showWithCustomModeInView:self.view];
    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
        [AlertTool Hidden];
        if (successGetInfo) {
            YZGShare *yzgShare = response;
            [YZGShare shareViewButtonClick:shareButtonType withShareContent:yzgShare success:nil];
        }
    }];
}

-(void)backToPre{
    KWeakSelf;
    [self dismissViewControllerAnimated:NO completion:^{
        [ws.fromViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end

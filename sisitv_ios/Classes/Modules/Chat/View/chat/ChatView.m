//
//  ChatView.m
//  Zhibo
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatView.h"
#import "ChatTopInfoView.h"
#import "ChatConversationView.h"
#import "ChatBottomView.h"
#import "ChatSendMessageView.h"
#import "ChatMoreOpitionView.h"
#import "ChatAdministratorView.h"
#import "ChatLyricsView.h"
#import "ChatCallInvitationView.h"
#import "ChatChangeVoiceView.h"
#import "ChatConversationCell.h"



#import "YZGNormalGiftView.h"
#import "YZGPreciousGiftView.h"
#import "YZGEntranceAnimationView.h"
#import "YZGBulletView.h"

#import "GiftCache.h"
#import "ChatGiftListView.h"
#import "Account.h"
#import "AudienceInfo.h"
#import "RoomInfo.h"
#import "LeanCloudTool.h"
#import "ChatFucView.h"
#import "AlertTool.h"
#import "HttpTool.h"
static CGFloat const kChatTopInfoViewHeight = 165.0;
/**
 底部view高度
 */
static CGFloat const KChatBottomBarHeight = 48.0;
/**
 聊天view高度
 */
static CGFloat const KChatConversationViewHeight = 195.0;
/**
 聊天view到右边的距离
 */
static CGFloat  const KChatConversationViewToRight = 10.0;
/**
 普通礼物view的高度
 */
static CGFloat const kGiftAnimationViewHeight = 110 ;
/**
 进场view的高度
 */
static CGFloat const kGradientAnimationViewHeight = 19;
/**
 礼物列表的view高度
 */
static CGFloat const KGiftViewHeight = KChatConversationViewHeight + KChatBottomBarHeight;
/**
 进场viwe到底部的距离
 */
static CGFloat const kGradientAnimationViewToBottom = KGiftViewHeight + 15;
/**
 普通礼物viwe到底部的距离
 */
static CGFloat const kGiftAnimationViewToBottom = kGradientAnimationViewToBottom + kGradientAnimationViewHeight + 15;

@interface ChatView ()<ChatBottomViewDelegate,ChatMoreOpitionViewDelegate,ChatSendMessageViewDelegate,ChatFucViewDelegate>

@property (nonatomic , assign) ChatViewStyle chatViewStyle;

/**
 顶部view
 */
@property (nonatomic , weak) ChatTopInfoView *chatTopInfoView;


/**
 输入框所在的view
 */
@property (nonatomic , weak) ChatSendMessageView *chatSendMessageView;

/**
 更多操作view
 */
@property (nonatomic , weak) ChatMoreOpitionView *moreOpitionView;
/**
 礼物view
 */
@property (nonatomic , weak) ChatGiftListView *giftListView;
/**
 普通动画view
 */
@property (nonatomic , weak) YZGNormalGiftView *normalGiftAnimationView;
/**
 等级进场动画view
 */
@property (nonatomic , weak) YZGEntranceAnimationView *entranceAnimationView;
/**
 昂贵动画view
 */
@property (nonatomic , weak) YZGPreciousGiftView *preciousGift;
/**
 弹幕view
 */
@property (nonatomic , weak) YZGBulletView *bulletView;
/**
 超管view
 */
@property (nonatomic , weak) ChatAdministratorView *administratorView;
/**
 歌词view
 */
@property (nonatomic , weak) ChatLyricsView *chatLyricsView;

/**
 音量
 */
@property (nonatomic , weak) ChatChangeVoiceView *chatChangeVoiceView;




@end

@implementation ChatView


//进行了self=[super init];修改 魏友臣 2017/5/11
-(instancetype)initWithStyle:(ChatViewStyle)chatViewStyle
{
    self=[super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self masksToBounds];
        self.chatViewStyle = chatViewStyle;
        [self initChatTopInfoView ];
        [self initChatConversationView];
        [self initChatBottomView];
        [self initBulletView];
        [self initFucView];
        if (chatViewStyle == ChatViewStyleAudience) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zan:)];
            [self.chatConversationView addGestureRecognizer:tap];
            [self initAdministratorView];
        }
    }
    return self;
}

-(void)masksToBounds{
    self.layer.masksToBounds = YES;
}

-(void)zan:(UITapGestureRecognizer *)ges{
    [self.chatConversationView removeGestureRecognizer:ges];
    [self.delegate chatView:self clickButton:nil withEventType:ChatViewEventClickZan];
}

-(void)initChatTopInfoView
{
    self.chatTopInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ChatTopInfoView" owner:nil options:nil]lastObject];
    self.chatTopInfoView.chatViewStyle = self.chatViewStyle;
    [self addSubview:self.chatTopInfoView];
    [self.chatTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(kChatTopInfoViewHeight);
    }];
    
    KWeakSelf;
    self.chatTopInfoView.clickUserIconImageview = ^(NSString *ID){
        [ws.delegate chatView:ws touchIconImageViewWithId:ID];
    };
    
    self.chatTopInfoView.clickAttention = ^(NSString *ID,UIButton *likebutton){
        [ws.delegate chatView:ws clickButton:likebutton withEventType:ChatViewEventClickAttentionHost];
    };
    self.chatTopInfoView.clickIncome = ^(NSString *ID){
        [ws.delegate chatView:ws touchIncomeWithId:ID];
    };
    self.chatTopInfoView.clickCancelLianMai = ^(){
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickCancelLianMai];
    };
    self.chatTopInfoView.clickActivity = ^(){
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickActivity];
    };
    self.chatTopInfoView.stopPlayBgm = ^(){
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickStopBgm];
    };
    self.chatTopInfoView.changeVoice = ^(){
        [ws initChatChangeVoiceView];
    };
}

-(void)initChatConversationView
{
    self.chatConversationView = [[ChatConversationView alloc]init];
    self.chatConversationView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.chatConversationView];
    [self.chatConversationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(-KChatBottomBarHeight-5);
        make.right.offset(- KChatConversationViewToRight);
        make.height.mas_equalTo(KChatConversationViewHeight);
    }];
    KWeakSelf;
    self.chatConversationView.clickUser = ^(NSString *userId){
        [ws.delegate chatView:ws touchIconImageViewWithId:userId];
    };
}


- (void)initFucView{
    
    
//    if (self.chatViewStyle == ChatViewStyleAudience) {
        //主播端
        self.chatFucView = [ChatFucView viewFromeNib];
        self.chatFucView.delegate = self;
        [self addSubview:self.chatFucView];
        KWeakSelf;
        [self.chatFucView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(ws.mas_right).mas_offset(10);
            make.width.mas_equalTo(84);
            make.height.mas_equalTo(242);
            make.centerY.mas_offset(ws.center.y - 66);
            
        }];
        
//    }
    
}

-(void)initChatBottomView
{
    KWeakSelf;
    if (self.chatViewStyle == ChatViewStyleAudience) {
        self.chatBottomView = [[[NSBundle mainBundle]loadNibNamed:@"ChatBottomView" owner:nil options:nil]firstObject];
    }else{
        self.chatBottomView = [[[NSBundle mainBundle]loadNibNamed:@"ChatBottomView" owner:nil options:nil]lastObject];
    }
    self.chatBottomView.clickClose = ^(){
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickClose];
    };
    self.chatBottomView.clickMessage = ^(){
        
        [ws.chatSendMessageView.messsageText becomeFirstResponder];
    };
    self.chatBottomView.clickShare = ^(){
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickShare];
    };
    self.chatBottomView.clickMoreOpition = ^(){
        [ws initMoreOpition];
    };
    self.chatBottomView.clickConversionList = ^(){
        ws.hadUnReadMessage = NO;
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickConversationList];
    };
    self.chatBottomView.clickShow = ^{
        
        
        [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickShow];
    };
    
    self.chatBottomView.delegate = self;
    //防止游戏挡住数据添加到最上层
//    [[UIApplication sharedApplication].keyWindow didAddSubview:self.chatBottomView];
    [self addSubview:self.chatBottomView];
    [self.chatBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(ws);
        make.height.mas_equalTo(KChatBottomBarHeight);
    }];
}

-(void)initMoreOpition{
    if (self.moreOpitionView) {
        [self.moreOpitionView removeFromSuperview];
        return;
    }
    ChatMoreOpitionView *moreOpitionView =   [ChatMoreOpitionView moreOpitionView];
    [self addSubview:moreOpitionView];
    [moreOpitionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    moreOpitionView.delegate = self;
    self.moreOpitionView = moreOpitionView;
}

-(void)chatMoreOpitionView:(ChatMoreOpitionView *)moreOpitionView didClickButton:(UIButton *)button buttonType:(ChatMoreOpitionViewType)opitionViewType{
    self.chatBottomView.moreOption.selected = NO;
    [self.delegate chatView:self clickMoreOpitionViewButtonType:opitionViewType];
}
-(void)initBulletView{
    YZGBulletView *bulletView = [[YZGBulletView alloc]init];
    bulletView.backgroundColor = [UIColor clearColor];
    bulletView.frame = CGRectMake(0, 250, KScreenWidth, 45);
    [self addSubview:bulletView];
    self.bulletView = bulletView;
}
-(void)initAdministratorView{
    ChatAdministratorView *administratorView = [ ChatAdministratorView administratorView];
    administratorView.hidden = YES;
    [self addSubview:administratorView];
    [administratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    KWeakSelf;
    administratorView.clickInterrupt = ^(){
        [ws.delegate chatView:ws clickButton:nil withAdministratorType:ChatAdministratorInterrupt];
    };
    administratorView.clickBlock = ^(){
        [ws.delegate chatView:ws clickButton:nil withAdministratorType:ChatAdministratorBlock];
    };
    administratorView.clickHot = ^(){
        [ws.delegate chatView:ws clickButton:nil withAdministratorType:ChatAdministratorHot];
    };
    self.administratorView = administratorView;
}

-(void)setRoomInfo:(RoomInfo *)roomInfo
{
    _roomInfo = roomInfo;
    self.chatTopInfoView.roomInfo = roomInfo;
    
    
    
    if (roomInfo.advanced_administrator.integerValue ==1) {
        self.administratorView.hidden = NO;
    }else{
        self.administratorView.hidden = YES;
    }
}





-(void)setHadUnReadMessage:(BOOL)hadUnReadMessage{
    _hadUnReadMessage = hadUnReadMessage;
    [self.chatBottomView hadUnReadMessage:hadUnReadMessage];
}
-(void)setActivityinfo:(NSDictionary *)activityinfo{
    _activityinfo = activityinfo;
    self.chatTopInfoView.activityinfo = _activityinfo;
}

#pragma mark ChatFucViewDelegate

- (void)chatFucView:(ChatFucView *)chatFucView didClickShowButton:(UIButton *)showButton{
    [self.delegate chatView:self clickButton:nil withEventType:ChatViewEventClickShow];
}

- (void)chatFucView:(ChatFucView *)chatFucView didClickGameButton:(UIButton *)gameButton{
    
    [self.delegate chatView:self clickGameButton:gameButton];
    
}


- (void)chatFucView:(ChatFucView *)chatFucView didClicLianmaiButton:(UIButton *)lianmai{
    
    [self.delegate chatView:self clickButton:nil withEventType:ChatViewEventClickLianMai];
    
}

- (void)chatFucView:(ChatFucView *)chatFucView didClickShowListButton:(UIButton *)listButton{
    
      [self.delegate chatView:self clickButton:nil withEventType:ChatViewEventClickList];
    
    
}
- (void)chatFucView:(ChatFucView *)chatFucView didClickShowGiftButn:(UIButton *)giftButn{
    
    [self.delegate chatView:self clickButton:nil withEventType:ChatViewEventClickGift];
}

- (void)showGift{
    
    if (self.chatBottomView.isHidden)  return;
    [self addSubview:self.giftListView];
    self.chatBottomView.hidden = YES;
//    self.chatConversationView.hidden = YES;
    
}


#pragma mark ChatBottomViewDelegate

-(void)chatBottomView:(ChatBottomView *)chatBottomView didClickGameButton:(UIButton *)giftButton
{
    [self.delegate chatView:self clickGameButton:giftButton];
}

-(void)chatBottomView:(ChatBottomView *)chatBottomView didClickGiftButton:(UIButton *)giftButton
{
    if (self.chatBottomView.isHidden)  return;
    [self addSubview:self.giftListView];
    self.chatBottomView.hidden = YES;
//    self.chatConversationView.hidden = YES;
}


-(void)chatBottomView:(ChatBottomView *)chatBottomView didClickBgmButton:(UIButton *)bgmButton{
    [self.delegate chatView:self clickButton:bgmButton withEventType:ChatViewEventClickPlayBgm];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.y < self.height - KGiftViewHeight)
    {
        self.chatBottomView.hidden = NO;
        self.chatConversationView.hidden = NO;
        [self.giftListView removeFromSuperview];
    }
}
-(void)startShowAudiences:(NSMutableArray *)audiences{
    [self.chatTopInfoView startShowAudiences:audiences];
}
-(void)clearChatConversionData{
    [self.chatConversationView clearChatConversionData];
}

- (void)hiddenGiftButton{
    self.chatFucView.giftLable.hidden = YES;
    self.chatFucView.gift.hidden = YES;
    
}
- (void)showingGiftButton{
    
    self.chatFucView.giftLable.hidden = NO;
    self.chatFucView.gift.hidden = NO;
}

#pragma mark -
#pragma mark - 更新用户个数和头像

-(void)startShowChatMessage:(ChatMessage *)chatMessage{
    

    //    ChatHadCallComing
    if ([chatMessage.userId isEqualToString:[Account shareInstance].ID]) {
        chatMessage.statusType = ChatSendedMessage;
    }else{
        chatMessage.statusType = ChatReceivedMessage;
    }
    
    ChatMessageType chatMessageType = chatMessage.type;
    switch (chatMessageType) {
        case ChatDanMuMessage:
        {
            [self startShowBroadcastForMessage:chatMessage];
        }
            break;
        case ChatGiftMessage:
        {
            [self startShowGiftAnimationForMessage:chatMessage];
            [self.chatTopInfoView changeTotalEarn:chatMessage.other.totalEarn];
        }
            break;
#pragma mark - 更新用户个数和头像
            
            
        case ChatEnterMessage:
        {
            [self.entranceAnimationView showEntranceAnimationForMessage:chatMessage];
            //此时需要更新头像显示列表
            AudienceInfo *audienceInfo = [[AudienceInfo alloc]initWithAvatar:chatMessage.avatar userLevel:chatMessage.userLevel userId:chatMessage.userId];
            [self.chatTopInfoView addAudience:audienceInfo];
        }
            break;
        case ChatExitMessage:
        {
            [self.chatTopInfoView removeAudienceForUserId:chatMessage.userId];
        }
            break;
        case ChatHostFinishShowingNormal:
        {
            [self.delegate hostFinishShowingNormal];
        }
            break;
        case ChatHostSetGuard:
        {
            BOOL isSelf = [chatMessage.content isEqualToString:[Account shareInstance].ID];
            if (isSelf) {
                [self.delegate hostSetGuard];
            }
        }
            break;
        case ChatHostCancelGuard:
        {
            BOOL isSelf = [chatMessage.content isEqualToString:[Account shareInstance].ID];
            if (isSelf) {
                [self.delegate hostCancelGuard];
            }
        }
            break;
        case ChatHadCallComing:
        {
            
#pragma mark 连麦
            //此时content中包含的id是观众的id(此消息一定是主播发的消息,只有主播才会发此消息,id为主播想要连麦的观众id)
            if (chatMessage.statusType == ChatReceivedMessage) {
                //接受到用户的邀请
                [self.delegate joinUser:chatMessage];
            }
        }
            break;
        case ChatLianMaiDiable:{
            if (chatMessage.statusType == ChatReceivedMessage) {
                //接受到用户的邀请
                if(chatMessage.type == ChatLianMaiDiable){
                    
                    [AlertTool ShowErrorInView:self withTitle:@"连麦申请人数已满"];
                }
            }
            
            
        } break;
            
            //用户接受连麦
        case ChatLianMaiAccept:{
            
            if ([chatMessage.content isEqualToString:[Account shareInstance].ID]) {
                [self.delegate answerCall];
            }
            
        } break;
            
        case ChatRejectComingCall:
        {
            //此时content中包含的id是主播的id(此消息一定是被连麦的观众发的消息,只有被连麦的观众才会发此消息,id为发起连麦申请的主播的id)
            if ([chatMessage.content isEqualToString:[Account shareInstance].ID]) {
                [self.delegate rejectCall];
            }
        }
            break;
        default:
            break;
    }
    //触发kvo,更新数据源
    BOOL isCallComing = chatMessageType == ChatHadCallComing;
    BOOL isRejectComingCall = chatMessageType == ChatRejectComingCall;
    BOOL isUserIdInBlackList = [[LeanCloudTool leanCloudTool] isUserIdInBlackList:chatMessage.userId];
    BOOL isHostSetGuard = chatMessageType == ChatHostSetGuard;
    BOOL isHostCancelGuard = chatMessageType == ChatHostCancelGuard;
    
    if (!isCallComing && !isRejectComingCall && !isUserIdInBlackList&& !isHostSetGuard && !isHostCancelGuard) {
        [self.chatConversationView startShowMessage:chatMessage];
    }
}

/**
 当收到聊天消息是礼物消息时,开始动画
 
 @param chatMessage 消息
 */
-(void)startShowGiftAnimationForMessage:(ChatMessage *)chatMessage{
    //连送消息标识符
    if (chatMessage.other.giftInfo.continuous.integerValue != 0 && chatMessage.userId.length>1) {
        chatMessage.other.giftInfo.continuousIdentifier = [chatMessage.userId stringByAppendingString:[NSString stringWithFormat:@"%@%@",chatMessage.other.giftInfo.giftid,chatMessage.other.giftInfo.continuous]];
    }else if (chatMessage.other.giftInfo.continuous.integerValue != 0){
        NSLog(@"没有用户id!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
    [self.normalGiftAnimationView showNormalAnimationForMessage:chatMessage];
    
    [self.preciousGift showPreciousAnimationForMessage:chatMessage];
}

/**
 显示弹幕消息
 
 @param chatMessage 消息
 */
-(void)startShowBroadcastForMessage:(ChatMessage *)chatMessage{
    [self.bulletView bulletNewMessage:chatMessage];
}

-(void)bgmPlayerIsPlying:(BOOL)isPlying{
    [self.chatBottomView bgmPlayerIsPlying:isPlying];
    [self.chatTopInfoView bgmPlayerIsPlying:isPlying];
}

-(void)startLoadLyrics:(NSArray *)lyrics{
    [self.chatLyricsView startLoadLyrics:lyrics];
}
-(void)currentBgmPlayTime:(float)bgmPlayTime{
    [self.chatLyricsView currentBgmPlayTime:bgmPlayTime];
}
-(void)stopLoadLyrics{
    [self.chatLyricsView stopLoadLyrics];
    [self.chatLyricsView removeFromSuperview];
}

-(void)chatSendMessageView:(ChatSendMessageView *)chatSendMessageView inputTextFieldMoveDistance:(CGFloat)distance{
    self.y = self.y + distance;
}

-(YZGNormalGiftView *)normalGiftAnimationView{
    if (!_normalGiftAnimationView) {
        CGRect frame = CGRectMake(0, self.height - kGiftAnimationViewHeight - kGiftAnimationViewToBottom, KScreenWidth, kGiftAnimationViewHeight);
        YZGNormalGiftView *giftAnimationView = [[YZGNormalGiftView alloc]initWithFrame:frame];
        [self insertSubview:giftAnimationView atIndex:0];
//        [self addSubview:giftAnimationView];
        
        _normalGiftAnimationView = giftAnimationView;
    }
    return _normalGiftAnimationView;
}

-(ChatSendMessageView *)chatSendMessageView{
    if (!_chatSendMessageView) {
        _chatSendMessageView = [ChatSendMessageView chatSendMessageView];
        _chatSendMessageView.delegate = self;
        _chatSendMessageView.frame = CGRectMake(0, self.height - KChatBottomBarHeight, KScreenWidth, KChatBottomBarHeight);
        [self addSubview:_chatSendMessageView];
        KWeakSelf;
        _chatSendMessageView.sendMesssage = ^(NSString *messageString,BOOL isBroadcast){
            [ws.delegate chatView:ws sendMessageString:messageString isBroadcast:isBroadcast];
        };
    }
    return _chatSendMessageView;
}

-(YZGPreciousGiftView *)preciousGift{
    if(!_preciousGift){
        YZGPreciousGiftView *preciousGift = [[YZGPreciousGiftView alloc]init];
        //        preciousGift.backgroundColor = [UIColor orangeColor];
        [preciousGift setFrame:CGRectMake(0, 0, KScreenWidth-0, KScreenHeight-0)];
        [self addSubview:preciousGift];
        //        KWeakSelf;
        //        [preciousGift mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.mas_equalTo(ws);
        //        }];
        _preciousGift = preciousGift;
    }
    return _preciousGift;
}

-(YZGEntranceAnimationView *)entranceAnimationView{
    if(!_entranceAnimationView){
        YZGEntranceAnimationView *entranceAnimationView = [[YZGEntranceAnimationView alloc]init];
        [self addSubview:entranceAnimationView];
        [entranceAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-kGradientAnimationViewToBottom);
            make.height.mas_equalTo(kGradientAnimationViewHeight);
            make.width.mas_equalTo(KScreenWidth);
        }];
        [self layoutIfNeeded];
        _entranceAnimationView = entranceAnimationView;
    }
    return _entranceAnimationView;
}

-(ChatLyricsView *)chatLyricsView{
    if(!_chatLyricsView){
        ChatLyricsView *chatLyricsView = [[ChatLyricsView alloc]init];
        [self addSubview:chatLyricsView];
        [chatLyricsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chatTopInfoView.mas_bottom).offset(20);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(KScreenWidth, 62));
        }];
        _chatLyricsView = chatLyricsView;
    }
    return _chatLyricsView;
}

-(void)initChatChangeVoiceView{
    ChatChangeVoiceView *chatChangeVoiceView = [ChatChangeVoiceView chatChangeVoiceView];
    chatChangeVoiceView.frame = self.bounds;
    [self addSubview:chatChangeVoiceView];
    KWeakSelf;
    chatChangeVoiceView.changeVoice = ^(float value){
        [ws.delegate changeVoice:value];
    };
    _chatChangeVoiceView = chatChangeVoiceView;
}

-(void)lianMaiInvitation:(ChatMessage *)chatMessage{
    
    ChatCallInvitationView *invitation = [ChatCallInvitationView invitationView];
    invitation.messageLabel.text = [NSString stringWithFormat:@"%@申请和你连麦,是否同意", chatMessage.userName];
    [self addSubview:invitation];
    [invitation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 120));
    }];
    KWeakSelf;
    invitation.clickConfirmButton = ^(){
        [ws.delegate answerCall];
    };
    invitation.clickCancelButton = ^(){
        [ws.delegate rejectCall];
    };
}
-(ChatGiftListView *)giftListView{
    if (!_giftListView) {
        ChatGiftListView *giftListView = [ChatGiftListView giftListView];
        [self addSubview:giftListView];
        [giftListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(KGiftViewHeight);
        }];
        KWeakSelf;
        giftListView.didSendedGift = ^(GiftInfo *giftInfo){
            [ws.delegate chatView:ws sendGiftInfo:giftInfo];
        };
        giftListView.clickChongZhi = ^(){
            [ws.delegate chatView:ws clickButton:nil withEventType:ChatViewEventClickChongZhi];
        };
        giftListView.removeGiftListView = ^(){
            ws.chatBottomView.hidden = NO;
            ws.chatConversationView.hidden = NO;
        };
        _giftListView = giftListView;
    }
    return _giftListView;
}

-(void)giftSendSuccess:(BOOL)success{
    if (self.chatBottomView.isHidden) {
        [self.giftListView giftSendSuccess:success];
    }
}

-(void)dealloc
{
    YZGLog(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


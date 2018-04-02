//
//  HostInfoView.m
//  liveFrame
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatTopInfoView.h"
#import "UIImageView+Rouding.h"
#import "RoomInfo.h"
#import "AudienceInfo.h"
#import "ChatAudienceCollectionCell.h"
#import "ChatAudienceCollectionLayout.h"
#import "ShowControlUtilits.h"
@interface ChatTopInfoView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 观众数据
 */
@property (nonatomic , strong) NSMutableDictionary *audienceDictionary;
@property (nonatomic , strong) NSMutableArray *audienceArray;

@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *topRightAudienceView;
@property (weak, nonatomic) IBOutlet UIView *totalIncomeView;
@property (weak, nonatomic) IBOutlet UILabel *benefit;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *attention;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionWidth;
@property (weak, nonatomic) IBOutlet UILabel *audienceCount;
@property (weak, nonatomic) IBOutlet UILabel *hostId;
@property (weak, nonatomic) IBOutlet UIButton *cancelLianMai;
@property (weak, nonatomic) IBOutlet UIButton *activity;
@property (weak, nonatomic) IBOutlet UIButton *stopBgm;
@property (weak, nonatomic) IBOutlet UIButton *voice;

@property (weak, nonatomic)  UICollectionView *audienceCollectionView;


@end

@implementation ChatTopInfoView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.benefit.text = [NSString stringWithFormat:@"%@ 0",kBenefit];
    self.audienceDictionary = [NSMutableDictionary dictionary];
    self.attention.layer.cornerRadius = 10;
    self.attention.layer.masksToBounds = YES;
    [self.avatar roundingImage];
    
    [self collectionView];
    
    [self viewAddUITapGestureRecognizer];
    
    [self totalIncomeViewCornerRadius];
    
    [self addNotiAndObserver];
    self.audienceCount.text = @"  0人  ";
    self.audienceCount.layer.cornerRadius = 8;
    self.audienceCount.clipsToBounds = YES;
    self.audienceCount.font = [UIFont systemFontOfSize:10];
}

-(void)collectionView
{
    ChatAudienceCollectionLayout *layout = [[ChatAudienceCollectionLayout alloc]init];
    self.audienceCollectionView.collectionViewLayout = layout;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.topRightAudienceView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    self.audienceCollectionView = collectionView;
    self.audienceCollectionView.dataSource = self;
    self.audienceCollectionView.delegate  = self;
    [self.audienceCollectionView registerNib:[UINib nibWithNibName:@"ChatAudienceCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ChatAudienceCollectionCell"];
}

-(void)changeTotalEarn:(NSString *)totalEarn{
    if ([totalEarn isKindOfClass:[NSString class]]) {
        self.benefit.text = [NSString stringWithFormat:@" %@:%@",kBenefit,totalEarn];
    }
}

-(void)startShowAudiences:(NSMutableArray *)audiences{
    for (AudienceInfo *audienceInfo in audiences) {
        [self addAudience: audienceInfo];
    }
}

-(void)addAudience:(AudienceInfo *)audience{
    if (!audience.ID) {return;}
    NSInteger lastAudienceCount = self.audienceDictionary.count;
    [self.audienceDictionary setObject:audience forKey:audience.ID];
    NSInteger currentAudienceCount = self.audienceDictionary.count;
    if (currentAudienceCount > lastAudienceCount) {
        [self descendingOrderAudiences];
    }
}
-(void)removeAudienceForUserId:(NSString *)userId{
    //此时需要更新头像显示列表
    if (!userId) {return;}
    
    AudienceInfo * audience = [self.audienceDictionary objectForKey:userId];
    if (audience) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.audienceDictionary.count-1 inSection:0];
        [self.audienceDictionary removeObjectForKey:userId];
        [self.audienceArray removeObject:audience];
        if ([self.audienceCollectionView numberOfItemsInSection:0] == self.audienceArray.count) {
            [self.audienceCollectionView reloadData];
        }else{
            [self.audienceCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        self.audienceCount.text =  [NSString stringWithFormat:@"%zu人",self.audienceDictionary.count];
#pragma mark - 人数更新通知
        
        //人数个数
        NSNotification *notif = [NSNotification notificationWithName:@"userNum" object:self userInfo:@{@"userNum":[NSString stringWithFormat:@"%zu",self.audienceDictionary.count]}];
        [[NSNotificationCenter defaultCenter]postNotification:notif];
        
    }
}



// 以等级进行排序
-(void)descendingOrderAudiences{
    if (self.audienceDictionary.count<=0) return;
    
    NSMutableArray *audiences = [NSMutableArray arrayWithArray:self.audienceDictionary.allValues];
    
    for (NSUInteger i = 0; i < audiences.count - 1; i++)
    {
        for (NSUInteger j = i + 1; j < audiences.count; j++)
        {
            AudienceInfo *firstAudienceInfo = [audiences objectAtIndex:i];
            AudienceInfo *secondAudienceInfo = [audiences objectAtIndex:j];
            if (firstAudienceInfo && secondAudienceInfo)
            {
                NSString *firstAudienceLevel = firstAudienceInfo.user_level;
                NSString *secondAudienceLevel = secondAudienceInfo.user_level;
                BOOL lower = [secondAudienceLevel integerValue]> [firstAudienceLevel integerValue] ;
                if (lower) // 第一人小于第二人，就要进行交换
                {
                    [audiences replaceObjectAtIndex:i withObject:secondAudienceInfo];
                    [audiences replaceObjectAtIndex:j withObject:firstAudienceInfo];
                }
            }
        }
    }
    
    self.audienceArray = audiences;
    [self.audienceCollectionView reloadData];
    self.audienceCount.text =  [NSString stringWithFormat:@"%zu人",self.audienceDictionary.count];
#pragma mark - 发送直播间人数通知
    //人数个数
    NSNotification *notif = [NSNotification notificationWithName:@"userNum" object:self userInfo:@{@"userNum":[NSString stringWithFormat:@"%zu",self.audienceDictionary.count]}];
    [[NSNotificationCenter defaultCenter]postNotification:notif];
}


-(void)addNotiAndObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lianMaiStateDidChange:) name:YZGLianMaiStateChange object:nil];
}

-(void)lianMaiStateDidChange:(NSNotification *)noti{
    YZGLianMaiState lianMaiStateState = [noti.userInfo[YZGLianMaiStateKey] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (lianMaiStateState == YZGLianMaiStateConnected || lianMaiStateState ==YZGLianMaiStartCall){
            self.cancelLianMai.hidden = NO;
        } else{
            self.cancelLianMai.hidden = YES;
        }
    });
}

-(void)viewAddUITapGestureRecognizer{
    
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarTaped)];
    tap.numberOfTapsRequired = 1;
    [self.avatar addGestureRecognizer: tap];
    
    UITapGestureRecognizer *incomeRankTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incomeRank)];
    [self.totalIncomeView addGestureRecognizer:incomeRankTap];
}

-(void)incomeRank{
    if (self.clickIncome) {
        self.clickIncome(self.roomInfo.channel_creater);
    }
}

-(void)setRoomInfo:(RoomInfo *)roomInfo{
    _roomInfo = roomInfo;
    if ([roomInfo.avatar length]>0 &&roomInfo.avatar) {
        [self.avatar sd_setImageWithURL: _roomInfo.avatar];
    }
    [self label:self.hostId setValueWithString:[NSString stringWithFormat:@"ID: %@",_roomInfo.channel_creater] originString:_roomInfo.channel_creater];
    [self label:self.name setValueWithString:_roomInfo.user_nicename  originString:_roomInfo.user_nicename];
    [self label:self.benefit setValueWithString:[NSString stringWithFormat:@" %@:%@ ",kBenefit,_roomInfo.total_earn]originString:_roomInfo.total_earn];
    [self totalIncomeViewCornerRadius];
    if ([_roomInfo.attention_status containsString:@"已关注"]) {
        [self attentionButtonRemove:self.attention];
    }
}

-(void)setActivityinfo:(NSDictionary *)activityinfo{
    _activityinfo = activityinfo;
    self.activity.hidden = NO;
    [self.activity sd_setImageWithURL:[NSURL URLWithString:_activityinfo[@"imgurl"]] forState:UIControlStateNormal];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([change[@"new"] isKindOfClass:[RoomInfo class]]) {
        RoomInfo *roomInfo = change[@"new"];
        [self label:self.audienceCount setValueWithString:[NSString stringWithFormat:@"%lu人",(roomInfo.online_num.integerValue)] originString:roomInfo.online_num];
        if ([roomInfo.total_earn isKindOfClass:[NSString class]]) {
            self.benefit.text = [NSString stringWithFormat:@" %@:%@",kBenefit,roomInfo.total_earn];
        }
        [self totalIncomeViewCornerRadius];
    }
}

-(void)totalIncomeViewCornerRadius{
    [self.totalIncomeView layoutIfNeeded];
    self.totalIncomeView.layer.cornerRadius = self.totalIncomeView.height/2.0;
    self.totalIncomeView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
}

-(void)label:(UILabel *)label setValueWithString:(NSString *)string originString:(NSString *)originString{
    if  (originString.length>0 && originString && ![originString isKindOfClass:[NSNull class]]){
        label.text = string;
    }
}

- (IBAction)attentionButtonClick:(UIButton *)sender
{
    if (self.clickAttention) {
        self.clickAttention(self.roomInfo.channel_creater,sender);
    }
    self.attentionWidth.constant = 0;
}
-(void)attentionButtonRemove:(UIButton *)attentionButton{
    self.attentionWidth.constant = 0;
}

- (IBAction)cancelLianMaiClick:(UIButton *)sender {
    if (self.clickCancelLianMai) {
        self.clickCancelLianMai();
    }
}
- (IBAction)activityClick:(UIButton *)sender {
    if (self.clickActivity) {
        self.clickActivity();
    }
}
- (IBAction)stopPlayBgm:(UIButton *)sender {
    self.stopPlayBgm();
}
- (IBAction)changeBgmVoice:(UIButton *)sender {
    self.changeVoice();
}

-(void)avatarTaped
{
    if (self.clickUserIconImageview) {
        self.clickUserIconImageview(self.roomInfo.channel_creater);
    }
}

-(void)bgmPlayerIsPlying:(BOOL)isPlying{
    if (isPlying){
        self.stopBgm.hidden = NO;
        self.voice.hidden = NO;
    }else{
        self.stopBgm.hidden = YES;
        self.voice.hidden = YES;
    }
}
#pragma mark ====audienceCollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.audienceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatAudienceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatAudienceCollectionCell" forIndexPath:indexPath];
    cell.audienceInfo = self.audienceArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudienceInfo *audienceInfo = self.audienceArray[indexPath.row];
    if (self.clickUserIconImageview) {
        self.clickUserIconImageview(audienceInfo.ID);
    }
}

-(void)dealloc
{
    if (self.chatViewStyle == ChatViewStyleHost) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    YZGLog(@"%@",self);
}
@end

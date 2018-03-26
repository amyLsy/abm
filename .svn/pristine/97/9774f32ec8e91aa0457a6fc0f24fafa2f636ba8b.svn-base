//
//  GameStartTableViewCell.h
//  sisitv_ios
//
//  Created by 悟不透。 on 2017/10/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
#import "LGSelectGameView.h"

typedef void (^GameStartMsgBlock)(id obj, ChatMessageType mType);
typedef void (^GameStartViewBlock)(NSDictionary *d, NSInteger btnTag);
typedef void(^GameUrlBlock)(NSString *url ,NSInteger match_type);


@interface GameStartTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *questionsList;
    NSInteger zb_status; // 主播状态(-1=游戏模式，0=选题类型，1=开始游戏(获取答题id)，2=获取答题列表，3=当前答题中，4=显示答题结果，5=急速答题金额)
    NSInteger gz_status; // 观众状态(0=等待，1=开始答题，2=显示答题结果 5=答题时间已经到 6=已经提交答题 ,7已经排除答题)
    NSTimer *timer;//倒计时
    NSInteger match_type;// 1：普通竞猜， 2：极速玩法， 4：猜歌游戏  5：猜视频
    
    NSString *music_name;//歌曲名称
    NSInteger indexCheck;//当前选中答题下标
    NSString *term_id;// 大题类型
    NSMutableDictionary *questionObj; //当前题目
    int reviveCount;//复活次数
    int mLastAliveNum;//剩余复活次数
    //
    int mpkLastAliveNum;
    __block NSTimer *gzWaitTimer; // 观众等待时间
    int gz_join_time;//等待加入比赛时间（秒）
    int gz_reply_time;//答题时间（秒）
    NSMutableArray *colleViewArray;
    NSInteger colleVArrayType;// collectionView 的类型 0为主分类 2为价格 3-4为子分类
    NSString *url;
    NSInteger dt_status;//
}
@property (weak, nonatomic) IBOutlet UILabel *answerHintsLabel;
@property (weak,nonatomic) IBOutlet UICollectionView *colleView;
@property (weak,nonatomic) IBOutlet UIButton *stateBtn;
@property (weak,nonatomic) IBOutlet UILabel *headTitleLab; // 题目+提示语
@property (weak,nonatomic) IBOutlet UILabel *gmTimerMsg;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *hideTop;
@property (weak,nonatomic) IBOutlet UIButton *hide_button;
@property (weak,nonatomic) IBOutlet UIButton *left_button; // left button
//@property (weak,nonatomic) IBOutlet UIButton *right_button; // right button

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *head_msgbgView_height;

@property (weak,nonatomic) IBOutlet UITableView *tabView; // 题目列表+排名列表
@property (weak,nonatomic) IBOutlet UIView *gmView;
@property (weak,nonatomic) IBOutlet UITextField *gmText;

@property (strong,nonatomic) NSString *gameMatchId;//竞技ID
@property (assign,nonatomic) int join_time;//等待加入比赛时间（秒）
@property (assign,nonatomic) int reply_time;//答题时间（秒）
@property (assign,nonatomic) NSInteger gameRenCount;//游戏人数
@property (assign,nonatomic) BOOL guard_status;//房管(1是，0不是)
//是否主播
@property (assign,nonatomic) BOOL isTheHost;//房管(1是，0不是)

@property (strong,nonatomic) ChatMessage *gameMessage;
@property (nonatomic, copy) GameStartViewBlock gameStartViewBlock;
@property (nonatomic, copy) GameStartMsgBlock gameStartMsgBlock;
@property (strong, nonatomic)GameUrlBlock GameUrlBlock;
@property (nonatomic, copy) NSString *topspeed_price;//极速竞猜扣费金额，整数，普通竞猜时传0或传空
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
//发送消息
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
//显示礼物
@property (weak, nonatomic) IBOutlet UIButton *showGiftBtn;
//用户判断当前视频是否正在播放中
@property (assign,nonatomic) BOOL isPlaying;//房管(1是，0不是)

//选择游戏类型的View
@property (strong, nonatomic)  LGSelectGameView *selectGameView;

@property (strong,nonatomic) UIViewController *presenController;

-(void)gameConnect:(void(^)(BOOL isSuccess, NSString *matchId ,NSString *area_id))completion;
-(void)gamePays;
-(void)httprequestJoinMatch:(void (^)(void))success faile:(void (^)(void))faile;
- (void)resSet;
-(NSDictionary *)tmDict:(NSString *)jsonString;

@end

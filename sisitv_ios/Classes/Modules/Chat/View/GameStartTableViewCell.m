//
//  GameStartTableViewCell.m
//  sisitv_ios
//
//  Created by 悟不透。 on 2017/10/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "GameStartTableViewCell.h"
#import "GameSubjectTableViewCell.h"
#import "UIView+ViewController.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "Account.h"
#import "sCollectionViewCell.h"
#import "JLGameBlanksCell.h"
#import <libksygpulive/KSYMoviePlayerController.h>
#import "CostViewController.h"
#import "ShowControl.h"
#import "LGSelectGameView.h"
#import "GameModelList.h"

//判断当前游戏界面显示的状态状态
typedef NS_ENUM(NSUInteger, GameShowStatus) {
    //展示开始界面
    GameShowBegin = 1,
    //选择主分类
    GameShowType,
    //选择金额
    GameShowPrice,
    //选择子分类
    GameShowSubType,
    //start
    GameShowStart,

};


static NSString *ACellID = @"RXCellID";
#define matchTypeList @[@"百科竞技",@"纯音乐音识曲",@"影音竞技"]//  "type": 1   // (1:百科知识 2:音乐点播 3:视频点播)

#define matchPkList @[@"复活竞技",@"急速竞技"]

@interface GameStartTableViewCell()<LGSelectGameViewDeleaget>

//排除错误的ID
@property(nonatomic, copy) NSString *excloudeAnswerID;
//排除错误答案的文字加横线
//@property(nonatomic, strong) NSMutableAttributedString *excloudeAnswerAttribtStr;
@property (weak, nonatomic) IBOutlet UILabel *gameTileLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameMessageLable;

///当前游戏的主分类
@property (strong, nonatomic) NSMutableArray *topicTypeArray;
///当前游戏主分类的子分类
@property (strong, nonatomic) NSMutableArray *subTypeArray;
//当前选择游戏的价格
@property (strong, nonatomic) NSMutableArray *typePicArray;
//百科竞技下的分类未进行接口化只能存在本地
@property (strong, nonatomic) NSMutableArray *matchPkArray;

//当前游戏显示的状态
@property (assign, nonatomic) GameShowStatus gameShowStatus;

//当前游戏是否选择了pk类型项目
@property (assign, nonatomic) BOOL isPk;

@property (assign, nonatomic) NSInteger game_match_type;

//当前剩余错误次数
@property (assign, nonatomic) NSInteger correct_num;

//当前剩余错误次数
@property (assign, nonatomic) NSInteger error_times;

//当前已经错误的次数
@property (assign, nonatomic) NSInteger cur_error_times;

//可以购买的复活次数
@property (assign, nonatomic) NSInteger canbuytimes;

//剩余的次数
@property (assign, nonatomic) NSInteger canerrortimes;

@property (weak, nonatomic) IBOutlet UIView *selectGameBgView;

@property(strong, nonatomic) GameArea *selectGameArea;





@end

@implementation GameStartTableViewCell

static NSString *blanksCellID = @"blanksCellID";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _hideTop.constant=-KScreenHeight-380;
    [_colleView registerNib:[UINib nibWithNibName:@"sCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ACellID];
    //注册cell
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([JLGameBlanksCell class]) bundle:nil] forCellReuseIdentifier:blanksCellID];
    
 
    
    _tabView.tableFooterView = [UIView new];
    // 告诉tableView的真实高度是自动计算的，根据你的约束来计算
    _tabView.rowHeight = UITableViewAutomaticDimension;
    // 告诉tableView所有cell的估计行高
    _tabView.estimatedRowHeight = 50;
    // 返回估算告诉,作用:在tablView显示时候,先根据估算高度得到整个tablView高,而不必知道每个cell的高度,从而达到高度方法的懒加载调用
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moviePlayBackDidFinish:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    _gameTileLabel.text = @"答题活动";
    
    //加载当前大题
    [self.topicTypeArray addObjectsFromArray:matchTypeList];
    //保存当前pk的分类
    [self.matchPkArray addObjectsFromArray:matchPkList];
    
    colleViewArray = [NSMutableArray array];
    
    _stateBtn.layer.cornerRadius = 2.0;
    _stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _stateBtn.layer.borderWidth = 1.0f;
    
    _left_button.layer.cornerRadius = 2.0;
    _left_button.layer.borderColor = [UIColor blackColor].CGColor;
    _left_button.layer.borderWidth = 1.0f;
    
    _backButton.layer.cornerRadius = 2.0;
    _backButton.layer.borderColor = [UIColor blackColor].CGColor;
    _backButton.layer.borderWidth = 1.0f;
    //先随便设置个默认初始值
    _canerrortimes = 10;
    _canbuytimes = 10;
    
    

    questionObj = [NSMutableDictionary dictionary];
}

- (LGSelectGameView *)selectGameView{
    if (_selectGameView == nil) {
        if (self.guard_status) {
            _selectGameView = [LGSelectGameView viewFromeNib];
            _selectGameView.frame = self.contentView.bounds;
            _selectGameView.presenController = self.presenController;
            [self.contentView addSubview:_selectGameView];
            _selectGameView.delegate = self;
        }
    }
    return _selectGameView;
}




- (void)selectGameView:(LGSelectGameView *)selectGameView selectType:(NSInteger)selectType didClickItem:(GameArea *)gameArea{
    
    _selectGameArea = gameArea;
    switch (selectType) {
        case 0:
            [self btnCloseClick];
            break;
        case 1:
            NSLog(@"进入普通模式");
            _selectGameView.hidden = YES;
            [self statePlays:self.stateBtn];
            break;
        case 2:
            NSLog(@"进入实物区");
            NSLog(@"%@",gameArea.name);
            _selectGameView.hidden = YES;
            [self statePlays:self.stateBtn];
            break;
            
        default:
            break;
    }
    
    
    
}


- (void)setPresenController:(UIViewController *)presenController{
    _presenController = presenController;
    self.selectGameView.presenController = presenController;
}

//播放结束推送题目给玩家
- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    
    if (_game_match_type == 5 || _game_match_type == 4) {
        _isPlaying = NO;
        //视频播放结束开启游戏倒计时
        _gameStartMsgBlock([self tmJson], ChatGameStart);
        // 获取答题题目
        timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self resetGamePay];
        }];

    }
}


- (void)resSet{
    
    
    if (_isTheHost) {
        _stateBtn.hidden = NO;
        match_type = 0;
    }else{
        
        reviveCount = 0;
        
        mLastAliveNum = 5;
        _stateBtn.hidden = YES;
        match_type = 0;
        mpkLastAliveNum = 2;
        self.gameMessageLable.hidden = YES;
        self.videoView.hidden = YES;
        self.answerHintsLabel.hidden = YES;
        _canerrortimes = 10;
        _canbuytimes = 10;
    }
   
}

// 关于按钮超出父视图的范围无法响应点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.hide_button convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.hide_button.bounds, newPoint)) {
            view = self.hide_button;
        }
    }
    return view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setGameMatchId:(NSString *)gameMatchId
{
    _gameMatchId = gameMatchId;
}

-(void)setGameRenCount:(NSInteger)gameRenCount
{
    _gameRenCount = gameRenCount;
}



#pragma mark -m ******************用户收到消息游戏消息*********************
-(void)setGameMessage:(ChatMessage *)gameMessage
{
//    gz_reply_time
    _gameMessage = gameMessage;
    
    self.videoView.hidden = YES;
   
    if (gameMessage.type == ChatGameShowQuest) {
        
        self.hidden = YES;
        _isPlaying = YES;
    }else if (gameMessage.type == ChatGameShowMusic){
       
       //显示播放音乐 猜题正在播放中请稍后答题
//        self.answerHintsLabel.hidden = NO;
//        self.answerHintsLabel.text = @"猜题正在播放中请稍后答题";
        self.videoView.hidden = NO;
        
    }else{
        
       
    }
    
    
    
    if (!_guard_status && _gameMessage.type==ChatGameWait){// 游戏等待
        
        NSDictionary *d = [self tmDict:gameMessage.content];
        _gameMatchId = d[@"match_id"];
        int match_type = [d[@"match_type"] intValue];
        _game_match_type = [d[@"match_type"] integerValue];
        if (match_type==1) {
            _headTitleLab.text = @"游戏规则：\n1、观众接受竞猜答题后，请等待主播发题；\n2、玩家答题后，等待主播发下一题。每个玩家有2次的答错机会，超过2次需金币购买复活卡，每购买一次下次购买自动翻倍，每人限购5次！";
        }else if (match_type==2) {
            _headTitleLab.text = @"极速玩法 游戏规则：\n1、在开始游戏时选择游戏类型为极速竞猜，需要填写房间金额，然后提交开始，这个游戏不用买复活卡，不用押注，不分轮次，最多只能出错5次。";
        }else if (match_type==3){
            _headTitleLab.text = @"猜歌游戏 游戏规则：\n1、类似极速玩法，也是不用买复活卡，不用押注，不分轮次，最多只能出错5次，但在邀请完成后点击开始的时候要填写歌名，观众答题方式是输入歌名，点下一题时要输入歌名再提交下一题.";
        }else if (match_type==4){
            
            _headTitleLab.text = @"猜音乐 游戏规则：\n1、类似极速玩法，也是不用买复活卡，不用押注，不分轮次，最多只能出错5次，但在邀请完成后点击开始的时候要填写名字，观众答题方式是输入答案，点下一题时要输入答案再提交下一题.";
        } else if (match_type==5){
            _headTitleLab.text = @"猜视频 游戏规则：\n1、类似极速玩法，也是不用买复活卡，不用押注，不分轮次，最多只能出错5次，但在邀请完成后点击开始的时候要填写名字，观众答题方式是输入答案，点下一题时要输入答案再提交下一题.";
        }else{
            
            _headTitleLab.text = gameMessage.content;
        }
        
        if (!gzWaitTimer) {
            gz_join_time = [d[@"join_time"] intValue];//等待加入比赛时间（秒）
            gz_reply_time = [d[@"reply_time"] intValue];//答题时间（秒）
            
            __block int t = gz_join_time-2;
            _gmTimerMsg.hidden=NO;
            _gmTimerMsg.text=[NSString stringWithFormat:@"等待游戏开始...%is",t];
            gzWaitTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (t<=0) {
                    _gmTimerMsg.text=[NSString stringWithFormat:@"等待游戏开始...%is", 0];
                    _gmTimerMsg.text = @"等待主播开始游戏";
                    [gzWaitTimer invalidate], gzWaitTimer = nil;
                    return ;
                }
                _gmTimerMsg.text=[NSString stringWithFormat:@"等待游戏开始...%is", t];
                t--;
                
            }];
        }
    }else if (_gameMessage.type==ChatGameStart){// 游戏开始
        _stateBtn.hidden=YES;
        _left_button.hidden=YES;
        if (_guard_status){
            self.gameMessageLable.hidden = YES;
            
        }else{
            

            if (questionsList.count > 1) {
                [_stateBtn setTitle:@"排除答案" forState:UIControlStateNormal];
                _stateBtn.hidden = NO;
            }
//             self.hidden = NO;
            self.hidden = NO;
            _isPlaying = NO;
            // 观众接收到主播发来的题目
            [gzWaitTimer invalidate], gzWaitTimer = nil;
            _tabView.hidden=NO;
            indexCheck=-1;
            _headTitleLab.text=@"";
            [questionsList removeAllObjects];
            [_tabView reloadData];
            
            questionObj = [self tmDict:gameMessage.content];
            if (questionObj) {
                
                if ([questionObj[@"match_type"] isEqual:@"3"]) {
                    _headTitleLab.text=[NSString stringWithFormat:@"%i、猜猜歌名是什么?",[questionObj[@"questions"][@"listorder"] intValue]+1];
                    _gmView.hidden=NO;
                    _tabView.hidden=YES;
                }else{
                    __block int t = gz_reply_time == 0 ? 15:gz_reply_time;
                    _gmTimerMsg.text=[NSString stringWithFormat:@"答题剩余时间...%is",t];
                    _gmTimerMsg.hidden=NO;
                    gz_status = 1;
                    __block NSTimer *yzTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                        if (t--<=0) {
                            [yzTimer invalidate], yzTimer = nil;
                            _gmTimerMsg.text=@"等待主播发题";
                            gz_status = 5;
                            return ;
                        }
                        _gmTimerMsg.text=[NSString stringWithFormat:@"答题剩余时间...%is", t];
                    }];
                    
                    for (NSDictionary *d in questionObj[@"questions"][@"answer_list"]) {
                        [questionsList addObject:d];
                    }
                    gz_status=1;
                    if (questionsList.count > 1) {
                        [_stateBtn setTitle:@"排除答案" forState:UIControlStateNormal];
                        _stateBtn.hidden = NO;
                    }
                    
                    [_tabView reloadData];
                }
            }
        }
    }else if (_guard_status && _gameMessage.type==ChatGameAdd){// 玩家加入游戏
        _gameRenCount+=1;
    }else if (_guard_status && _gameMessage.type==ChatGameQuit && _gameRenCount>0){// 玩家退出游戏
        _gameRenCount-=1;
    }else if (_gameMessage.type==ChatGameStop || _gameMessage.type==ChatGameFail){// 游戏结束重置
        NSLog(@"游戏结束");
        
        
    }else if (!_guard_status && _gameMessage.type==ChatGameStake){// 游戏等待押注
        if (!_tabView.hidden) {
            _headTitleLab.text=@"等待玩家押注;";
            _tabView.hidden=YES;
            [self errorMsg:@"等待押注..."];
            __block int t = 30;
            _gmTimerMsg.text=[NSString stringWithFormat:@"等待押注...%is",t];
            _gmTimerMsg.hidden=NO;
            __block NSTimer *yzTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (t--<=0||!_tabView.hidden) {
                    _gmTimerMsg.text= @"等待主播停止压住";
                    [yzTimer invalidate], yzTimer = nil;
                }
                _gmTimerMsg.text=[NSString stringWithFormat:@"等待押注...%is", t];
            }];
        }
    }else if(!_guard_status && _gameMessage.type==ChatGameRanking){
        _headTitleLab.text=@"";
        _gmTimerMsg.hidden=YES;
        [self resSet];
        [questionsList removeAllObjects];
        [_tabView reloadData];
        [self btnZoomClick];
    }
}

-(void)setGuard_status:(BOOL)guard_status
{
    _guard_status = guard_status;
    [self.selectGameView.collectionView reloadData];
    if (!questionsList)
        questionsList = [[NSMutableArray alloc] init];
    
    indexCheck = -1;
    if (_guard_status) {
        _showGiftBtn.hidden = YES;
        //        zb_status = -1;
        //        for (NSString *s in matchTypeList)
        //        {
        //            [questionsList addObject:s];
        //        }
        //        [_tabView reloadData];
    }else{
        
        mLastAliveNum = 5;
        _gmTimerMsg.hidden=YES;
    }
}

-(NSDictionary *)tmDict:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSString*)tmJson
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData;
    if (questionObj == nil) {
        jsonData = [NSJSONSerialization dataWithJSONObject:@{}
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }else{
        
       jsonData = [NSJSONSerialization dataWithJSONObject:questionObj
                                          options:NSJSONWritingPrettyPrinted
                                            error:&error];
    }
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

// 主播答题开启
-(void)gamePays
{
    //开启游戏成功之后回调
    [self convToOngoingStatus:^{
        
        if ([questionObj[@"match_type"] isEqual:@"3"]) {
            _headTitleLab.text = [NSString stringWithFormat:@"竞猜歌名：%@",music_name];
            _gameTileLabel.text = @"答题活动";
        } else if ([questionObj[@"match_type"] isEqual:@"4"]) {
            _headTitleLab.text = [NSString stringWithFormat:@"竞视频名：%@",music_name];
            _gameTileLabel.text = @"答题活动";
        }else{
            _gameTileLabel.text = @"答题活动";
        }
        
        // 推送题目给游戏玩家
        
        //设置当前状态为答题中
        zb_status=3;
        //当前选中答案的小标
        indexCheck=-1;
        //答题时间
        _stateBtn.tag=_reply_time;
        //如果当前有mv或者mp3则加载播放器啊
        if (_GameUrlBlock) {
            _GameUrlBlock(url,_game_match_type);
        }
        //回调状态
       
        [_tabView reloadData];
        
        
        //非视频或者音乐题目
        
        if([url isKindOfClass:[NSNull class]]) {
            
            _gameStartMsgBlock([self tmJson], ChatGameStart);
            // 获取答题题目
            timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self resetGamePay];
            }];
            
        }else{
            
           _gmTimerMsg.text=@"答题播放中";
        }
        
       
      
        
       
    }];
}

-(void)resetGamePay
{
    //    _head_msgbgView_height.constant=35;
    //    _right_button.hidden=YES;
    
    // 倒计时
    if (questionsList.count <= 1) {
        
        _stateBtn.hidden=YES;
    }
    _gmTimerMsg.hidden=NO;
    _gmTimerMsg.text=[NSString stringWithFormat:@"答题剩余时间...%@s",@(_stateBtn.tag--)];
    
    if (_stateBtn.tag <= -1) {
        //取消定时器
        [timer invalidate], timer = nil;
        _gmTimerMsg.text=@"主播请发题";
        _stateBtn.hidden=NO;
        [_stateBtn setTitle:@"下一题" forState:UIControlStateNormal];
        
        
        if (_GameUrlBlock) {
            _GameUrlBlock(nil,1);
        }
    }
}

-(void)errorMsg:(NSString *)m
{
    [AlertTool ShowErrorInView:self.window withTitle:m];
}

-(IBAction)btnHelpClick
{
    _gameStartViewBlock(nil, 0);
}

-(IBAction)btnZoomClick
{
    _gameStartViewBlock(nil, 1);
}

-(IBAction)btnCloseClick
{
    _gameStartViewBlock(nil, 3);
    if (_isTheHost == YES) {
        
        [self.selectGameView resSet];
        self.selectGameView.hidden = NO;
        [_selectGameView.collectionView reloadData];
        _headTitleLab.text=@"*请点击 开始游戏";
        [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
        _colleView.hidden=NO;
        _left_button.hidden=NO;
        _gmTimerMsg.hidden=YES;
        questionObj = nil;
        [[ShowControl shareInstance].streamerKit stopPip];
        [questionsList removeAllObjects];
        [colleViewArray removeAllObjects];
        [self.tabView reloadData];
        [self.colleView reloadData];
        _stateBtn.hidden = NO;
        _topspeed_price = nil;
        match_type = 0;
        colleVArrayType = 0;
        _isPk = NO;
        
    }
   
}

#pragma mark - 数据源方法 tableview delegate

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return questionsList.count;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    
    
    NSString *mTypeStr = @"问题：";
    if (match_type==1) {
        
        mTypeStr = [NSString stringWithFormat:@"第%@轮竞猜 问题：",questionObj[@"turn"]];
    }
    //题目名称
    NSInteger listorder0 = [questionObj[@"questions"][@"listorder"] integerValue]+1;
    _headTitleLab.text = [NSString stringWithFormat:@"%@%ld、%@", mTypeStr,listorder0,questionObj[@"questions"][@"name"]];
    _answerHintsLabel.hidden = YES;
    
    if (questionsList.count == 1) {
        
        //则显示填空题
        JLGameBlanksCell *cell = [tableView dequeueReusableCellWithIdentifier:blanksCellID];
        [cell.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        cell.submitButton.enabled = YES;
        cell.answerTextFiekd.enabled = YES;
        cell.backgroundColor = [UIColor clearColor];
        KWeakSelf;
    
        // 主播显示正确答案
        if (_guard_status == YES) {
            BOOL is_correct = [questionsList[indexPath.row][@"is_correct"] boolValue];
            if (is_correct) {
                self.answerHintsLabel.hidden = NO;
                self.answerHintsLabel.text = [NSString stringWithFormat:@"本题答案:%@",questionsList[indexPath.row][@"name"]];;
            }
        }
        cell.submitBlock = ^(UIButton *btn ,UITextField *answerTextField){
            
            if (gz_status == 5) {
                
                
                [self errorMsg:@"答题时间已过!请等待主播发题即可答题!"];
                return;
            }
            
            if (zb_status==3){
                [self errorMsg:@"主播不能答题!"];
                return;
            }
            
            
            if (!answerTextField.text.length) {
                
                [ws errorMsg:@"答案不能为空"];
                
                return;
            }
            
            //提交答案
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = [Account shareInstance].token;
            //竞猜id
            param[@"match_id"] = questionObj[@"match_id"];
            //题目id
            param[@"quest_id"] = questionsList[0][@"question_id"];
            //选择的答案id
            param[@"answer_id"] = questionsList[0][@"answer_id"];
            param[@"answer"] = answerTextField.text;
            //填空的答案
            param[@"music_name"] = questionsList[0][@"name"];
            
            [self replyQuestion:param e:NO cell:cell indexCheck:indexPath.row];
            
//            [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserBlanks param:param success:^(id responseObject) {
//
//                if ([responseObject[@"code"] isEqual:@200])
//                {
//                    [AlertTool alertWithControllerTitle:@"提示" alertMessage:responseObject[@"descrp"] withActionTitle:@"确定" handler:nil];
//                    answerTextField.enabled = NO;
//                    btn.enabled = NO;
//                    [btn setTitle:@"已提交" forState:UIControlStateNormal];
//                    ws.answerHintsLabel.hidden = NO;
//                    self.gameMessageLable.hidden = NO;
//                    _canbuytimes = [responseObject[@"canbuytimes"] integerValue];
//                    if (_game_match_type == 1) {
//                        _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
//                        self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
//                    }else{
//
//                        _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
//                        self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
//                    }
//
//                    if ([responseObject[@"is_correct"] boolValue] == YES) {
//                        ws.answerHintsLabel.text = @"回答正确！";
//                    }else{
//
//                        ws.answerHintsLabel.text = @"回答错误！";
//                    }
//
//                }
//                else
//                {
//                    [ws errorMsg:responseObject[@"descrp"]];
//                }
//
//            } faile:^{
//
//            }];
//
//
        };
//
        
        return cell;
        
    }else{
        
        static NSString *ideitifier = @"subjectCell";
        GameSubjectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        NSInteger listorder1 = [questionsList[indexPath.row][@"listorder"] integerValue]+1;

        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GameSubjectTableViewCell" owner:nil options:nil] firstObject];
        }
        // 主播显示正确答案
        if (_guard_status == YES) {
            BOOL is_correct = [questionsList[indexPath.row][@"is_correct"] boolValue];
            if (is_correct) {
                self.answerHintsLabel.hidden = NO;
                self.answerHintsLabel.text = [NSString stringWithFormat:@"本题答案:%@",questionsList[indexPath.row][@"name"]];;
            }
        }
        if (_guard_status)
        {
            if (zb_status==3) {
                
                //                if (!_excloudeAnswerID.length) {
                cell.subjectLab.text = [NSString stringWithFormat:@"%ld、%@",listorder1,questionsList[indexPath.row][@"name"]];
                cell.answerId = questionsList[indexPath.row][@"answer_id"];
                //                }else{
                
                //                    cell.subjectLab.attributedText = _excloudeAnswerAttribtStr;
                //                }
                
                if ([questionsList[indexPath.row][@"answer_id"] integerValue] == [_excloudeAnswerID integerValue]) {
                    cell.subjectCheckImage.image=[UIImage imageNamed:@"选中题目错误"];
                }
                
                
            
            }
            else if (zb_status==4){
                // 显示答题结果
                cell.subjectLab.text = [NSString stringWithFormat:@"%ld、%@",listorder1,questionsList[indexPath.row][@"name"]];
            }
            
        }
        else
        {
            if (gz_status==1 || gz_status == 7) {
                
                //排除这个方法不用了
                if ([questionObj[@"match_type"] isEqual:@"789"]) {
                    cell.subjectLab.text = @"猜猜是什么?";
                    
                    if (questionsList.count == 1) {
                        cell.subjectLab.text = @"";
                    }
                    
                }else{
                    NSInteger listorder0 = [questionObj[@"questions"][@"listorder"] integerValue]+1;
                    NSInteger listorder1 = [questionsList[indexPath.row][@"listorder"] integerValue]+1;
                   
//                    if (<#condition#>) {
//                        <#statements#>
//                    }
                    
                    NSInteger mType = [questionObj[@"match_type"] integerValue];
                    NSString *mTypeStr = @"问题：";;
                    if (mType==1) {
                        mTypeStr = [NSString stringWithFormat:@"第%@轮竞猜 题目：",questionObj[@"turn"]];
                    }
                    _headTitleLab.text = [NSString stringWithFormat:@"%@%ld、%@", mTypeStr, listorder0, questionObj[@"questions"][@"name"]];
                    cell.subjectLab.text = [NSString stringWithFormat:@"%ld、%@", listorder1, questionsList[indexPath.row][@"name"]];
                    if (indexCheck==indexPath.row) {
                        cell.subjectCheckImage.hidden = NO;
                    }
                    if ([questionsList[indexPath.row][@"answer_id"] integerValue] == [_excloudeAnswerID integerValue]) {
                        cell.subjectCheckImage.image=[UIImage imageNamed:@"选中题目错误"];
                        cell.subjectCheckImage.hidden = NO;
                        gz_status = 7;
                    }
                    
                }
            }
            else{
                // 显示答题结果
                cell.subjectLab.text = [NSString stringWithFormat:@"%ld、%@",listorder1,questionsList[indexPath.row][@"name"]];
            }
        }
        
        
        self.answerHintsLabel.hidden = !_guard_status;
        
        return cell;
    }
    
    
    
    
    
}

// 选中某行cell时会调用
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UITableViewCell *selectdCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectdCell isKindOfClass:[JLGameBlanksCell class]]) {
        
        
        return;
    }
    
    if (gz_status == 5) {
        
        
        [self errorMsg:@"答题时间已过!请等待主播发题即可答题!"];
        return;
    }
    
    
    if (indexCheck==-2||zb_status==4||gz_status==2)
        return;
    
    if (_guard_status)
    {
        if (zb_status==-1) {
            match_type = indexPath.row+1;
            _topspeed_price = @"0";
            if (indexPath.row==0) {
                
            }else{
                //                [self getMatchPrice];
                //                [AlertTool alertWithTitle:nil message:@"请输入歌名" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
                //                    if (index==1 && textFiled.text.length>0) {
                //                        music_name = textFiled.text;
                //                        [self startMatch:^{
                //                            _right_button.hidden=YES;
                //                            _gameStartMsgBlock(nil, ChatGameWait);
                //                        }];
                //                    }else{
                //                        match_type = 0;
                //                        music_name = @"";
                //                    }
                //                } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self.viewController otherButtonTitles:nil, nil];
            }
            return;
        }
        else if (zb_status==5){
//            topspeed_price = questionsList[indexPath.row][@"price"];
            if (match_type==3 || match_type==4) {
                [AlertTool alertWithTitle:nil message:@"请输入名字" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
                    if (index==1 && textFiled.text.length>0) {
                        music_name = textFiled.text;
                        [self startMatch:^{
                            _stateBtn.hidden=YES;
                            _gameStartMsgBlock(nil, ChatGameWait);
                        }];
                    }else{
                        match_type = 0;
                        music_name = @"";
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self.viewController otherButtonTitles:nil, nil];
            }
        }
        else if (zb_status==3){
            [self errorMsg:@"主播不能答题!"];
            return;
        }
        indexCheck=-1;
        [_tabView reloadData];
    }
    
    if (indexCheck==-1)
    {
        GameSubjectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.subjectCheckImage.hidden == NO) {
            
            [self errorMsg:@"不能提交已排除的答案!"];
            return;
        }
        
//        cell.subjectCheckImage.hidden = NO;
        indexCheck=indexPath.row;
        
        // 普通,急速竞猜模式，需要购买复活卡
        int matchType = [questionObj[@"match_type"] intValue];
        if (!_guard_status && matchType<=5){
            NSDictionary *tDict = questionsList[indexPath.row];
            BOOL is_correct = [tDict[@"is_correct"] boolValue];
            gz_status = 7;
            if (!is_correct) {
                // 选中不正确
//                cell.subjectCheckImage.image = [UIImage imageNamed:@"选中题目错误"];
                
                 [self replyQuestion:tDict e:NO cell:cell indexCheck:indexCheck];
                
                return;
                
                if (_game_match_type ==1) {
                    // 普通竞猜
                    reviveCount += 1;
                    
                    // 请复活后答题
                    if (_canbuytimes <= 0){
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"答题错误" message:@"您已经没有复活次数啦！" preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [controller addAction:cancleAction];
                        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
                        
                        return;
                    }
                    if (_canerrortimes <= 0)
                    {
                        
//                        NSString *m = [NSString stringWithFormat:@"请购买复活卡后答题，每人有2次免费复活机会；超过2次需用金币购买复活卡，限购5次机会！您还可购买%zd次复活卡。", _canbuytimes];
//                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"答题错误" message:m preferredStyle:UIAlertControllerStyleActionSheet];
//                        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"购买复活卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                            //
//                            //购买复活卡
//                            [self replyQuestion:tDict e:YES cell:cell indexCheck:indexCheck];
//
//
//                        }];
//                        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"不购买" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                            reviveCount -= 1;
//                        }];
//                        [controller addAction:takePhotoAction];
//                        [controller addAction:cancleAction];
//                        [self.topViewController presentViewController:controller animated:YES completion:nil];
                        
                        return;
                    }else{
                         [self replyQuestion:tDict e:NO cell:cell indexCheck:indexCheck];
//                        [self replyQuestion:tDict e:NO];
                    }
                }else{
                    // 急速竞猜
                    if (_error_times > 5) {
                       
                        _gameMessageLable.text = @"你已经被淘汰";
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经被淘汰" preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self replyQuestion:tDict e:NO];
                        }];
                        [controller addAction:takePhotoAction];
                        [self.topViewController presentViewController:controller animated:YES completion:nil];
                        
                        return;
                    }
                   //显示答题
                     [self replyQuestion:tDict e:NO cell:cell indexCheck:indexCheck];
                    
                    
                }
            }else{
                 [self replyQuestion:tDict e:NO cell:cell indexCheck:indexCheck];
            }
        }
    }
}


- (void)replyQuestion:(NSDictionary *)tDict e:(BOOL)e cell:(GameSubjectTableViewCell *)cell indexCheck:(NSInteger)index{
//     param[@"answer"] = answerTextField.text;
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,
                        @"match_id":questionObj[@"match_id"],//竞猜id
                        //                        @"quest_id":(tDict)?tDict[@"question_id"]:@"",//题目id
                        @"quest_id":questionObj[@"questions"][@"quest_id"],//题目id
                        @"answer_id":(tDict[@"answer_id"])?tDict[@"answer_id"]:@"",//选择的答案id
                        @"times":(e)?@1:@0, //复活次数
                        @"music_name":(tDict[@"music_name"])?tDict[@"music_name"]:@"",//歌曲名称
                        @"answer":(tDict[@"answer"])?tDict[@"answer"]:@"" //填空题答案
                        };
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagReplyQuestion param:d success:^(id responseObject) {
        
        
        if ([responseObject[@"code"] integerValue] == 508) {
           //
            NSString *m = responseObject[@"descrp"];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:m preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                //
//                //购买复活卡
//                CostViewController *costViewController = [[CostViewController alloc]init];
//                 [self.topViewController presentViewController:costViewController animated:YES completion:nil];
//
//            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                reviveCount -= 1;
            }];
//            [controller addAction:takePhotoAction];
            [controller addAction:cancleAction];
            [self.topViewController presentViewController:controller animated:YES completion:nil];
            
            
            
            return;
        }
        
        
        
        if ([responseObject[@"code"] integerValue] == 509) {
            
            
            NSString *m = responseObject[@"descrp"];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"答题错误" message:m preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"购买复活卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //
                //购买复活卡
                [self replyQuestion:tDict e:YES cell:cell indexCheck:index];
                
                
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"不购买" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                reviveCount -= 1;
            }];
            [controller addAction:takePhotoAction];
            [controller addAction:cancleAction];
            [self.topViewController presentViewController:controller animated:YES completion:nil];
            
            
            return ;
        }
        
        //        NSLog(@"观众提交答题结果===%@==%@==%@", d,responseObject,responseObject[@"descrp"]);
        if ([responseObject[@"code"] isEqual:@200])
        {
            gz_status = 6;
            NSString *descrp = responseObject[@"descrp"];
            self.gameMessageLable.hidden = NO;
            _canbuytimes = [responseObject[@"canbuytimes"] integerValue];
            if (_game_match_type == 1) {
                _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
                self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
            }else{
                
                _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
                self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
            }
           
            if ( [responseObject[@"is_correct"] boolValue] == YES) {
                descrp= @"回答正确";
                
                if ([cell isKindOfClass:[JLGameBlanksCell class]]) {
                    JLGameBlanksCell *jlCell = (JLGameBlanksCell *)cell;
                    //填空题
                    jlCell.submitButton.enabled = NO;
                    [jlCell.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
                }else{
                    //选择题
                    
                   cell.subjectCheckImage.hidden = NO;
                }
                
                
                indexCheck = index;
            }else{
                if ([cell isKindOfClass:[JLGameBlanksCell class]]) {
                    //填空题
                    JLGameBlanksCell *jlCell = (JLGameBlanksCell *)cell;
                    //填空题
                    jlCell.submitButton.enabled = NO;
                    [jlCell.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
                }else{
                    //选择题
                    
                    cell.subjectCheckImage.hidden = NO;
                    cell.subjectCheckImage.image = [UIImage imageNamed:@"选中题目错误"];
                }
               
                
            }
            [self errorMsg:descrp];
        }
        else{
            
            NSString *descrp = responseObject[@"descrp"];
            [self errorMsg:descrp];
            
        if ([descrp hasPrefix:@"淘汰"]) {
            [self btnCloseClick];
        }
        }
    } faile:^{
        
    }];
    
};


// 改竞猜状态为进行中
-(void)convToOngoingStatus:(void (^)(void))ret
{
    [AlertTool ShowInView:self.window withTitle:@"开始游戏竞猜"];
    
    
    NSDictionary *d = @{
                        @"match_id":questionObj[@"match_id"],//竞猜id
                        @"muisc_name":(music_name)?music_name:@""//歌曲名称"
                        };
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagConvToOngoingStatus param:d success:^(id responseObject) {
        
        [AlertTool Hidden];
        
        if ([responseObject[@"code"] isEqual:@200])
        {
            _gameMatchId = responseObject[@"match_id"];
            //获取题目
            questionObj = responseObject;
            [questionsList removeAllObjects];
            //加载完题目显示排除错误答案按钮
            [_tabView reloadData];
            
            if (![responseObject[@"questions"] isKindOfClass:[NSNull class]])
            {
                NSArray *list = questionObj[@"questions"][@"answer_list"];
                for (NSDictionary *d in list) {
                    [questionsList addObject:d];
                }
                _game_match_type = [questionObj[@"match_type"] integerValue];
                ret();
            }else{
                [self errorMsg:@"获取题目失败"];
            }
        }
        else
        {
            [self errorMsg:responseObject[@"descrp"]];
        }
    } faile:^{
    }];
}




// 开始游戏竞猜
-(void)startMatch:(void (^)(void))ret
{
    [AlertTool ShowInView:self.window withTitle:@"开始游戏竞猜"];
    NSInteger matchType;
    if (_isPk) {
        matchType = match_type;
    }else{
        
        if(match_type == 2 || match_type == 3) {
            matchType = match_type + 2;
        } else {
            matchType = match_type;
        }
    }

    _isPk = NO;
    
    NSString *area_id = _selectGameArea ? _selectGameArea.ID:@"";
    
    
    if (self.selectGameArea) {
        _topspeed_price = self.selectGameArea.diamond_num;
    }
    
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,//主播令牌
                        @"match_type": @(matchType),//竞猜类型，1：普通竞猜， 2：极速玩法
                        @"topspeed_price": (_topspeed_price)?_topspeed_price:@"",//极速竞猜扣费金额，整数，普通竞猜时传0或传空
                        @"term_id":(term_id)?term_id:@"",// 题目分类
                        @"area_id":area_id
                        };
    //获取
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagStartMatch param:d success:^(id responseObject) {
        
        [AlertTool Hidden];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqual:@200])
        {
            self.gameShowStatus = GameShowStart;
            _join_time = [responseObject[@"join_time"] intValue];//等待加入比赛时间（秒）
            _reply_time = [responseObject[@"reply_time"] intValue];//答题时间（秒）
            _gameMatchId = responseObject[@"match_id"];
            questionObj = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [questionsList removeAllObjects];
            [_tabView reloadData];
            _stateBtn.tag=-1;
            _stateBtn.hidden=YES;
            
            //            if (match_type==3 || match_type==4) {
            //                ret();
            //                return ;
            //            }
            if (![responseObject[@"questions"] isKindOfClass:[NSNull class]]) {
                
                
                
                NSArray *list = questionObj[@"questions"][@"answer_list"];
                url = questionObj[@"questions"][@"uri"];
                
                for (NSDictionary *d in list) {
                    [questionsList addObject:d];
                }
                if (_selectGameArea) {
                    questionObj[@"bigType"] = @"2";
                    
                    questionObj[@"gif"] =  [_selectGameArea mj_keyValues];
                }else{
                    questionObj[@"bigType"] = @"1";
                    
                }
                _game_match_type = [questionObj[@"match_type"] integerValue];
                _gameStartMsgBlock([self tmJson], ChatGameWait);
                NSLog(@"%@",[self tmJson]);
                
            }else{
                [self errorMsg:@"获取题目失败"];
            }
        }
        else
        {
            [self errorMsg:responseObject[@"descrp"]];
        }
    } faile:^{
        
        [self errorMsg:@"请重试..."];
    }];
}

// 主播点击完成答题，获取本轮游戏结果

#pragma mark ************ 下一题推送题目给用户判断是否结束当前游戏 **********

-(void)finishReplyQuest
{
    [AlertTool ShowInView:self.window withTitle:@"加载下一题"];
    
    NSDictionary *d = @{
                        @"channel_id":questionObj[@"channel_id"],//直播间id
                        @"match_id":questionObj[@"match_id"],//竞猜id
                        @"match_quest_id":questionObj[@"questions"][@"match_question_id"],//题目id
                        @"music_name":(music_name)?music_name:@""//歌曲名
                        };
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagFinishReplyQuest param:d success:^(id responseObject) {
        NSLog(@"点击完成答题，获取本轮游戏结果===%@==%@", d,responseObject);
        
        [AlertTool Hidden];
        if ([responseObject[@"code"] isEqual:@200])
        {
            _stateBtn.hidden = YES;
            questionObj = responseObject;
            [timer invalidate], timer = nil;
            _headTitleLab.text = @"";
            
            indexCheck=-1;
            _stateBtn.tag=_reply_time;
            [questionsList removeAllObjects];
            [_tabView reloadData];
            
            if (responseObject[@"user_list"]) {
                _gameStartMsgBlock([self tmJson], ChatGameList);
            }
            
            // 推送题目给游戏玩家, match_status返回：2，进行中，3，押注中，4，结束
            int match_status = [responseObject[@"match_status"] intValue];
            NSArray *list = nil;
            if(![questionObj[@"questions"] isKindOfClass:[NSNull class]]){
                
                _game_match_type = [questionObj[@"match_type"] integerValue];
                url = questionObj[@"questions"][@"uri"];
                _GameUrlBlock(url,_game_match_type);
                list = questionObj[@"questions"][@"answer_list"];
                for (NSDictionary *d in list) {
                    [questionsList addObject:d];
                   
                }
                [_tabView reloadData];
            }else{
//                    questionObj = @{@"user_list":responseObject[@"user_list"]};
//                    _gameStartMsgBlock([self tmJson], ChatGameRanking);
//                    [self btnCloseClick];
//                    [self errorMsg:@"答题结束"];
//                    return ;
            }
            if (match_status==2||match_status==5) {
                                if(![questionObj[@"questions"] isKindOfClass:[NSNull class]]){
                //                    NSArray *list = questionObj[@"questions"][@"answer_list"];
                //                    for (NSDictionary *d in list) {
                //                        [questionsList addObject:d];
                                    }
                //                    [_tabView reloadData];
                //把游戏节目以消息的节目推送给用户
                if(list && list.count>0){
                    
                    if([url isKindOfClass:[NSNull class]]) {
                     
                        _gameStartMsgBlock([self tmJson], ChatGameStart);
                        timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                            [self resetGamePay];
                        }];
                        
                    }else{
                        _gmTimerMsg.text=@"答题播放中";
                    }
                }
            }else if(match_status==3) {
                // 推送押注
                [self errorMsg:@"等待押注..."];
                
                __block int t = 1;
                _gmTimerMsg.text=@"等待押注...59s";
                _gmTimerMsg.hidden=NO;
                __block NSTimer *yzTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    
                    questionObj = @{
                                    @"match_id":questionObj[@"match_id"],
                                    @"user_list":responseObject[@"user_list"]
                                    };
                    _gameStartMsgBlock([self tmJson], ChatGameStake);// 等待押注
                    
                    if (t--<=0) {
                        [yzTimer invalidate], yzTimer = nil;
                        [_stateBtn setTitle:@"停止押注" forState:UIControlStateNormal];
                        _gmTimerMsg.text=@"主播停止押注";
                        _stateBtn.hidden=NO;
                        
                        return ;
                    }
                    _headTitleLab.text=@"* 等待玩家押注";
                    _tabView.hidden=YES;
                    _stateBtn.hidden=YES;
                    _gmTimerMsg.text=[NSString stringWithFormat:@"等待押注...%is", t];
                }];
            }else if(match_status==4) {
                
                // 游戏完结,显示排名
                questionObj = @{
                                @"user_list":responseObject[@"user_list"],
                                @"results":responseObject[@"results"]
                                };
                _gameStartMsgBlock([self tmJson], ChatGameRanking);
                
                //                int match_t = [responseObject[@"match_type"] intValue];
                //                if (match_type==1)
                //                {
                // 押注模式，主播显示收益
                _stateBtn.hidden = NO;
                _isPlaying = NO;
                NSDictionary *res = responseObject[@"results"];
                NSString *msg = [NSString stringWithFormat:@"当前游戏收益情况：\n参赛人数：%@\n平台收益：%@\n主播收益：%@\n押注金币总数：%@\n购买复活卡金币总数：%@\n参赛金币总数：%@",res[@"join_number"],res[@"platform_earn"],res[@"anchor_earn"],res[@"stake"],res[@"buy_card"],res[@"join_money"]];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"答题结束" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIView *subView1 = alertController.view.subviews[0];
                UIView *subView2 = subView1.subviews[0];
                UIView *subView3 = subView2.subviews[0];
                UIView *subView4 = subView3.subviews[0];
                UIView *subView5 = subView4.subviews[0];
                UILabel *message = subView5.subviews[1];
                message.textAlignment=UITextAlignmentLeft;
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okAction];
                [self.window.topViewController presentViewController:alertController animated:YES completion:nil];
                
                
                //                }
                //                else
                //                {
                //                    [[[UIAlertView alloc] initWithTitle:nil message:@"答题结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                //                }
                
                _headTitleLab.text=@"*请点击 开始游戏";
                [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
                _colleView.hidden=NO;
                _left_button.hidden=NO;
                _gmTimerMsg.hidden=YES;
                questionObj = nil;
                [[ShowControl shareInstance].streamerKit stopPip];
             
                [questionsList removeAllObjects];
                [colleViewArray removeAllObjects];
                [self.tabView reloadData];
                [self.colleView reloadData];
                [self resSet];
                [self btnCloseClick];
                _stateBtn.hidden = NO;
                self.gameMessageLable.hidden = YES;
                self.answerHintsLabel.hidden = YES;
                [self btnZoomClick];
            }
        }
        else
        {
            [self errorMsg:responseObject[@"descrp"]];
        }
    } faile:^{
        [self errorMsg:@"请重试..."];
    }];
}

// 观众加入竞技游戏
-(void)httprequestJoinMatch:(void (^)(void))success faile:(void (^)(void))faile
{
    if(!_gameMatchId){
        return;
    }
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,
                        @"match_id":_gameMatchId//竞猜id
                        };
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagJoinMatch param:d success:^(id responseObject) {
        if ([responseObject[@"code"] isEqual:@200]){
            success();
        }
        else if([responseObject[@"code"] isEqual:@509]){
             [self errorMsg:@"正在重新加入..."];
             success();
        }else{
            
            [self errorMsg:responseObject[@"descrp"]];
            faile();
        }
    } faile:^{
        [self errorMsg:@"加入游戏失败"];
        faile();
    }];
}


#pragma mark - 观众提交答题
// 观众提交答题结果
-(void)replyQuestion:(NSDictionary *) tDict e:(BOOL) e
{
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,
                        @"match_id":questionObj[@"match_id"],//竞猜id
                        //                        @"quest_id":(tDict)?tDict[@"question_id"]:@"",//题目id
                        @"quest_id":questionObj[@"questions"][@"quest_id"],//题目id
                        @"answer_id":(tDict)?tDict[@"answer_id"]:@"",//选择的答案id
                        @"times":(e)?@1:@0, //复活次数
                        @"music_name":(music_name)?music_name:@""//歌曲名称
                        };
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagReplyQuestion param:d success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@"509"]) {
            
            
            NSString *m = responseObject[@"descrp"];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"答题错误" message:m preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"购买复活卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //
                //购买复活卡
                [self replyQuestion:tDict e:YES];
                
                
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"不购买" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                reviveCount -= 1;
            }];
            [controller addAction:takePhotoAction];
            [controller addAction:cancleAction];
            [self.topViewController presentViewController:controller animated:YES completion:nil];
            
            
            return ;
        }
        
        
        //        NSLog(@"观众提交答题结果===%@==%@==%@", d,responseObject,responseObject[@"descrp"]);
        if ([responseObject[@"code"] isEqual:@200])
        {
            
            NSString *descrp = responseObject[@"descrp"];
            self.gameMessageLable.hidden = NO;
            _canbuytimes = [responseObject[@"canbuytimes"] integerValue];
            if (_game_match_type == 1) {
                _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
                self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
            }else{
                
                _canerrortimes = [responseObject[@"canerrortimes"] integerValue];
                self.gameMessageLable.text = [NSString stringWithFormat:@"当前剩余错误次数为:%zd",_canerrortimes];
            }
            
            if ([descrp isEqual:@"success！"]) {
                descrp= @"回答正确";
            }
            gz_status = 6;
            [self errorMsg:descrp];
        }
        else{
            
            NSString *descrp = responseObject[@"descrp"];
            [self errorMsg:descrp];
            
            if ([descrp hasPrefix:@"淘汰"]) {
                [self btnCloseClick];
            }
        }
    } faile:^{
        
    }];
}

//关注提交答题



// 急速答题, 获取参赛扣费金额列表（适用于极速玩法与猜歌名）
#pragma mark - 获取参赛金额列表
-(void)getMatchPrice:(void (^)(id res))res
{
    [AlertTool ShowInView:self.window withTitle:@"获取金额列表"];
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetMatchPrice param:nil success:^(id responseObject) {
        //        NSLog(@"获取参赛扣费金额列表（适用于极速玩法与猜歌名）===%@==%@", responseObject,responseObject[@"descrp"]);
        if ([responseObject[@"code"] isEqual:@200])
        {
            [AlertTool Hidden];
            res(responseObject[@"data"]);
        }
        else{
            [AlertTool ShowErrorInView:self.window withTitle:@"请重试..."];
        }
    } faile:^{
        [AlertTool ShowErrorInView:self.window withTitle:@"请重试..."];
    }];
}

// 加载答题分类列表
#pragma mark - 分类列表
-(void)getQuestionsTermList:(void (^)(id res))res
{
    [AlertTool ShowInView:self.window];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
//    NSInteger type = 0;
//    if (match_type == 1 || match_type == 2) {
//        type = 1;
//    } else {
//        type = match_type - 1;
//    }
    NSInteger mathTyoe = match_type;
    if (_isPk) {
        
        mathTyoe = 1;
    }else{
        
        mathTyoe = match_type;
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",mathTyoe] forKey:@"type"];
    

    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetQuestionsTermList param:param success:^(id responseObject) {
        
        [AlertTool Hidden];
        if ([responseObject[@"code"] isEqual:@200])
        {
            res(responseObject[@"data"]);
        }
        else
        {
            [self errorMsg:@"加载答题分类列表失败"];
        }
    } faile:^{
        [self errorMsg:@"加载答题分类列表失败"];
    }];
}

#pragma mark - 回答歌名
// 回答歌名
-(IBAction)submitBm
{
    if (_gmText.text.length==0) {
        [self errorMsg:@"请输入歌名"];
        return;
    }
    music_name = _gmText.text;
    [self replyQuestion:nil e:NO];
}

// 开始游戏
-(BOOL)isSelectedCell
{
    if (colleViewArray.count>0&&_colleView.tag==-1) {
        return YES;
    }
    return NO;
}

//返回上一步

#pragma mark - **********开始游戏-返回上一步***********

- (IBAction)back:(id)sender {
    
    UIButton *backButton = sender;
    if ([backButton.currentTitle isEqualToString:@"重选区"]) {
        
        [self.selectGameView resSet];
        self.selectGameView.hidden = NO;
        [_selectGameView.collectionView reloadData];
        _headTitleLab.text=@"*请点击 开始游戏";
        [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
        _colleView.hidden=NO;
        _left_button.hidden=NO;
        _gmTimerMsg.hidden=YES;
        questionObj = nil;
        [[ShowControl shareInstance].streamerKit stopPip];
        [questionsList removeAllObjects];
        [colleViewArray removeAllObjects];
        [self.tabView reloadData];
        [self.colleView reloadData];
        _stateBtn.hidden = NO;
        _topspeed_price = nil;
        match_type = 0;
        colleVArrayType = 0;
        _isPk = NO;
        _selectGameArea = nil;
    }else{
        
          [self backView:self.gameShowStatus];
    }
    
  

}

- (void)setGameShowStatus:(GameShowStatus)gameShowStatus{
    
    _gameShowStatus = gameShowStatus;
    
    if (_guard_status) {
        
        if (_gameShowStatus == GameShowPrice || _gameShowStatus == GameShowSubType) {
            _backButton.hidden = NO;
            [_backButton setTitle:@"上一步" forState:UIControlStateNormal];
        }else if(_gameShowStatus == GameShowType){
            _isPk = NO;
            [_backButton setTitle:@"重选区" forState:UIControlStateNormal];
            _backButton.hidden = NO;
        }else{
            
            _isPk = NO;
             _backButton.hidden = YES;
        }
        
    }
    
   
    
}


//传入当前状态即可返回上一个界面
- (void)backView:(GameShowStatus)gameShowStuaus{
    
    
    //0 为主分类 3为子分类 2为价格
//    colleVArrayType -= 1;
    
    switch (gameShowStuaus) {
            //显示开始界面
        case 1:{
         //显示开始游戏界面
          
        }
            break;
           
        case 2:{
            
        }
            break;
            //显示选择钱
        case 3:{
            
            
            //显示选择主分类界面
            colleVArrayType = 0;
            [colleViewArray removeAllObjects];
            [colleViewArray addObjectsFromArray:self.topicTypeArray];
              _backButton.hidden = YES;
            [self.colleView reloadData];
            _headTitleLab.text = @"*请选择 游戏模式";
            [_stateBtn setTitle:@"下一步" forState:UIControlStateNormal];
            self.gameShowStatus = GameShowType;
        }
            break;
            //显示选择金额界面
        case 4:{
            
            if (!self.typePicArray.count || _selectGameArea) {
                //显示选择主分类界面
                colleVArrayType = 0;
                [colleViewArray removeAllObjects];
                [colleViewArray addObjectsFromArray:self.topicTypeArray];
                _backButton.hidden = YES;
                [self.colleView reloadData];
                _headTitleLab.text = @"*请选择 游戏模式";
                [_stateBtn setTitle:@"下一步" forState:UIControlStateNormal];
                self.gameShowStatus = GameShowType;
            }else{
                if (_selectGameArea) {
                    
                    
                }else{
                    colleVArrayType = 2;
                    [colleViewArray removeAllObjects];
                    [colleViewArray addObjectsFromArray:self.typePicArray];
                    [self.colleView reloadData];
                    _backButton.hidden = NO;
                    _headTitleLab.text=@"*请选择 游戏金额";
                    self.gameShowStatus = GameShowPrice;
                    [_stateBtn setTitle:@"下一步" forState:UIControlStateNormal];
                    
                }
               
                
            }
        }
            break;
            
        default:
            break;
    }
    
    gameShowStuaus -= 1;
    
}




-(IBAction)statePlays:(UIButton *)b
{
    NSString *t = b.titleLabel.text;
   
    if ([t isEqualToString:@"排除答案"]) {
        
        if (gz_status == 5 || gz_status == 6 || gz_status == 7) {
            
            if (gz_status == 5) {
              [self errorMsg:@"答题时间已到不允许排除答案!"];
            }else if (gz_status == 6){
                [self errorMsg:@"已经提交答案不允许排除答案!"];
            }else if (gz_status == 7){

                [self errorMsg:@"只能排除一次!"];
            }
        
            
            return;
        }
        
        [AlertTool ShowInView:self.window withTitle:@"正在获取数据"];
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserExcludePrice param:nil success:^(id responseObject) {
            [AlertTool Hidden];
            if ([responseObject[@"code"] isEqual:@200])
            {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"排除错误答案" message:[NSString stringWithFormat:@"排除一个错误答案需要扣除%@%@",responseObject[@"data"][@"price"],kBenefit] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"立即排除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //排除错误答案
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    param[@"token"] = [Account shareInstance].token;
                    param[@"price"] = responseObject[@"data"][@"price"];
                    param[@"match_id"] = questionObj[@"match_id"];
                    param[@"quest_id"] = questionsList[0][@"question_id"];
                    
                    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserExcludeanswer param:param success:^(id responseObject) {
                        
                        if ([responseObject[@"code"] isEqual:@200]) {
                            
                            if ([responseObject[@"repeat"] integerValue] > 0){
                                
                                
                                 [self errorMsg:responseObject[@"descrp"]];
                                return;
                            }
                            gz_status = 7;
                            [self errorMsg:@"排除成功"];
                            //获取排除错误答题的id
                            NSLog(@"%@",responseObject[@"data"][@"answer_id"]);
                            _excloudeAnswerID = responseObject[@"data"][@"answer_id"];
                            //获取当前列表的cell
                            //                            NSArray *cells = [self.tabView visibleCells];
                            //
                            //                            for (GameSubjectTableViewCell *subCell in cells) {
                            //
                            //                                if ([subCell.answerId isEqualToString:_excloudeAnswerID]) {
                            //                                   //当前为错误答案
                            //
                            //                                    //中划线
                            //
                            //                                    //        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                            //
                            //                                    //下划线
                            //
                            //                                    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                            //
                            //                                    _excloudeAnswerAttribtStr = [[NSMutableAttributedString alloc]initWithString:subCell.subjectLab.text attributes:attribtDic];
                            //
                            //
                            //                                }
                            //
                            //                            }
                            
                            
                            [self.tabView reloadData];
                            
                            
                        }else{
                            
                            [self errorMsg:responseObject[@"descrp"]];
                        }
                        
                    } faile:^{
                        
                    }];
                    
                    
                }];
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [controller addAction:takePhotoAction];
                [controller addAction:cancleAction];
                [self.topViewController presentViewController:controller animated:YES completion:nil];
                
            }else{
                
                [self errorMsg:@"获取金额失败！"];
            }
            
            
        } faile:^{
            [self errorMsg:@"获取数据失败！"];
            [AlertTool Hidden];
        }];
        
        
        return;
    }
    if([t isEqual:@"停止押注"] || [t isEqual:@"下一题"]){
        
        if ([t isEqual:@"停止押注"]) {
            _stateBtn.hidden=NO;
            // 更新答题状态
            [self convToOngoingStatus:^{
                
                // 主播停止押注
                _tabView.hidden=NO;
                _gameStartMsgBlock(@"", ChatGameStakeEnd);
                
                //
                _stateBtn.tag=_reply_time;
                _stateBtn.hidden=YES;
                [_stateBtn setTitle:@"下一题" forState:UIControlStateNormal];
                
                // 继续答题
                if(![questionObj[@"questions"] isKindOfClass:[NSNull class]]){
                    [_tabView reloadData];
                    
                    _gameStartMsgBlock([self tmJson], ChatGameStart);
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                        [self resetGamePay];
                    }];
                }
            }];
            return;
        }else if ([t isEqual:@"下一题"]) {
            [self finishReplyQuest];// 下一题
        }else{
            //            if([questionObj[@"match_type"] isEqual:@"3"]){
            //                [AlertTool alertWithTitle:nil message:@"请输入歌名" callbackBlock:^(NSInteger index, UITextField * _Nullable textFiled) {
            //                    if (index==1 && textFiled.text.length>0) {
            //                        music_name = textFiled.text;
            //                        [self finishReplyQuest];// 下一题
            //                    }else{
            //                        _right_button.hidden=NO;
            //                        music_name = @"";
            //                    }
            //                } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" needTextFiled:YES presentingController:self.viewController otherButtonTitles:nil, nil];
            //            }else{
            //                [self finishReplyQuest];// 下一题
            //            }
        }
        return;
    }
    
    if (colleVArrayType==0 && match_type == 0) {
        if ([t isEqual:@"开始游戏"]) {
            _headTitleLab.text=@"*请选择 游戏模式";
            [_stateBtn setTitle:@"下一步" forState:UIControlStateNormal];
            self.gameShowStatus = GameShowType;
            _colleView.hidden=NO;
            _topspeed_price = @"0";
            colleViewArray = [[NSMutableArray alloc] initWithArray:self.topicTypeArray];
            [_colleView reloadData];
        }else{
            if ([self isSelectedCell]) {
                [self errorMsg:@"请选择 游戏模式"];
                return;
            }
        }
    }else {
       
        if(match_type == 1 && _isPk == NO){
            //选择pk模式
            
            if ([self isSelectedCell]) {
                [self errorMsg:@"请选择 游戏类型"];
                return;
            }
            colleVArrayType = 0;
            colleViewArray = [[NSMutableArray alloc] initWithArray:self.matchPkArray];
            [_colleView reloadData];
            //当前进入的游戏为pk模式
            _isPk = YES;
            match_type = 0;
            _colleView.tag = -1;
        }else{
           
            //把开始状态改为下一步选择类型状态
            if (colleVArrayType == 0) {
                colleVArrayType = 1;
            }
            NSLog(@"%zd",match_type);
//            if (match_type == 1 && _isPk == YES) {
//
//
//                [self playClassPK];
//            } else {
                [self playClass];
//            }
            
            
        }
        
        
        
        
    }
}

#pragma mark - **************开始游戏*******************
- (void)playClassPK
{
    if (colleVArrayType==1) {
        if ([self isSelectedCell]) {
            [self errorMsg:@"请选择 游戏模式"];
            return;
        }
        _headTitleLab.text=@"*请选择 题集，点击开始游戏";
        self.gameShowStatus = GameShowSubType;
        [self getQuestionsTermList:^(id res) {
            [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
            [colleViewArray removeAllObjects];
            for (NSDictionary *d in res) {
                [colleViewArray addObject:d];
            }
            colleVArrayType=2;
            _colleView.tag=-1;
            [_colleView reloadData];
        }];
        
    }else if (colleVArrayType==2) {
        if ([self isSelectedCell]) {
            [self errorMsg:@"请选择 题集"];
            return;
        }
        term_id = colleViewArray[_colleView.tag][@"term_id"];
        colleVArrayType=0;
        _colleView.tag=-1;
        _colleView.hidden=YES;
        [colleViewArray removeAllObjects];
        [_colleView reloadData];
        [self startMatch:^{
        }];
    }
}


static NSString * extracted(GameStartTableViewCell *object) {
    return [object tmJson];
}

-(void)gameConnect:(void(^)(BOOL isSuccess, NSString *matchId,NSString *area_id))completion{
    
   
   
    
    NSDictionary *d = @{
                        @"token":[Account shareInstance].token,//主播令牌
                        };
    //获取
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagStartMatch param:d success:^(id responseObject) {
//        2553
        [AlertTool Hidden];
        if ([responseObject[@"code"] isEqual:@200])
        {
            gz_reply_time = [responseObject[@"reply_time"] intValue];
            _join_time = [responseObject[@"join_time"] intValue];//等待加入比赛时间（秒）
            _reply_time = [responseObject[@"reply_time"] intValue];//答题时间（秒）
            _gameMatchId = responseObject[@"match_id"];
            questionObj = responseObject;
            [questionsList removeAllObjects];
            [_tabView reloadData];
            _stateBtn.tag=-1;
            _stateBtn.hidden=YES;
             completion(YES,_gameMatchId,responseObject[@"area_id"]);
            
            //            if (match_type==3 || match_type==4) {
            //                ret();
            //                return ;
            //            }
            
                
                if (_guard_status == YES) {
                   
                    if (![responseObject[@"questions"] isKindOfClass:[NSNull class]]) {
                        //                completion(YES);
                        NSArray *list = questionObj[@"questions"][@"answer_list"];
                        url = questionObj[@"questions"][@"uri"];
                        
                        for (NSDictionary *d in list) {
                            
                            
                            
                            [questionsList addObject:d];
                        }
                        [self gamePays];
                        [_tabView reloadData];
                    
                    _stateBtn.hidden=NO;
                    [_stateBtn setTitle:@"下一题" forState:UIControlStateNormal];
                    
                    zb_status=3;
                   
//                    _gameStartMsgBlock([self tmJson], ChatGameStart);
                }
            }else{
//                [self errorMsg:@"获取题目失败"];
            }
        }
        else
        {
//            [self errorMsg:responseObject[@"descrp"]];
        }
    } faile:^{
//        [self errorMsg:@"请重试..."];
    }];
    
}


- (void)playClass
{
    
    
    if (colleVArrayType==1) {
        if ([self isSelectedCell]) {
            [self errorMsg:@"请选择 游戏模式"];
            return;
        }
      
        if (_selectGameArea) {
            
            if ([self isSelectedCell]) {
                
                [self errorMsg:@"请选择 游戏金额"];
                return;
            }
            _headTitleLab.text=@"*请选择 题集，点击开始游戏";
            self.gameShowStatus = GameShowSubType;
            [self getQuestionsTermList:^(id res) {
                [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
                [colleViewArray removeAllObjects];
                [self.subTypeArray removeAllObjects];
                for (NSDictionary *d in res) {
                    [self.subTypeArray addObject:d];
                }
                [colleViewArray addObjectsFromArray:self.subTypeArray];
                colleVArrayType=3;
                _colleView.tag=-1;
                [_colleView reloadData];
            }];
            
            
        }else{
            
            _headTitleLab.text=@"*请选择 游戏金额";
            self.gameShowStatus = GameShowPrice;
            [self getMatchPrice:^(id res) {
                [colleViewArray removeAllObjects];
                [self.typePicArray removeAllObjects];
                for (NSDictionary *d in res) {
                    
                    [self.typePicArray addObject:d];
                }
                [colleViewArray addObjectsFromArray:self.typePicArray];
                colleVArrayType=2;
                _colleView.tag=-1;
                [_colleView reloadData];
            }];
        }
        
        
    }else if (colleVArrayType==2) {
        if ([self isSelectedCell]) {
            
            [self errorMsg:@"请选择 游戏金额"];
            return;
        }
        _headTitleLab.text=@"*请选择 题集，点击开始游戏";
        self.gameShowStatus = GameShowSubType;
        [self getQuestionsTermList:^(id res) {
            [_stateBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
            [colleViewArray removeAllObjects];
            [self.subTypeArray removeAllObjects];
            for (NSDictionary *d in res) {
                [self.subTypeArray addObject:d];
            }
            [colleViewArray addObjectsFromArray:self.subTypeArray];
            colleVArrayType=3;
            _colleView.tag=-1;
            [_colleView reloadData];
        }];
    }else if (colleVArrayType==3) {
        if ([self isSelectedCell]) {
            [self errorMsg:@"请选择 题集"];
            return;
        }
        term_id = colleViewArray[_colleView.tag][@"term_id"];
        colleVArrayType=0;
        _colleView.tag=-1;
        _colleView.hidden=YES;
        [colleViewArray removeAllObjects];
        [_colleView reloadData];
        [self startMatch:^{
        }];
    }
}



- (void)sda{
    
//    NSMutableArray *
//
//    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagCanerrortimes param:<#(NSMutableDictionary *)#> success:<#^(id responseObject)success#> faile:<#^(void)faile#>]
    
    
    
    
}



// UICollectionView --

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [colleViewArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth-20)/3, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < colleViewArray.count; i++) {
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:i inSection:0];
        sCollectionViewCell *cell = (sCollectionViewCell *)[_colleView cellForItemAtIndexPath:ipath];
        cell.txtImg.hidden=YES;
        if (indexPath.row==i) {
            cell.txtImg.hidden=NO;
        }
    }

    if (colleVArrayType==0) {
        if (_isPk == YES) {
           match_type =indexPath.row+1;
        }else{
            
            match_type =indexPath.row+1;// 竞猜类型，1：普通竞猜， 2：极速玩法 3：猜歌名，4：猜视频
        }
        
    }else{
        
        NSString *price = colleViewArray[indexPath.row][@"price"];
        if (price) {
            _topspeed_price = [price copy];
        }
    }
    
    _colleView.tag=indexPath.row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    sCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:ACellID forIndexPath:indexPath];
    cell.txtImg.hidden=YES;
    //1 为主分类 3为子分类 2为价格
    if (colleVArrayType==0) {
        cell.txtlab.text=colleViewArray[indexPath.row];
    }else if (colleVArrayType>0) {
//        if (_isPk == YES) {
//             cell.txtlab.text=[NSString stringWithFormat:@"%@ %@",colleViewArray[indexPath.row][@"price"],kBenefit];
//        }else {
            if (colleVArrayType==3) {
                cell.txtlab.text=colleViewArray[indexPath.row][@"name"];
            }else{
                cell.txtlab.text=[NSString stringWithFormat:@"%@ %@",colleViewArray[indexPath.row][@"price"],kBenefit];
            }
//        }
    }
    return cell;
}


/////当前游戏的主分类
//@property (strong, nonatomic) NSMutableArray *topicTypeArray;
/////当前游戏主分类的子分类
//@property (strong, nonatomic) NSMutableArray *subTypeArray;
////当前选择游戏的价格
//@property (strong, nonatomic) NSMutableArray *typePicArray;

- (NSMutableArray *)topicTypeArray{
    
    if (_topicTypeArray == nil) {
        
        _topicTypeArray = [NSMutableArray array];
    }
    
    return _topicTypeArray;
    
}

- (NSMutableArray *)subTypeArray{
    
    if (_subTypeArray == nil) {
        
        _subTypeArray = [NSMutableArray array];
    }
    
    return _subTypeArray;
    
}

- (NSMutableArray *)typePicArray{
    
    if (_typePicArray == nil) {
        
        _typePicArray = [NSMutableArray array];
    }
    
    return _typePicArray;
    
}

- (NSMutableArray *)matchPkArray{
    
    if (_matchPkArray == nil) {
        _matchPkArray = [NSMutableArray array];
    }
    
    return _matchPkArray;
}

@end

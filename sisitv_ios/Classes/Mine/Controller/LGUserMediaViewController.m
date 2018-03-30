//
//  LGUserMediaViewController.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/1.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGUserMediaViewController.h"
#import "LGUserMediaHeadView.h"
#import "MainNewDataSource.h"
#import "LGMediaListModel.h"
#import "MainListParam.h"
#import "LGMediaListRequest.h"
#import "Account.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "LGPlaysController.h"
#import "MJRefresh.h"
#import "LGVideoListCell.h"
#import "BaseUser.h"
#import "LGPlaysController.h"
#import "LGShareController.h"
#import "UtilityController.h"
#import "RoomParam.h"
#import "PlayerViewController.h"
#import "RoomModel.h"


@interface LGUserMediaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,assign) BOOL isMe;
@property(nonatomic,assign) NSInteger vcType;
@property(nonatomic,strong) UICollectionView *collectionVew;
@property(nonatomic,strong) NSMutableArray  *videoListArray;
@property(nonatomic,strong) LGUserMediaHeadView *headView;
@property(nonatomic,assign) NSInteger cellType;
/**关注状态*/
@property (nonatomic , copy) NSString *attention_status;
/**关注辅助属性*/
@property (nonatomic , copy) NSString *attentionStatusImageName;
@property(nonatomic,strong) BaseUser *userModel;
@end

@implementation LGUserMediaViewController{
    YZGCollectionSectionItem *_sectionItem;
    NSInteger _limit_begin;
}


- (NSMutableArray *)videoListArray{
    if (_videoListArray == nil) {
        
        _videoListArray = [NSMutableArray array];
    }
    
    return _videoListArray;
}


-(instancetype)initWithVcType:(NSInteger)vcType{
    
    if (self = [super init]) {
        
        _vcType = vcType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectionView];
    
    self.collectionVew.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaNewData)];
    MJRefreshAutoStateFooter *footRef = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.collectionVew.mj_footer = footRef;
   
    //为视频
    if (_vcType == 1) {
        
        _cellType = 1;
    }else{
       //图片
        _cellType = 2;
        
    }
    if(_isME == YES){
    
        dispatch_async(dispatch_get_main_queue(), ^{
              [self loadUserInfo];
        });
        
    }else{
        [self loadUserInfo];
    }
      [self loaNewData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)loadUserInfo{
    
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"id"] = self.mediaModel.owner_id;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUserInfo param:param success:^(id responseObject) {
     
        if ([responseObject[@"code"] integerValue] == 200) {
          BaseUser *userModel = [BaseUser mj_objectWithKeyValues:responseObject[@"data"]];
            self.userModel = userModel;
            if (_isME) {
                _headView.focusUserButton.hidden = YES;
                
                [_headView.userAvatarImageView setHeader:userModel.avatar];
            }else{
                
                _headView.focusUserButton.hidden = NO;
                [_headView.userAvatarImageView setHeader:userModel.avatar];
                
            }
            
            _headView.signatureLable.text = [NSString stringWithFormat:@"城市:%@ \n%@",userModel.location,userModel.signature];
           
            _headView.hidden = NO;
            _headView.fansLabel.text = userModel.fans_num;
            _headView.focusLabel.text = userModel.attention_num;
            _headView.userID.text = [NSString stringWithFormat:@"ID:%@",userModel.ID];
            _headView.userSex.image = [UIImage imageNamed:userModel.sex];
            
            if ([userModel.channel_status isEqualToString:@"正在直播"]) {
                
                _headView.isLiveBtton.hidden = NO;
                
            }else{
                
              _headView.isLiveBtton.hidden = YES;
            }
            [_headView.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [_headView.level setImage:[UIImage imageNamed:userModel.userLevelImageName] forState:UIControlStateNormal];
            _headView.level.titleLabel.font = [UIFont systemFontOfSize:10];
            [_headView.level setTitle:userModel.user_level forState:UIControlStateNormal];
            
            [_headView.videoBUtton setTitle:[NSString stringWithFormat:@"视频%@",userModel.video_num] forState:UIControlStateNormal];
            [_headView.imageButton setTitle:[NSString stringWithFormat:@"图片%@",userModel.photo_num] forState:UIControlStateNormal];
            
            [_headView.isLiveBtton setTitle:userModel.channel_status forState:UIControlStateNormal];
            
            if ([userModel.attention_status isEqualToString:@"已关注"]) {
                //已经关注
                [_headView.focusUserButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                 [_headView.focusUserButton setTitle:@"未关注" forState:UIControlStateNormal];
                
            }
            
            [self.collectionVew reloadData];
            [self loaNewData];
        }else{
            
            [AlertTool ShowErrorInView:self.view withTitle:@"获取数据失败"];
               [AlertTool Hidden];
        }
        
    } faile:^{
        [AlertTool Hidden];
    }];
}

- (void)loadNextData{
    _limit_begin += 20;
    [AlertTool ShowInView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @(_cellType);
    param[@"uid"] = self.mediaModel.owner_id;
    param[@"limit_begin"] = @(_limit_begin);
    param[@"limit_num"] = @20;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetviews param:param success:^(id responseObject) {
        [AlertTool Hidden];
        [self.collectionVew.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *dataArray = responseObject[@"data"];
            if (dataArray.count < 20) {
                [self.collectionVew.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.videoListArray addObjectsFromArray:[LGMediaListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.collectionVew reloadData];
        }
        
    } faile:^{
        [AlertTool Hidden];
    }];
    
}


- (void)loaNewData{
    _limit_begin = 0;
    [self.collectionVew.mj_footer resetNoMoreData];
    [AlertTool ShowInView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @(_cellType);
    param[@"uid"] = self.mediaModel.owner_id;
    param[@"limit_begin"] = @0;
    param[@"limit_num"] = @20;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetviews param:param success:^(id responseObject) {
        [AlertTool Hidden];
        [self.collectionVew.mj_header endRefreshing];
        NSArray *dataArray = responseObject[@"data"];
        if ([responseObject[@"code"] integerValue] == 200) {
        if (dataArray.count < 20) {
                [self.collectionVew.mj_footer endRefreshingWithNoMoreData];
        }
          self.videoListArray = [LGMediaListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.collectionVew reloadData];
        }
        
    } faile:^{
       [AlertTool Hidden];
    }];
    
    
    
}


- (void)initCollectionView{
    
     CGFloat margin = 1.0;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    layout.headerReferenceSize = CGSizeMake(320, 211);
    CGFloat width = (KScreenWidth-10) /3.0;
    layout.itemSize = CGSizeMake(width , width/0.65);
    self.collectionVew = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionVew.backgroundColor = [UIColor whiteColor];
    self.collectionVew.delegate = self;
    self.collectionVew.dataSource = self;
      [self.collectionVew registerNib:[UINib nibWithNibName:@"LGUserMediaHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
    [self.collectionVew registerNib:[UINib nibWithNibName:@"LGVideoListCell" bundle:nil] forCellWithReuseIdentifier:@"LGVideoListCell"];
    [self.view addSubview:self.collectionVew];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.videoListArray.count;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    LGUserMediaHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"UICollectionViewHeader"
                                                                                forIndexPath:indexPath];
    
    
    _headView = headView;
    [headView.videoBUtton addTarget:self action:@selector(selectView:) forControlEvents:UIControlEventTouchUpInside];
    [headView.imageButton addTarget:self action:@selector(selectView:) forControlEvents:UIControlEventTouchUpInside];
    [headView.focusUserButton  addTarget:self action:@selector(focusUser:) forControlEvents:UIControlEventTouchUpInside];
    [headView.isLiveBtton addTarget:self action:@selector(g2LiveRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(g2FansVc)];
    headView.fansLabel.userInteractionEnabled = YES;
    [headView.fansLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(g2guanzhu)];
     headView.focusLabel.userInteractionEnabled = YES;
    [headView.focusLabel addGestureRecognizer:tap2];
    
    
    
    if (_cellType == 1) {
        
        _headView.videoBUtton.selected = YES;
        
    }else{
        
        _headView.imageButton.selected = YES;
    }
    return headView;
}

//进入粉丝
- (void)g2FansVc{
    
    UtilityController *utility = [[UtilityController alloc] initWithTitle:UtilityFans name:@"粉丝"];
   
    utility.ID = self.mediaModel.owner_id;
    [self presentWithViewController:utility];
    
}

//进入关注
- (void)g2guanzhu{
    
    UtilityController *utility = [[UtilityController alloc] initWithTitle:UtilityAttention name:@"关注"];
    utility.ID = self.mediaModel.owner_id;
    [self presentWithViewController:utility];
    
}

-(void)presentWithViewController:(UIViewController *)viewController
{
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:viewController];
}
- (void)focusUser:(UIButton *)btn{
    AccountParam *param = [[AccountParam alloc]init];
    param.userid = self.mediaModel.owner_id;
   
    [[Account shareInstance] attentionOrCancelAttentionWithCurrentButtonTitle:btn.titleLabel.text WithParam:param success:^(BOOL isSuccess, id result) {
        
        if (isSuccess) {
          
            [self loadUserInfo];
            [self.headView.focusUserButton setTitle:result forState:UIControlStateNormal];
        }
        
        
    }];
}
- (void)g2LiveRoom:(UIButton *)btn{
    
  //进入直播间
    [self willEnderPlayer];
    
    
    
}

- (void)willEnderPlayer{
    NSString *room_id =  [self.userModel room_id];
    if (self.userModel.price.integerValue>0) {
        [self enterPriceRoom];
    }else if (self.userModel.minute_charge.integerValue>0){
        [self enterMinuteChargeRoom];
    }else if ([self.userModel.need_password intValue]){
        [self enterPasswordRoom];
    }else{
        [self persentPlayerControllrWithRoom_id:room_id avatar:self.userModel.avatar room_password:nil video_url:nil];
    }
}

-(void)enterMinuteChargeRoom{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每分钟)",self.userModel.minute_charge,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            [self persentPlayerControllrWithRoom_id:self.userModel.room_id avatar:self.userModel.avatar room_password:nil video_url:nil];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"进入" needTextFiled:NO presentingController:self otherButtonTitles:nil, nil];
}

-(void)enterPriceRoom{
    [AlertTool alertWithTitle:nil message:[NSString stringWithFormat:@"该直播间为付费房间\n(%@%@/每次)",self.userModel.price,kBalance] callbackBlock:^(NSInteger index, UITextField * _Nullable textField) {
        if (index ==1) {
            if ([[Account shareInstance].balance integerValue] > self.userModel.price.integerValue) {
                [self persentPlayerControllrWithRoom_id:self.userModel.room_id avatar:self.userModel.avatar room_password:nil video_url:nil];
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
            roomParam.room_id = self.userModel.room_id;
            roomParam.room_password = room_password;
            [RoomModel checkRoomPassword:roomParam success:^(id info, BOOL successGetInfo){
                if (successGetInfo) {
                    [self persentPlayerControllrWithRoom_id:self.userModel.room_id avatar:self.userModel.avatar room_password:room_password video_url:nil];
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




-(void)setAttention_status:(NSString *)attention_status{
//    _attention_status = [attention_status copy];
//    if (_attention_status.integerValue ==1 ||[_attention_status isEqualToString:@"已关注"]) {
//        _attention_status=@"已关注";
//        self.attentionStatusColor = [UIColor colorWithHexString:@"d3d3d3"];
//        self.attentionStatusImageName = nil;
//    }else if (_attention_status.integerValue ==0 ||[_attention_status isEqualToString:@"关注"]) {
//        _attention_status=@"关注";
//        self.attentionStatusColor = [UIColor colorWithHexString:@"ffc000"];
//        self.attentionStatusImageName = @"加关注";
//    }
}



- (void)selectView:(UIButton *)btn{
    
    if (btn == _headView.videoBUtton) {
        //用户选中视频
        btn.selected = YES;
        _headView.imageButton.selected = NO;
        _cellType = 1;
       
    }else{
       //用户的图片
        btn.selected = YES;
        _headView.videoBUtton.selected = NO;
        _cellType = 2;
        
    }
    
     [self loaNewData];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LGVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LGVideoListCell" forIndexPath:indexPath];
    cell.isUserVieoCell = YES;
    [cell setItem:self.videoListArray[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_cellType == 1) {
        //进入视频
        LGPlaysController *play = [[LGPlaysController alloc] init];
        play.model = self.videoListArray[indexPath.row];
        play.viewType = 1;
        play.videoListArray = self.videoListArray;
        play.indexPath = indexPath;
        //    [self.navigationController pushViewController:play animated:YES];
        [self presentNeedNavgation:YES presentendViewController:play];
    }else{
      //进入图片
        LGPlaysController *play = [[LGPlaysController alloc] init];
        play.model = self.videoListArray[indexPath.row];
        play.viewType = 2;
        play.videoListArray = self.videoListArray;
        play.indexPath = indexPath;
        //    [self.navigationController pushViewController:play animated:YES];
        [self presentNeedNavgation:YES presentendViewController:play];
        
    }
    
    
    
}

@end

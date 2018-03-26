//
//  LGPlaysController.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/25.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGPlaysController.h"
#import "BaseWebViewController.h"
#import "PlayerViewController.h"
#import "YZGCollectionView.h"
#import "LGMediaDataSource.h"
#import "RoomModel.h"
#import "AlertTool.h"
#import "Account.h"
#import "MainListModel.h"
#import "LGVideoListCell.h"
#import "LGMediaListModel.h"
#import "LGMediaListRequest.h"
#import "MainNewDataSource.h"
#import "MainNewCollectionCell.h"
#import "LGVideoPlayCell.h"
#import "HttpTool.h"
#import "LGAliAccessToken.h"
#import "LGBottonCommentView.h"
#import "LGCommentController.h"
#import "YZGShare.h"
#import "LGJubaoView.h"
//#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>
#import "LGUserMediaViewController.h"
#import "BaseNavgationController.h"
#import "LWImageBrowser.h"
#import "LGPlaysController.h"
#import "LGPlayScrollView.h"
#import <libksygpulive/KSYMoviePlayerController.h>


@interface LGPlaysController ()<UICollectionViewDelegate,UICollectionViewDataSource,LGBottmCommentViewDelegate,YZGShareViewDelegate,LGPlayerScrollViewDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LGBottonCommentView *commentView;
@property(nonatomic,strong) LGCommentController *cmVc;
//@property (strong ,nonatomic) AliyunVodPlayer *aliPlayer;
@property (strong ,nonatomic) KSYMoviePlayerController *player;
@property (strong ,nonatomic)  LGPlayScrollView *playScrollView;
@property (strong ,nonatomic) UIView *playerView;
@property (nonatomic,assign)  BOOL isShowCommentView;
@property (nonatomic,assign)  BOOL isStop;
@property (nonatomic,strong) KSYMoviePlayerController *moviePlayer;
@property (nonatomic,strong) LGMediaListModel *curImageModel;
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation LGPlaysController

static NSString *cellID = @"videoCellId";



- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        
    }
    
    return _collectionView;
    
}

- (LGBottonCommentView *)commentView{
    
    if (_commentView == nil) {
        _commentView = [LGBottonCommentView viewFromeNib];
        _commentView.delegate = self;
    }
    
    
    return _commentView;
}


- (void)seeImage:(UITapGestureRecognizer *)tap{
    
    NSURL *url = [NSURL URLWithString:self.playScrollView.middleImageView.model.uri];

    LWImageBrowserModel *model = [[LWImageBrowserModel alloc] initWithplaceholder:nil thumbnailURL:url HDURL:url containerView:tap.view positionInContainer:self.view.frame index:0];
    LWImageBrowser *imageBrow = [[LWImageBrowser alloc] initWithImageBrowserModels:@[model] currentIndex:0];
    imageBrow.isShowPageControl = NO;

    [self presentViewController:imageBrow animated:NO completion:nil];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.extendedLayoutIncludesOpaqueBars = YES;
   
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
         self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
   
    
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
//@"http://vod.51guojiang.com/sv/377f908d-160fe10299f/377f908d-160fe10299f.mp4"
//    if (self.player) {
//        [self.player reload:[NSURL URLWithString:livingUrlString]];
//        return;
//    }
    
  

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.playScrollView = [[LGPlayScrollView alloc] initWithFrame:self.view.bounds];
    self.playScrollView.playerDelegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.playScrollView addGestureRecognizer:tap];
    
//    self.playerView = [[UIView alloc] init];
//    self.playerView = self.aliPlayer.playerView;
//    [self.playScrollView.middleImageView.bgImageView addSubview:self.playerView];
//    self.playerView.frame= CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//    [self.aliPlayer setAutoPlay:YES];
//    self.aliPlayer.circlePlay = YES;
//    self.aliPlayer.delegate = self;
//    [self.playScrollView.middleImageView.playVideoView addSubview:self.playerView];
    KWeakSelf;
    
    if (_viewType == 2) {
        self.playScrollView.middleImageView.bgImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeImage:)];
       
        
        [self.playScrollView.middleImageView.bgImageView addGestureRecognizer:tap];
    }
  
    self.playScrollView.middleImageView.cellAtion = ^(NSInteger ationType ,LGMediaListModel *mediaModel) {
    
        ///1为返回 2举报 3显示提交评论 4显示评论界面
        switch (ationType) {
                //
            case 1:{
                //返回上级页面
                //释放播放器
//                NSArray *ary = [collectionView visibleCells];
//                for (LGVideoPlayCell *cell in ary) {
//                    [cell releasePlayer];
//                }
               [ws dismiss];
                
            }
                break;
            case 2:{
                //显示举报分享
                if ([mediaModel.owner_id isEqualToString:[Account shareInstance].ID]) {
                    //显示删除
                    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleActionSheet];
                    [alerVc addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSMutableDictionary *param = [NSMutableDictionary dictionary];
                        param[@"token"] = [Account shareInstance].token;
                        param[@"item_id"] = mediaModel.id;
                        param[@"type"] = @(ws.viewType);
                        
                        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUploadDelete param:param success:^(id responseObject) {
                            if ([responseObject[@"code"] integerValue]) {
                                
                                [AlertTool ShowErrorInView:[UIApplication sharedApplication].keyWindow withTitle:@"删除成功"];
                                [ws dismiss];
                            }
                            
                        } faile:^{
                            
                        }];
                        
                    }]];
                    [alerVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [ws presentViewController:alerVc animated:YES completion:nil];
                    
                }else{
                    
                    [LGJubaoView showView];
                }
                
            }
                break;
            case 3:{
                //显示提交评论View
                LGBottonCommentView *commentView = [LGBottonCommentView viewFromeNib];
                commentView.delegate = ws;
                commentView.mediaModel = mediaModel;
                commentView.frame = ws.view.bounds;
                [ws.view addSubview:commentView];
                [commentView.commentTexf becomeFirstResponder];
                
            }
                break;
            case 4:{
                //显示用户的评论
                ws.cmVc.model = mediaModel;
                ws.cmVc.g2SubCommtCaback = ^{
                    
//                    NSArray *ary = [collectionView visibleCells];
//                    for (LGVideoPlayCell *cell in ary) {
//                        [cell pausePlay];
//                    }
                    _isStop = YES;
                };
                ws.cmVc.type = ws.viewType;
                [ws.cmVc loadOldData];
                [ws.cmVc.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.left.right.mas_offset(0);
                    make.height.mas_equalTo(KScreenHeight * 0.75);
                }];
                
                [ws.cmVc.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.left.right.mas_offset(0);
                    make.height.mas_equalTo(KScreenHeight * 0.75);
                    
                }];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    [ws.view layoutIfNeeded];
                }];
                _isShowCommentView = YES;
                
            }break;
                
            case 5:{
                
                YZGShareView *share = [YZGShare yzgShareView];
                share.delegate = ws;
                share.object = mediaModel;
                
            }break;
                
            case 6:{
                
//                NSArray *ary = [collectionView visibleCells];
//                for (LGVideoPlayCell *cell in ary) {
//                    [cell pausePlay];
//                }
                _isStop = YES;
//                [self.aliPlayer pause];
     
                //点击用户头像进入详情页面，视频点进去显示视频，图片点进去显示图片
                LGUserMediaViewController *mediaVc = [[LGUserMediaViewController alloc] initWithVcType:_viewType];
                mediaVc.title = mediaModel.user_nicename;
                mediaVc.mediaModel = mediaModel;
//                [ws.navigationController pushViewController:mediaVc animated:YES];
                [ws presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:mediaVc];
                
            } break;
            case 7:{
                //点击关注
                
                
            }
            default:
                break;
        }
        
        
        
    };
    [self.playScrollView updateForLives:self.videoListArray withCurrentIndex:self.indexPath.row];
    
    [self playerScrollView:self.playScrollView currentPlayerIndex:self.indexPath.row];
    [self.view addSubview:self.playScrollView];
    
    

    [self addView];

    [self installMovieNotificationObservers];
}

-(void)dismiss{
    
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moviePlayBackStateDidChange:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadStateDidChange:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
}

//加载状态改变
- (void)loadStateDidChange:(NSNotification*)notification
{
    if (self.player.loadState !=  (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK)) {
//        [AlertTool showWithCustomModeInView:self.playScrollView.middleImageView];
    }else{
        [AlertTool Hidden];
    }
}

//播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        self.playScrollView.middleImageView.bgImageView.hidden = YES;
        [AlertTool Hidden];
    }else{
        [AlertTool showWithCustomModeInView:self.playScrollView.middleImageView];
    }
}



- (void)playerScrollView:(LGPlayScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index{
    

    _currentIndex = index;
    if (_setOffset) {
        
        
        _setOffset(index);
    }
    if (_viewType == 1) {
        [self prepare:self.videoListArray[index]];
    }
    if (self.videoListArray.count >= 20) {
        if ((self.videoListArray.count - 4) == index) {
            
            [AlertTool showWithCustomModeInView:self.view];
            if (self.loadData) {
                
                 self.loadData(index);
            }
           
            
        }
    }
    
    
    
}

- (void)setVideoListArray:(NSMutableArray *)videoListArray{
    
    _videoListArray = videoListArray;
    if (videoListArray.count <= 20) {
        _currentIndex = 0;
    }
    
    [self.playScrollView updateForLives:videoListArray withCurrentIndex:_currentIndex];
    
    
}


#pragma mark 播放视频

- (void)prepare:(LGMediaListModel *)mediaModel{
//    [AlertTool ShowInView:self.view];
    //判断当前主播是否已经关注


    if (mediaModel.uri.length) {
        if (!self.player) {
            self.player  = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:mediaModel.uri]];
            self.player.scalingMode = MPMovieScalingModeAspectFill;
            self.player.shouldAutoplay = YES;
            self.player.shouldLoop = YES;
            self.player.view.frame = self.view.bounds;
            [self.playScrollView.middleImageView.playVideoView addSubview:self.player.view];
            [self.player prepareToPlay];
        }else{
            [self.player reset:NO];
            [self.player setUrl:[NSURL URLWithString:mediaModel.uri]];
            [self.player prepareToPlay];
        }
    }else{
        self.playScrollView.middleImageView.bgImageView.hidden = NO;
        [self.player pause];
        [AlertTool ShowErrorInView:self.playScrollView.middleImageView withTitle:@"视频审核中暂时无法播放"];
    }
   
    
    
    return;
    
//    self.playScrollView.middleImageView.bgImageView.hidden = YES;
//    self.moviePlayer = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:mediaModel.uri] sharegroup:nil];
//    self.moviePlayer.view.frame = self.playScrollView.middleImageView.playVideoView.bounds;
//    [self.playScrollView.middleImageView addSubview:self.moviePlayer.view];
//    [self.moviePlayer play];
    
    //    });
}


- (void)addView{
    
    self.cmVc = [[LGCommentController alloc] init];
    self.cmVc.type = self.viewType;
    [self.view addSubview:self.cmVc .view];
    [self addChildViewController:self.cmVc];
    
    [self.cmVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(KScreenHeight * 0.75);
        make.bottom.mas_offset(KScreenHeight * 0.75);
        
        
    }];
    [self.cmVc.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(KScreenHeight * 0.75);
        make.bottom.mas_offset(KScreenHeight * 0.75);
        
    }];
    
    __weak typeof(self.cmVc)weakCmvc = self.cmVc;
    KWeakSelf;
    
    
    
    self.cmVc.commentSuccess = ^{
      
        ws.playScrollView.middleImageView.model.comments = [NSString stringWithFormat:@"%zd",[self.playScrollView.middleImageView.model.comments integerValue] + 1];
        
        ws.playScrollView.middleImageView.commentsLabel.text = ws.playScrollView.middleImageView.model.comments;
        
        
        
    };
    
    self.cmVc.submitCaback = ^{
        
        ws.cmVc.limit_end = 0;
        [ws.cmVc.view endEditing:YES];
        [ws.cmVc.comments removeAllObjects];
        [ws.cmVc.tableView reloadData];
        [weakCmvc.view mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(KScreenHeight * 0.75);
            make.bottom.mas_offset(KScreenHeight * 0.75);
        }];
        
        [weakCmvc.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(KScreenHeight * 0.75);
            make.bottom.mas_offset(KScreenHeight * 0.75);
           
        }];
        [UIView animateWithDuration:0.25 animations:^{
           
            [ws.view layoutIfNeeded];
        }];
        
    };
    
}


- (void)dealloc{
    
    [self removeMovieNotificationObservers];
    self.player = nil;
    NSLog(@"dealloc");
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
     self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    _isStop = NO;

    [self.player play];
  

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
    if (_isStop == NO) {
        [self.player stop];
        self.player = nil;
//        [self.aliPlayer releasePlayer];
    }else{
        [self.player pause];
    }
   
}

- (void)initCollectionView{
    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LGVideoPlayCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(LGMediaListModel *)model{
    _model = model;
    
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.videoListArray.count;
}


- (void)tap{
    
    self.cmVc.submitCaback();
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LGVideoPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.cellType = _viewType;
    
    
    [cell setItem:self.videoListArray[indexPath.row] forIndexPath:indexPath];
    
    KWeakSelf;
    cell.cellAtion = ^(NSInteger ationType ,LGMediaListModel *mediaModel) {
      
        ///1为返回 2举报 3显示提交评论 4显示评论界面
        switch (ationType) {
        //
            case 1:{
               //返回上级页面
                //释放播放器
                
                [self.player stop];
                self.player = nil;
                [ws dismissViewControllerAnimated:YES completion:nil];
                
            }
                break;
            case 2:{
                //显示举报分享
                if ([mediaModel.owner_id isEqualToString:[Account shareInstance].ID]) {
                   //显示删除
                    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleActionSheet];
                    [alerVc addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        NSMutableDictionary *param = [NSMutableDictionary dictionary];
                        param[@"token"] = [Account shareInstance].token;
                        param[@"item_id"] = mediaModel.id;
                        param[@"type"] = @(_viewType);
                    
                        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUploadDelete param:param success:^(id responseObject) {
                            if ([responseObject[@"code"] integerValue]) {
                                
                                [AlertTool ShowErrorInView:self.view withTitle:@"删除成功"];
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                            
                        } faile:^{
                            
                        }];
                       
                    }]];
                    [alerVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [ws presentViewController:alerVc animated:YES completion:nil];
                    
                }else{
                    
                    [LGJubaoView showView];
                }
                
            }
                break;
            case 3:{
                //显示提交评论View
              LGBottonCommentView *commentView = [LGBottonCommentView viewFromeNib];
                commentView.delegate = self;
                commentView.mediaModel = mediaModel;
                commentView.frame = self.view.bounds;
                [ws.view addSubview:commentView];
                [commentView.commentTexf becomeFirstResponder];
                
            }
                break;
            case 4:{
               //显示用户的评论
                ws.cmVc.model = mediaModel;
                ws.cmVc.g2SubCommtCaback = ^{
                        [self.player pause];
         
                    _isStop = YES;
                };
                ws.cmVc.type = _viewType;
                [ws.cmVc loadOldData];
                [ws.cmVc.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.left.right.mas_offset(0);
                    make.height.mas_equalTo(KScreenHeight * 0.75);
                }];
                
                [ws.cmVc.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.left.right.mas_offset(0);
                    make.height.mas_equalTo(KScreenHeight * 0.75);
                    
                }];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    [ws.view layoutIfNeeded];
                }];
                _isShowCommentView = YES;
                
            }break;
                
            case 5:{
                
                YZGShareView *share = [YZGShare yzgShareView];
                share.delegate = ws;
                share.object = mediaModel;
                
            }break;
                
            case 6:{
                
       
                
              [self.player pause];
                _isStop = YES;
               //点击用户头像进入详情页面，视频点进去显示视频，图片点进去显示图片
                LGUserMediaViewController *mediaVc = [[LGUserMediaViewController alloc] initWithVcType:_viewType];
                mediaVc.title = mediaModel.user_nicename;
                mediaVc.mediaModel = mediaModel;
                [ws presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:mediaVc];
                
            } break;
            case 7:{
             //点击关注
               
                
            }
            default:
                break;
        }
        
        
        
    };
    
    
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LGVideoPlayCell *cell = (LGVideoPlayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_viewType == 1) {
//        self.cmVc.submitCaback();
//        if (self.aliPlayer.isPlaying) {
//
//            [cell resumePlay];
//        }
        
    }else{
       //
        
        if (_isShowCommentView == YES) {
            
            _isShowCommentView = NO;
             self.cmVc.submitCaback();
            return;
        }
         self.cmVc.submitCaback();
        NSURL *url = [NSURL URLWithString:cell.model.uri];
        
        LWImageBrowserModel *model = [[LWImageBrowserModel alloc] initWithplaceholder:nil thumbnailURL:url HDURL:url containerView:cell positionInContainer:self.view.frame index:0];
        LWImageBrowser *imageBrow = [[LWImageBrowser alloc] initWithImageBrowserModels:@[model] currentIndex:0];
        imageBrow.isShowPageControl = NO;
       
        [self presentViewController:imageBrow animated:NO completion:nil];
        
    }
    
    
    
   
   
}

#pragma mark ShareViewDelegate分享
-(void)yzgShareView:(YZGShareView *)shareView clickShareButtonType:(ShareButtonType)shareButtonType{
    LGMediaListModel *mode = shareView.object;

    
    YZGShare *share = [[YZGShare alloc] init];
    share.pic = mode.thumb;
    share.title = @"我在聚乐直播发现了一个有趣的...";
    share.content = mode.desc;
    share.shareUrl = mode.uri;
    
//    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
//        if (successGetInfo) {
//            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:nil];
//            用户分享统计
     [YZGShare shareViewButtonClick:shareButtonType withShareContent:share success:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @"1";
    param[@"item_id"] = mode.id;
    param[@"owner_id"] = mode.owner_id;
    
    NSString *shareType = @"";
    switch (shareButtonType) {
        case ShareButtonTypeWeChatSession:
        {
            shareType = @"weChat";
        }
            break;
        case ShareButtonTypeWechatTimeline:
        {
           shareType = @"weChat";
        }
            break;
        case ShareButtonTypeTypeSinaWeibo:
        {
            shareType = @"weibo";
        }
            break;
        case ShareButtonTypeQQ:
        {
            shareType = @"qq";
        }
            break;
        case ShareButtonTypeQZone:
        {
            shareType = @"qq";
        }
            break;
    }
    param[@"way"] = shareType;
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagShare param:param success:^(id responseObject) {
        
        self.playScrollView.middleImageView.model.shares = [NSString stringWithFormat:@"%zd",[self.playScrollView.middleImageView.model.shares integerValue] + 1];
        
        self.playScrollView.middleImageView.sharesLabel.text = self.playScrollView.middleImageView.model.shares;

            } faile:^{

            }];
//    }];
}



//scroview




- (void)submitComment:(LGBottonCommentView *)edtiorView{
    
    if (!edtiorView.commentTexf.text.length) {
        
        [AlertTool ShowErrorInView:self.view withTitle:@"评论不能为空"];
        
        return;
    }
    [edtiorView.commentTexf resignFirstResponder];
    [edtiorView removeFromSuperview];
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @"1";
    param[@"item_id"] = edtiorView.mediaModel.id;
    param[@"owner_id"] = edtiorView.mediaModel.owner_id;
    param[@"content"] = edtiorView.commentTexf.text;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagComment param:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [AlertTool ShowErrorInView:self.view withTitle:@"评论成功"];
            self.cmVc.commentSuccess();
        }else{
            [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];

        }
        
    } faile:^{
        [AlertTool ShowErrorInView:self.view withTitle:@"评论失败"];
    }];
    
    
  
    
}




//cell离开移除播放器
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
}
//-(AliyunVodPlayer *)aliPlayer{
//    if (!_aliPlayer) {
//        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        _aliPlayer = [[AliyunVodPlayer alloc] init];
//        _aliPlayer.autoPlay = YES;
//        _aliPlayer.delegate = self;
//        //        _aliPlayer.displayMode = AliyunVodPlayerDisplayModeFitWithCropping;
//        //        });
//    }
//    return _aliPlayer;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

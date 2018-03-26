//
//  LGImageListController.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/26.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGImageListController.h"
#import "MainListModel.h"
#import "MainDataSource.h"
#import "LGMediaListModel.h"
#import "HSYTopicCell.h"
#import "HttpTool.h"
#import "LGShareController.h"
#import "YZGShare.h"
#import "Account.h"
#import "LGUserMediaViewController.h"


@interface LGImageListController ()<UITableViewDelegate,UITableViewDataSource,YZGShareViewDelegate>{
    
    YZGTableViewSectionItem *sectionItem;
    NSInteger _begin_limit;
}


@property(nonatomic, copy) UITableView  *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;

@end

@implementation LGImageListController

static NSString *cellID = @"HSYTopicCell";

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
}

- (void)initTableView{
    
    self.tableView.frame = self.view.frame;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.height -= 108;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSYTopicCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaNewData)];
   MJRefreshAutoStateFooter *footRef = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];

    self.tableView.mj_footer = footRef;
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)loaNewData{
    //取消上一次的请求任务
     _begin_limit = 0;
    [self requestLimit_begin:_begin_limit limit_num:20 isReload:YES];
    [self.tableView.mj_footer resetNoMoreData];
   
}

- (void)requestLimit_begin:(NSInteger)begin_limit limit_num:(NSInteger)limit_num isReload:(BOOL)isReload{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"2";
    param[@"token"] = [Account shareInstance].token;
    param[@"begin_limit"] = @(begin_limit);
    if (_isMe) {
        
        param[@"uid"] = [Account shareInstance].ID;
        
    }
    param[@"limit_num"] = @(20);
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetviews param:param success:^(id responseObject) {
  
        if ([responseObject[@"code"] integerValue] == 200) {
           NSMutableArray *listArray = [LGMediaListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if ([responseObject[@"limit_end"] integerValue] < 20) {
               
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            if (isReload == YES) {
                
                
                //进行图片计算
                [self calculateImageHeight:listArray isReload:YES];
                
                
            }else{
                 [self calculateImageHeight:listArray isReload:NO];
                
            }
          
        }
        
    } faile:^{
         [self endReresh];
    }];
    
}

- (void)calculateImageHeight:(NSArray *)dataArray isReload:(BOOL)isReload{
     dispatch_group_t group = dispatch_group_create();
    for (LGMediaListModel *model in dataArray) {
        
        dispatch_group_enter(group);
        NSURL *imageUrl = [NSURL URLWithString:model.avatar];
        //下载图片
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //拿到图片的尺寸
            CGSize imageSize = image.size;
            //从新计算行高
            model.width = imageSize.width;
            model.height = imageSize.height;
            //离开组
            dispatch_group_leave(group);
        }];
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [self endReresh];
        //如果是下拉刷新直接赋值
        if (isReload == YES) {
            [self.tableView.mj_header endRefreshing];
            self.listArray = [LGMediaListModel mj_objectArrayWithKeyValuesArray:dataArray];
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.listArray addObjectsFromArray:dataArray];
        }
        
          [self.tableView reloadData];
    });
    
}

- (void)endReresh{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

//
- (void)loadNextData{
    
    NSLog(@"哈哈");
    _begin_limit += 20;
    [self requestLimit_begin:_begin_limit limit_num:20 isReload:NO];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGMediaListModel *list = self.listArray[indexPath.row];
    return list.rowHeight;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    LGMediaListModel *list = self.listArray[indexPath.row];
    cell.cellAtion = ^(NSInteger ationType, LGMediaListModel *model) {
      
        KWeakSelf;
        switch (ationType) {
                //评论
            case 1:
            {
                LGShareController *shareVc = [[LGShareController alloc] init];
                shareVc.type = 2;
                shareVc.model = ws.listArray[indexPath.row];
               
                [ws presentNeedNavgation:YES presentendViewController:shareVc];
                
            }
                break;
                //分享
            case 2:
            {
              
               
                
            }
                break;
                //喜欢
            case 3:
            {
                
                
            }
                break;
            case 4:
            {
                LGUserMediaViewController *userMediaVc = [[LGUserMediaViewController alloc] initWithVcType:2];
                userMediaVc.mediaModel = list;
                userMediaVc.title = list.user_nicename;
                [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:userMediaVc];
                
            }
                break;
                
            default:
                break;
        }
        
    };
    [cell setItem:list forIndexPath:indexPath];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGShareController *shareVc = [[LGShareController alloc] init];
    shareVc.model = self.listArray[indexPath.row];
    shareVc.type = 2;
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:shareVc];
    
}




@end

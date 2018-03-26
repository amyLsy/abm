//
//  LGBgmVIew.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/29.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGBgmVIew.h"
#import "MJRefresh.h"
#import "YZGRequest.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "Account.h"
#import "LGBgmCell.h"
@interface LGBgmVIew()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) NSArray *calassArray;
@property(nonatomic, strong) NSArray *bgmDataArray;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property(nonatomic, assign) NSInteger viewStatus;
@property(nonatomic, assign) NSInteger curCell;
@end

@implementation LGBgmVIew{
    
    NSDictionary *_term;
    NSInteger _limit_begin;
}

static NSString *bgmCellID = @"bgmCellID";

-(void)awakeFromNib{
    [super awakeFromNib];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
//    [self addGestureRecognizer:tap];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LGBgmCell" bundle:nil] forCellReuseIdentifier:bgmCellID];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadBgm)];
//    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    _viewStatus = 1;
    _limit_begin = 0;
    [self loadBgmClass];
    
}

- (void)loadBgmClass{
    
   
    [AlertTool ShowInView:self];
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserGetBgmTerms param:nil success:^(id responseObject) {
        [AlertTool Hidden];
        if ([responseObject[@"code"] integerValue] == 200) {
            //请求成功
            self.calassArray = responseObject[@"data"];
            
            [self.tableView reloadData];
            _limit_begin = 0;
        }
        
    } faile:^{
         [AlertTool Hidden];
    }];
    
    
}

- (void)loadBgm{
    
    
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] =  [Account shareInstance].token;
        param[@"term"] = _term[@"term_id"];
        _viewTitle.text = _term[@"name"];
        param[@"limit_begin"] = @(_limit_begin);
        param[@"limit_num"] = @"20";
        [AlertTool ShowInView:self];
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserGetGgmList param:param success:^(id responseObject) {
            [AlertTool Hidden];
            if ([responseObject[@"code"] integerValue] == 200) {
                
                if ([responseObject[@"limit_end"] integerValue] < 20) {
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                //请求成功
                _viewStatus = 2;
                _limit_begin += 20;
                self.backButton.hidden = NO;
                self.bgmDataArray = responseObject[@"data"];
                
                [self.tableView reloadData];
                
            }
            
        } faile:^{
            [AlertTool Hidden];
        }];
    
    
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_viewStatus == 1) {
       return self.calassArray.count;
    }
   return self.bgmDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_viewStatus == 1) {
        static NSString *cellID = @"cellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary *dict = self.calassArray[indexPath.row];
        cell.textLabel.text = dict[@"name"];
        cell.detailTextLabel.text = dict[@"term"];
        return cell;
    }else{
        
        LGBgmCell *cell = [tableView dequeueReusableCellWithIdentifier:bgmCellID];
        NSDictionary *dict = self.bgmDataArray[indexPath.row];
        cell.titleLabel.text = dict[@"title"];
         return cell;
    }
  
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_viewStatus == 1) {
        return 36;
    }
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_viewStatus == 1) {
         _term = self.calassArray[indexPath.row];
         [self loadBgm];
        
       
    }else{
        
        if (_bgmPlayCallBack) {
            LGBgmCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *uri = self.bgmDataArray[indexPath.row][@"uri"];
            _bgmPlayCallBack(uri,cell,self,self.bgmDataArray,indexPath);
        }
    }
   
    
}

-(void)remove{
//    [self removeFromSuperview];
    
}
- (IBAction)back:(id)sender {
    _term = nil;
    _viewStatus = 1;
    _viewTitle.text = @"背景音乐";
    self.backButton.hidden = YES;
    _limit_begin = 0;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView reloadData];
}
- (IBAction)close:(id)sender {
    
    
    self.hidden = YES;
    
}

@end

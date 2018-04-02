//
//  LGCommentController.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//
#define comHeight 47
#import "LGCommentController.h"
#import "LGCommentCell.h"
#import "LGComment.h"
#import "LGCommentHeaderFooterView.h"
#import "AlertTool.h"
#import "Account.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "LGShareController.h"
#import "LGButtont.h"
#import "LGSubCommt.h"
#import "LGButtont.h"
@interface LGCommentController()



@end
@implementation LGCommentController{
    
    
    
    
}
- (NSMutableArray *)comments{
    
    if (_comments == nil) {
        
        _comments = [NSMutableArray array];
    }
    return _comments;
}



static NSString *cellID = @"commentID";
static NSString *replyCellID = @"replyCellID";
static NSString *commentHFViewID = @"replyCellID";
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupUI];
    _limit_end = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
}

-(void)setupTableView{
    [super setupTableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LGCommentCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LGReplyCell" bundle:nil]forCellReuseIdentifier:replyCellID];
       [self.tableView registerClass:[LGCommentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:commentHFViewID];
    self.tableView.sectionFooterHeight = 40;
    self.tableView.sectionHeaderHeight = 40;
    [self loadOldData];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)commentWillChange:(NSNotification *)noti{
    
   
    
//    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//
//    CGFloat offset = self.view.height - rect.origin.y;
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = self.view.height - (rect.origin.y - (KScreenHeight - self.view.height));
    __weak typeof(self) weakSelf = self;
    
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).mas_offset(-offset);
        
    }];
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
        
    }];
    

    
    
}

- (void)setNavBar:(UINavigationBar *)navBar{
    
}

#pragma mark - 布局UI
- (void)setupUI{

   
    UIView *commentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    /**
     *  背景图片
     */
//    imageView.image = [UIImage imageNamed:@"comment-bar-bg"];
    imageView.backgroundColor = rgba(175, 174, 175, 1);
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"有爱评论，说点好听的~";
    textField.font = [UIFont systemFontOfSize:14];
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    
    //按钮
    LGButtont *sendButton = [LGButtont buttonWithType:UIButtonTypeCustom];
//    [sendButton setImage:[UIImage imageNamed:@"comment_send_icon"] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendButton setBackgroundColor:rgba(136, 84, 237, 1)];
    [self.view addSubview:commentView];
    [commentView addSubview:imageView];
    [commentView addSubview:textField];
  
    [commentView addSubview:sendButton];
    
    __weak typeof(self) weakSelf = self;
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@47);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view).offset(0);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(commentView);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.size.mas_equalTo(CGSizeMake(comHeight, comHeight));
        make.top.mas_equalTo(commentView);
        make.bottom.mas_equalTo(commentView).offset(0);
        make.right.mas_equalTo(commentView).offset(0);
        make.width.mas_equalTo(60);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(comHeight - 2 * 5));
        
        make.right.mas_equalTo(sendButton.mas_left).offset(-10);
        make.top.mas_equalTo(commentView.mas_top).offset(5);
        make.left.mas_equalTo(commentView.mas_left).offset(10);
    }];
    
    
    
    [sendButton addTarget:self action:@selector(sendComments:) forControlEvents:UIControlEventTouchUpInside];
    self.commentView = commentView;
    self.commentSendButton = sendButton;
    self.commentTextField = textField;
    
}

- (void)dismissVc{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发评论
- (void)sendComments:(LGButtont *)butn{
    if (butn.object) {
       //回复评论的评论
        LGComment *commentModel = butn.object;
        if (!self.commentTextField.text.length) {
            [AlertTool ShowErrorInView:self.view withTitle:@"评论不能为空"];
            return;
        }
        [self.commentTextField resignFirstResponder];
        if (_submitCaback) {
            [self.tableView.mj_footer resetNoMoreData];
            _submitCaback();
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"type"] = @(3);
        param[@"item_id"] = commentModel.id;
        param[@"owner_id"] = _model.owner_id;
        param[@"content"] = self.commentTextField.text;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagComment param:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [AlertTool ShowErrorInView:self.view.superview withTitle:@"评论成功"];
                [self.commentTextField resignFirstResponder];
                self.commentTextField.text = nil;
                butn.object = nil;
                _isSuccess = YES;
                [self close];
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
                butn.object = nil;
                
            }
            
        } faile:^{
            [AlertTool ShowErrorInView:self.view withTitle:@"评论失败"];
            butn.object = nil;
        }];
        
        
        
    }else{
        
        
      //回复评论
        if (!self.commentTextField.text.length) {
            [AlertTool ShowErrorInView:self.view withTitle:@"评论不能为空"];
            return;
        }
        [self.commentTextField resignFirstResponder];
        if (_submitCaback) {
            [self.tableView.mj_footer resetNoMoreData];
            _submitCaback();
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"type"] = @(_type);
        param[@"item_id"] = _model.id;
        param[@"owner_id"] = _model.owner_id;
        param[@"content"] = self.commentTextField.text;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagComment param:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [AlertTool ShowErrorInView:self.view.superview withTitle:@"评论成功"];
                _isSuccess = YES;
                if (_commentSuccess) {
                    _commentSuccess();
                }
                [self close];
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
                
                
            }
            
        } faile:^{
            [AlertTool ShowErrorInView:self.view withTitle:@"评论失败"];
        }];
        
        
    }
    
   
    
   
}

- (void)loadOldData{
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"item_id"] = _model.id;
    param[@"limit_begin"] = @(_limit_end);
    param[@"limit_num"] = @"20";
    param[@"type"] = @(self.type);
    param[@"owner_id"] = _model.owner_id;
    param[@"token"] = [Account shareInstance].token;
    _isSuccess = NO;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetComments param:param success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if (_limit_end < 20) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            _limit_end += 20;
            [self.comments addObjectsFromArray:[LGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
        }
        
    } faile:^{
        [AlertTool ShowErrorInView:self.view withTitle:@"获取数据失败"];
         [self.tableView.mj_footer endRefreshing];
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //传递当前评论和父评论
    id commetModel = self.comments[indexPath.row];
    LGCommentCell *cell;
    if ([commetModel isKindOfClass:[LGComment class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
         [cell.subCommens addTarget:self action:@selector(go2subComentView:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:replyCellID];
    
    }
     cell.comment = commetModel;
   

    return cell;


}


- (void)go2subComentView:(LGButtont *)sender {
    //进入子评论
    LGShareController *subCommentVc = [[LGShareController alloc] init];
    subCommentVc.model = self.model;
    subCommentVc.commentModel = sender.object;
    subCommentVc.type = _type;
    subCommentVc.title = @"评论";
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:subCommentVc];
    if (_g2SubCommtCaback) {
        _g2SubCommtCaback();
    }
   
    
}

//计算行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LGComment *comment = self.comments[indexPath.row];
//
//   
//    //返回计算的行高
//    return comment.rowHeght;
//}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LGComment *comment = self.comments[indexPath.row];
    self.commentSendButton.object = comment;
    self.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@",comment.user_nicename];
    
    [self.commentTextField becomeFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.commentSendButton.object = nil;
    [self.commentTextField resignFirstResponder];
    self.commentSendButton.tag = 0;
    self.commentTextField.placeholder = @"我来说两句";
}
//显示组标题，显示有无评论
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //从循环池中出去HeaderFooterView
    UITableViewHeaderFooterView *hfView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:commentHFViewID];
    //创建一个view
    UIView *view = [[UIView alloc] init];
    //计算view的frame
    view.frame = CGRectMake(0,  0, self.tableView.width, 40 -1);
    view.backgroundColor = [UIColor whiteColor];
    //创建一个用来显示文字的lable
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.frame = CGRectMake(2 * 10,  0, view.width/2, view.height);
    //对当前评论进行判断是否有无
    if ([self.model.comments integerValue] <=  0 && !self.comments.count) {
        titleLable.text = @"暂无评论";
    }else{
        titleLable.text = @"最新评论";
    }
    [view addSubview:titleLable];
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(close) forControlEvents:(UIControlEventTouchUpInside)];
     button.frame = CGRectMake(view.width - 40,  0, 40, view.height);
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"弹窗关闭"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    
    [hfView addSubview:view];
    return hfView;

}

- (void)close{
    
    if (self.submitCaback) {
        self.commentSendButton.object = nil;
        self.commentTextField.text = nil;
        _limit_end = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [_comments removeAllObjects];
        [self.tableView reloadData];
        self.submitCaback();
    }
}


@end

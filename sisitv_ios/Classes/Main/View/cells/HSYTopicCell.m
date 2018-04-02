//
//  HSYTopicCell.m
//
//
//  Created by ming on 16/11/7.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "HSYTopicCell.h"
#import "UIImageView+LGUIimageView.h"
#import "HSYTopPicView.h"
#import "LGJubaoView.h"
#import "Account.h"
#import "HttpTool.h"
#import "YZGShare.h"
@interface HSYTopicCell()<YZGShareViewDelegate>



///** 用户的名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

//@property (nonatomic, copy) NSString *name;
///** 用户的头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageview;

///** 帖子审核通过的时间 */

@property (weak, nonatomic) IBOutlet UILabel *created_atLable;
///** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_Lable;

///** 顶数量 */

@property (weak, nonatomic) IBOutlet UIButton *dinButton;
///** 踩数量 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
///** 评论数量 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
///** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *repostButton;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *topcomLable;
//动态添加中间内容

@end
@implementation HSYTopicCell


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
}




- (HSYTopPicView *)picView{
    if (_picView == nil) {
        _picView = [HSYTopPicView viewFromeNib];
        [self.contentView addSubview:_picView];
    }
    
    return _picView;
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    
    LGMediaListModel *listModel = item;
    _list = listModel;
    
    [self setUIdata];
    
}

- (void)setUIdata{
    
    _nameLable.text = _list.user_nicename;
    _text_Lable.text = _list.title;
    [self setButton:_repostButton count:[_list.shares integerValue] placeholderName:@"分享"];
     [self setButton:_commentButton count:[_list.comments integerValue] placeholderName:@"评论"];
    [_profileImageview setHeader:_list.avatar];
    self.picView.list = _list;
    self.picView.frame = _list.centnViewFrame;
    if (_list.is_like) {
        _dinButton.selected = YES;
    }else{
       _dinButton.selected = NO;
        
    }
}
- (void)setList:(LGMediaListModel *)list{
   
    _list = list;
    [self setUIdata];

}
- (void)setButton:(UIButton *)button count:(NSInteger)count placeholderName:(NSString *)placeholderName{
    NSString *str;
    if (count > 10000) {
        str = [NSString stringWithFormat:@"%.2f万",count/1000.0];
    }else if (count > 0){
        
        str = [NSString stringWithFormat:@"%zd",count];
    }else{
        str = placeholderName;
    }
    
    [button setTitle:str forState:UIControlStateNormal];
    
}


- (IBAction)commet:(id)sender {
    
    if (_cellAtion) {
        _cellAtion(1,_list);
    }
}
- (IBAction)go2UserMedia:(id)sender {
    
    if (_cellAtion) {
        _cellAtion(4,_list);
    }
    
}

- (IBAction)share:(id)sender {
    YZGShareView *share = [YZGShare yzgShareView];
    share.delegate = self;
    share.object = _list;
}
- (IBAction)like:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] =  [Account shareInstance].token;
    dict[@"type"] = @"2";
    dict[@"item_id"] = self.list.id;
    dict[@"owner_id"] = self.list.owner_id;
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserlike param:dict success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            //点赞成功
            
            if (self.dinButton.selected) {
                self.list.likes = [NSString stringWithFormat:@"%zd",[self.list.likes integerValue] + 1];
                self.list.is_like = YES;
            }else{
                
//                self.list.likes = [NSString stringWithFormat:@"%zd",[self.list.likes integerValue] - 1];
            }
            self.dinButton.selected =  !self.dinButton.selected;
        }
        
    } faile:^{
        
    }];
}

- (IBAction)didClick:(id)sender {
  
    [LGJubaoView showView];
}

#pragma mark ShareViewDelegate分享
-(void)yzgShareView:(YZGShareView *)shareView clickShareButtonType:(ShareButtonType)shareButtonType{
    LGMediaListModel *mode = shareView.object;
    
    
    YZGShare *share = [[YZGShare alloc] init];
    share.pic = mode.uri;
    share.title = mode.title;
    share.content = mode.desc;
    share.shareUrl = mode.uri;
    
    //    [YZGShare getShareInfoWithParam:param success:^(id response, BOOL successGetInfo) {
    //        if (successGetInfo) {
    //            [YZGShare shareViewButtonClick:shareButtonType withShareContent:response success:nil];
    //            用户分享统计
    [YZGShare shareViewButtonClick:shareButtonType withShareContent:share success:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"type"] = @"2";
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
//        case ShareButtonTypeTypeSinaWeibo:
//        {
//            shareType = @"weibo";
//        }
//            break;
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
        
    } faile:^{
        
    }];
    //    }];
}




@end

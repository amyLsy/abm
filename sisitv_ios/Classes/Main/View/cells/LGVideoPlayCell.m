//
//  LGVideoPlayCell.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/25.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGVideoPlayCell.h"
#import "HttpTool.h"
#import "UIImageView+LGUIimageView.h"
#import "AlertTool.h"
#import "YZGAppSetting.h"


#import "Account.h"
@interface LGVideoPlayCell()

@property (nonatomic, strong)UIView *playerView;


@end
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@implementation LGVideoPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [YZGAppSetting sharedInstance].userAttArray = [NSMutableArray array];
    self.attentionLabel.layer.cornerRadius = 3;
    self.attentionLabel.layer.masksToBounds = YES;
    
    
}


- (void)setModel:(LGMediaListModel *)model{
    
    
    _model = model;
    [self.avatarImageView setHeader:model.avatar];
    self.nicNameLabel.text = model.user_nicename;
    self.sharesLabel.text = model.shares;
    self.commentsLabel.text = model.comments;
    self.likesLabel.text = model.likes;
    self.decLabel.text = model.desc;
    [self.bgImageView lg_setImageWithurl:model.thumb placeholderImage:nil];
    self.firesLabel.text = model.reward;
    if (model.status == 2) {
        self.statusLable.text = @"审核中";
    }else{
        self.statusLable.text = @"";

    }
    if (_cellType == 1) {
    }

    //表示已经点赞
    if (model.is_like == 1) {
        self.likeImageView.image = [UIImage imageNamed:@"image_like_icon"];
    }else{
        self.likeImageView.image = [UIImage imageNamed:@"noneLike_icon"];
    }

    if ([model.owner_id isEqualToString:[Account shareInstance].ID]) {
        
        _attentionLabel.hidden = YES;
    }else{
        
        _attentionLabel.hidden = NO;
        
        if (model.is_attention) {
            _attentionLabel.hidden = YES;
            [_attentionLabel setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            _attentionLabel.hidden = NO;
            [_attentionLabel setTitle:@"未关注" forState:UIControlStateNormal];
        }
        for (NSString *userID in [YZGAppSetting sharedInstance].userAttArray) {
            if ([model.owner_id isEqualToString:userID]) {
                _attentionLabel.hidden = YES;
            }
        }
    }
    
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    LGMediaListModel *model = (LGMediaListModel *)item;
    
    _model = model;
    
    
    
    [self.avatarImageView setHeader:model.avatar];
    self.nicNameLabel.text = model.user_nicename;
    self.sharesLabel.text = model.shares;
    self.commentsLabel.text = model.comments;
    self.likesLabel.text = model.likes;
    self.decLabel.text = model.desc;
     [self.bgImageView lg_setImageWithurl:model.thumb placeholderImage:nil];
    self.firesLabel.text = model.reward;
    if (model.status == 2) {
        self.statusLable.text = @"审核中";
    }else{
        self.statusLable.text = @"";
        
    }
    if (_cellType == 1) {
        
    }
   
    //表示已经点赞
    if (model.is_like == 1) {
        self.likeImageView.image = [UIImage imageNamed:@"image_like_icon"];
    }else{
       self.likeImageView.image = [UIImage imageNamed:@"noneLike_icon"];
    }
    
    if ([model.owner_id isEqualToString:[Account shareInstance].ID]) {
        
        _attentionLabel.hidden = YES;
    }else{
        
        _attentionLabel.hidden = NO;
        
        if (model.is_attention) {
            _attentionLabel.hidden = YES;
            [_attentionLabel setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            _attentionLabel.hidden = NO;
            [_attentionLabel setTitle:@"未关注" forState:UIControlStateNormal];
        }
        for (NSString *userID in [YZGAppSetting sharedInstance].userAttArray) {
            if ([model.owner_id isEqualToString:userID]) {
                _attentionLabel.hidden = YES;
            }
        }
    }
   
}




//- (void)loadUserInfo:(LGMediaListModel *)model{
//
//    [AlertTool showWithCustomModeInView:self.contentView];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"token"] = [Account shareInstance].token;
//    param[@"id"] = self.model.owner_id;
//    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUserInfo param:param success:^(id responseObject) {
//
//        if ([responseObject[@"code"] integerValue] == 200) {
//            BaseUser *userModel = [BaseUser mj_objectWithKeyValues:responseObject[@"data"]];
//            if ([userModel.attention_status isEqualToString:@"已关注"]) {
//                //已经关注
//                _model.is_attention =  YES;
//                _attentionLabel.hidden = YES;
//                [_attentionLabel setTitle:@"已关注" forState:UIControlStateNormal];
//            }else{
//                _model.is_attention =  NO;
//                _attentionLabel.hidden = NO;
//                [_attentionLabel setTitle:@"未关注" forState:UIControlStateNormal];
//
//            }
//
//
//
//        }else{
//
//            [AlertTool ShowErrorInView:self.contentView withTitle:@"获取数据失败"];
//            [AlertTool Hidden];
//        }
//
//    } faile:^{
//        [AlertTool Hidden];
//    }];
//}








///1为返回 2举报 3显示提交评论 4显示评论界面
- (IBAction)backAtion:(id)sender {
    
    if (_cellAtion) {
        //
        _cellAtion(1,_model);
    }
}

- (IBAction)jubao:(id)sender {
    
    if (_cellAtion) {
        //
        _cellAtion(2,_model);
    }
}
- (IBAction)shouCommentView:(id)sender {
    
    if (_cellAtion) {
        //
        _cellAtion(3,_model);
    }
}

- (IBAction)commentAtion:(id)sender {
    if (_cellAtion) {
        //
        _cellAtion(4,_model);
    }
}
- (IBAction)likeAtion:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] =  [Account shareInstance].token;
    if ([_model.uri.lastPathComponent hasSuffix:@".mp4"]) {
       dict[@"type"] = @"1";
    }else{
        dict[@"type"] = @"2";
    }
    
    dict[@"item_id"] = self.model.id;
    dict[@"owner_id"] = self.model.owner_id;
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserlike param:dict success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            //点赞成功
            self.model.is_like = 1;
                self.model.likes = [NSString stringWithFormat:@"%zd",[self.model.likes integerValue] + 1];
                self.likeImageView.image = [UIImage imageNamed:@"image_like_icon"];
               self.likesLabel.text = self.model.likes;
                
                
            }else{
                
                self.model.likes = [NSString stringWithFormat:@"%zd",[self.model.likes integerValue] - 1];
            }
        
    } faile:^{
        
    }];
    
}






- (IBAction)shareAtion:(id)sender {
    if (_cellAtion) {
        //
        _cellAtion(5,_model);
    }
    
}
- (IBAction)go2UserMedia:(id)sender {
    
    if (_cellAtion) {
        //
        _cellAtion(6,_model);
    }
}



- (IBAction)guanzhuAtion:(UIButton *)sender {
  
    
        AccountParam *param = [[AccountParam alloc]init];
        param.userid = self.model.owner_id;
        [[Account shareInstance] attentionOrCancelAttentionWithCurrentButtonTitle:sender.titleLabel.text WithParam:param success:^(BOOL isSuccess, id result) {
            
            if (isSuccess) {
                _model.is_attention =  YES;
                self.attentionLabel.hidden = YES;
                [self.attentionLabel setTitle:result forState:UIControlStateNormal];
                [[YZGAppSetting sharedInstance].userAttArray addObject:_model.owner_id];
            }else{
                _model.is_attention =  NO;
                [[YZGAppSetting sharedInstance].userAttArray removeObject:_model.owner_id];
                [AlertTool ShowErrorInView:self.contentView withTitle:@"关注失败"];
            }
            
            
        }];
    
}
+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    return CGSizeMake(KScreenWidth , KScreenHeight);
}





@end

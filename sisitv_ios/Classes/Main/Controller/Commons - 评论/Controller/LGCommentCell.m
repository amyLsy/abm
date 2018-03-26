//
//  LGCommentCell.m
//  ifaxian
//
//  Created by ming on 16/11/18.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGCommentCell.h"
#import "LGReplyView.h"
#import "UIImageView+LGUIimageView.h"
#import "LGCommentController.h"
#import "LGSubCommt.h"
#import "LGReplyView.h"
#import "Account.h"
#import "HttpTool.h"


@interface LGCommentCell()
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**
 *  回复评论按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
/**
 *  评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contenLable;
/**
 *  回复的评论
 */
@property (weak, nonatomic) IBOutlet  UIView *replyView;
/**
 *  评论的时间
 */


@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *superCommet;

@property (weak, nonatomic) IBOutlet UILabel *subComent;
@property (weak, nonatomic) IBOutlet UIView *subCommtView;
@property (weak, nonatomic) IBOutlet UIButton *likesBUtton;

@end


@implementation LGCommentCell

#pragma mark - nib加载完毕方法
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //取消autoresizing    self.autoresizingMask = UIViewAutoresizingNone;
    //添加头像名字手势跳转到用户界面
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
    [_avatarImageView addGestureRecognizer:avatarTap];
     UITapGestureRecognizer *nameLableTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go2userVc:)];
     [_nameLable  addGestureRecognizer:nameLableTap];
    self.subComentView.layer.cornerRadius = 3;
    self.subComentView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 跳转用户界面
- (IBAction)go2userVc:(id)sender {
   
    
 
    
    
    
}
- (IBAction)likeBUtton:(id)sender {
    
    //节目点赞
    LGComment *model = _comment;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [Account shareInstance].token;
    dict[@"type"] = @"3";
    dict[@"item_id"] = model.id;
    dict[@"owner_id"] = model.owner;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserlike param:dict success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            model.likes = [NSString stringWithFormat:@"%zd",[model.likes integerValue] + 1];
            [_likesBUtton setTitle:model.likes forState:UIControlStateNormal];
            _likesBUtton.selected = YES;
        }
        
    } faile:^{
        
        
    }];
}


- (void)setComment:(id)comment{
    
    _comment = comment;
    LGComment *model = _comment;
    _likesBUtton.selected = model.is_like;
    if ([model.likes integerValue] > 0) {
        [_likesBUtton setTitle:model.likes forState:UIControlStateNormal];
    }else{
        
         [_likesBUtton setTitle:@"" forState:UIControlStateNormal];
    }
   
    if ([comment isKindOfClass:[LGComment class]]) {
        LGComment *commentModel = comment;
        self.contenLable.text = commentModel.content;
        [self.avatarImageView setHeader:commentModel.avatar];
        //昵称
        self.nameLable.text = commentModel.user_nicename;
        self.subCommens.object = commentModel;
        //时间
        self.timeLable.text = commentModel.add_time;
        if ([commentModel.sub_comments integerValue] > 0) {
            self.subComentView.hidden = NO;
            [self.subCommens setTitle:[NSString stringWithFormat:@"查看全部%@条回复 >",commentModel.sub_comments] forState:UIControlStateNormal];
        }else{
            
            self.subComentView.hidden = YES;
        }
    }else{
        for (UIView *view in self.subCommtView.subviews) {
            
            [view removeFromSuperview];
        }
        
       //子评论
         LGSubCommt *commentModel = comment;
        
        [self.avatarImageView setHeader:commentModel.avatar];
        //昵称
        self.nameLable.text = commentModel.user_nicename;
        self.timeLable.text = commentModel.add_time;
        self.subComent.text = commentModel.content;
        
        
        for (int i = 0; i  <  commentModel.sub_comments.count; i ++) {
            LGSubCommt *subCoomtModel = commentModel.sub_comments[i];
            LGReplyView *view = [LGReplyView viewFromeNib];
            view.width = self.subCommtView.width;
            view.height = subCoomtModel.subHeight + 7;
            view.x = 0;
            if (i == 0) {
                
                view.y = 0;
            }else{
                LGSubCommt *subModel = commentModel.sub_comments[i - 1];
                
                view.y = CGRectGetMaxY(self.subCommtView.subviews.lastObject.frame);
                
            }
            if (subCoomtModel.user_nicename.length) {
                [self addStrWithLabe:view.subCoomtModel str:[NSString stringWithFormat:@"%@:%@",subCoomtModel.user_nicename,subCoomtModel.content] addStyleStr:subCoomtModel.user_nicename];
                [self.subCommtView addSubview:view];
            }else{
                view.subCoomtModel.text = [NSString stringWithFormat:@"%@:%@",subCoomtModel.user_nicename,subCoomtModel.content];
                
            }
           
            
        }
        
       
        
        
//        if (commentModel.sub_comments.count) {
//            self.contenLable.hidden = YES;
//
//
//             LGComment *model = commentModel.sub_comments.firstObject;
//            self.nameLable.text = model.user_nicename;
//           [self.avatarImageView setHeader:model.avatar];
//            self.replyView.hidden = NO;
//            [self addStrWithLabe:self.subComent str:[NSString stringWithFormat:@"回复%@:%@",commentModel.user_nicename,model.content] addStyleStr:model.user_nicename];
//
//            [self addStrWithLabe:self.superCommet str:[NSString stringWithFormat:@"%@:%@",commentModel.user_nicename,commentModel.content] addStyleStr:commentModel.user_nicename];
//
//        }else{
//
//            self.contenLable.text = commentModel.content;
//            self.contenLable.hidden = NO;
//            self.replyView.hidden = YES;
//        }
        
        
    }
    
    
    
}


- (void)addStrWithLabe:(UILabel *)label str:(NSString *)str addStyleStr:(NSString *)addStyleStr{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc] init];
    
    [text addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, text.length)];
    
    NSRange rang = [str rangeOfString:addStyleStr];
    
    [text addAttribute:NSForegroundColorAttributeName
     
                 value:RGB_COLOR(45, 81, 133, 1)
     
                 range:rang];
    
    label.attributedText = text;
    

}



#pragma mark - 评论和父评论逻辑处理
- (void)comment:(LGComment *)comment parentComment:(LGComment *)parent{
    _comment = comment;
    //如果存在父评论
//    if (comment.parent.length) {
//        self.replyView.titleLable.text = [NSString stringWithFormat:@"@%@ 发表于 %@", parent.author.nickname,parent.date];
//        self.replyView.contentText.text = parent.content;
//    }else{
//        self.replyView.titleLable.text = nil;
//        self.replyView.contentText.text = nil;
//    }
    //内容
//    self.contenLable.text = comment.content;
    //头像
//    [self.avatarImageView setHeader:[comment.author.slug lg_getuserAvatar]];
//    //昵称
//    self.nameLable.text = comment.author.nickname;
//    //时间
//    self.timeLable.text = comment.date;
 
}
#pragma mark - 修改cell的大小
- (void)setFrame:(CGRect)frame{
    
//    CGRect cellFrame = frame;
//    cellFrame.size.height -= 1;
//    cellFrame.size.width -= 2 * LGCommonSmallMargin;
//    cellFrame.origin.x += LGCommonSmallMargin;
//    cellFrame.origin.y += LGCommonMargin;
    
    
    [super setFrame:frame];
    
}

- (IBAction)jubao:(id)sender {
//    [LGJubaoView showView];
}


@end

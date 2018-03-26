//
//  ChatConversationViewCell.m
//  liveFrame
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatConversationCell.h"
#import "ChatMessage.h"

@interface ChatConversationCell ()
@property (weak, nonatomic) IBOutlet UILabel *userLevel;

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (nonatomic , strong) NSShadow *shadow;

@end

@implementation ChatConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.shadow = [[NSShadow alloc]init];
    self.shadow.shadowBlurRadius = 1.0;
    self.shadow.shadowOffset = CGSizeMake(1.0, 0.5);
    self.shadow.shadowColor = [UIColor blackColor];
}

-(void)labelSetShadow:(UILabel *)label{
    //阴影透明度
    label.layer.shadowOpacity = 1.0;
    //阴影宽度
    label.layer.shadowRadius = 0.5;
    //阴影颜色
    label.layer.shadowColor = [UIColor redColor].CGColor;
    //映影偏移
    label.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
}
-(void)setChatMessage:(ChatMessage *)chatMessage{
    _chatMessage = chatMessage;
    
    if (chatMessage.content)
    {
        
//        BOOL systemNotice = NO;
//        BOOL giftMessage = NO;
//        BOOL commendMessage = NO;
        
//        if (_chatMessage.type == ChatNomalMessage) {
//            systemNotice = NO;
//        }else if (_chatMessage.type == ChatCommendMessage || chatMessage.type == ChatExitMessage) {
//            commendMessage = YES;
//        }else if (_chatMessage.type == ChatGiftMessage) {
//            giftMessage = YES;
//        }else{
//            systemNotice = YES;
//        }
        
        NSString *userName = [NSString stringWithFormat:@"%@: ",_chatMessage.userName];
        NSString *info = _chatMessage.content;
        NSString *userLevl = [NSString stringWithFormat:@"%@",_chatMessage.userLevel];
        NSString * userLevelImageName = _chatMessage.userLevelImageName;
        // 创建一个富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",userName,info]];
        
        //修改用户名文字的样式
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#D79510"] range:NSMakeRange(0, userName.length)];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, userName.length)];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attri.length)];
        if (_chatMessage.type == ChatAnnouncement) {
            //修改消息文字的样式
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6495ED"] range:NSMakeRange(userName.length, info.length)];
            
            
        }else if(_chatMessage.type == ChatGiftMessage){
            //修改礼物消息文字的样式
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F95085"] range:NSMakeRange(userName.length, info.length)];
        }else if (_chatMessage.type == ChatEnterMessage || _chatMessage.type == ChatExitMessage) {
            
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F95085"] range:NSMakeRange(userName.length, info.length)];
        }
        else if (_chatMessage.type == ChatSystemMessage) {
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(userName.length, info.length)];
        }
        else if (_chatMessage.type == ChatNomalMessage) {
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(userName.length, info.length)];
        }
        else{
            //修改消息文字的样式
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F95085"] range:NSMakeRange(userName.length, info.length)];
        }
        
        //消息文字添加阴影
        [attri addAttribute:NSShadowAttributeName
                      value:self.shadow
                      range:NSMakeRange(0,attri.length)];
        
        BOOL systemNotice = YES;
        if (_chatMessage.type == ChatNomalMessage) {
            systemNotice = NO;
        }
        
        self.userLevel.hidden = systemNotice;
        self.userLevel.text = userLevl;
        
        if (!systemNotice) {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:userLevelImageName];
            // 设置图片大小
            attch.bounds = CGRectMake(0, -2, 33, 16);
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            [attri insertAttributedString:[[NSAttributedString alloc]initWithString:@" "] atIndex:1];
        }
        self.info.attributedText = attri;
    }
}

-(NSMutableAttributedString *)creatAttributedStringWithString:(NSString *)string withTextColot:(UIColor *)textColor{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range =  NSMakeRange(0, [attrString length]);
    [attrString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    return attrString;
}
@end

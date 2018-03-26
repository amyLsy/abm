//
//  LGShowAddView.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGShowAddView.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "Account.h"

@implementation LGShowAddView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)submitButton:(id)sender {
    
    
    if (_isEditor == YES) {
        if (self.edit) {
            self.edit(self);
        }
    }else{
        NSString *title = self.titleTextField.text;
        NSString *desc = self.descTitleTextField.text;
        NSString *duration = self.timeTextField.text;
        NSString *price = self.priceTextField.text;
        
        
        if (title.length && desc.length && duration.length && price.length) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = [Account shareInstance].token;
            param[@"title"] = title;
            param[@"desc"] = desc;
            param[@"duration"] = duration;
            param[@"price"] = price;
            [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagAddShow param:param success:^(id responseObject) {
                
                if ([responseObject[@"code"] integerValue] == 200) {
                    self.submit(self);
                    [AlertTool ShowErrorInView:self.superview withTitle:@"添加成功"];
                    
                    
                }
                
            } faile:^{
                [AlertTool ShowErrorInView:self.superview withTitle:@"请求错误"];
            }];
        }else{
            
            [AlertTool ShowErrorInView:self.superview withTitle:@"选项不能为空"];
        }
        
    }
    
   
    
   
    
    
    
}
- (IBAction)cancel:(id)sender {
    if (self.cancel) {
        self.cancel(self);
    }
    [self removeFromSuperview];
}

@end

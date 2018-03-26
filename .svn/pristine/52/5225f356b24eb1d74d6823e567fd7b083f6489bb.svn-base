//
//  FeedBackViewController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Account.h"
#import "HttpTool.h"
#import "AlertTool.h"
 
@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submint;
@property (weak, nonatomic) IBOutlet UITextView *feedback_text;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.submint.layer.cornerRadius = self.submint.height/2.0;
    self.submint.backgroundColor = [UIColor darkGrayColor];
}

- (IBAction)submit {
    Account *account =[Account shareInstance];
    if (!account.token || self.feedback_text.text.length <=0){
        return;
    }
    NSDictionary *param = @{@"token":account.token,@"content":self.feedback_text.text};
     [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagwChangeFeedback param:param.mutableCopy  success:^(id responseObject) {
        NSString *res = responseObject[@"descrp"];
        [AlertTool ShowInView:self.view onlyWithTitle:res hiddenAfter:1.0];
    } faile:nil];
}
@end

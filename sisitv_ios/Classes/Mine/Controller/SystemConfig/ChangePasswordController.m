//
//  ChangePasswordController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChangePasswordController.h"
#import "Account.h"
#import "HttpTool.h"
#import "AlertTool.h"
#import "RootTool.h"
#import "LeanCloudTool.h"
@interface ChangePasswordController ()


@property (weak, nonatomic) IBOutlet UITextField *oldPassTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *firstTimePassTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *secondTimePassTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    [self textFiledSetLeftView:self.oldPassTextFiled withImageName:@"password"];
    [self textFiledSetLeftView:self.secondTimePassTextFiled withImageName:@"password"];
    [self textFiledSetLeftView:self.firstTimePassTextFiled withImageName:@"password"];
    self.makeSureButton.layer.cornerRadius = self.makeSureButton.height/2.0;
    [self.makeSureButton setBackgroundColor:[UIColor darkGrayColor]];
}

-(void)textFiledSetLeftView:(UITextField *)textFiled withImageName:(NSString *)name{
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    textFiled.leftView = imagView;
}
- (IBAction)makeSureButton:(UIButton *)sender
{
    Account *account =[Account shareInstance];
    if (!account.token){
        return;
    }
    AccountParam *param = [AccountParam accountParam];
    param.oldpassword = self.oldPassTextFiled.text;
    param.password = self.firstTimePassTextFiled.text;
    param.repassword = self.secondTimePassTextFiled.text;
    [account changePasswordWithParam:param success:^(BOOL successGetInfo, id responseObj) {
        if (successGetInfo) {
            [Account removeAccount];
            [self dismissViewControllerAnimated:NO completion:nil];
            [[RootTool sharedInstance] chooseRootController];
        }else{
            [AlertTool ShowInView:KKeyWindow onlyWithTitle:responseObj hiddenAfter:2.0];
        }
    }];
}


@end

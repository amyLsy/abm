//
//  LoginController.m
//  liveFrame
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginController.h"
#import "PhoneLoginController.h"
#import "BaseWebViewController.h"
#import "BaseButton.h"
#import "Account.h"
#import "YZGShare.h"
#import "AlertTool.h"
#import "RootTool.h"
#import "YZGAppSetting.h"
#import "ThirdLoginService.h"
#import "RegiestController.h"
#import "ForgetController.h"

@interface LoginController ()

//@property (weak, nonatomic) IBOutlet UIView *thirdButtonView;
@property (weak, nonatomic) IBOutlet UILabel *selectLoginType;

//@property (weak, nonatomic) IBOutlet BaseButton *weChat;
//@property (weak, nonatomic) IBOutlet BaseButton *QQ;
//@property (weak, nonatomic) IBOutlet BaseButton *sina;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;

@property (nonatomic , copy) void(^successLogin)(void);
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;

@end

@implementation LoginController

-(instancetype)initWithSuccessLogin:(void (^)(void))successLogin{
    if (self = [super init]) {
        self.successLogin = successLogin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //检查是否上架
//    KWeakSelf;
//    [[YZGAppSetting sharedInstance] checkIsInAppleStore:^(BOOL isInAppStore) {
//        if (isInAppStore){
//            ws.thirdButtonView.hidden = NO;
//            ws.selectLoginType.hidden = NO;
//        }else{
//            ws.thirdButtonView.hidden = YES;
//            ws.selectLoginType.hidden = YES;
//        }
//    }];
//    self.thirdButtonView.hidden = NO;
//    self.selectLoginType.hidden = NO;
}
- (IBAction)phoneLoginBtnAction:(id)sender {
    if (self.phoneNumTextField.text.length == 0) {
        [AlertTool ShowErrorInView:self.view withTitle:@"请输入手机号！"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [AlertTool ShowErrorInView:self.view withTitle:@"密码"];
        return;
    }
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.phoneNumTextField.text;
    param.password = self.passwordTextField.text;
    KWeakSelf;
    [[Account shareInstance] loginWithParam:param success:^(BOOL successGetInfo,id responseObj){
        if (!successGetInfo) {
            [AlertTool ShowErrorInView:ws.view withTitle:responseObj];
        }else{
            ws.successLogin();
            [ws dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (IBAction)wechatLoginAction:(id)sender {
    
    //lsy
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    [[ThirdLoginService sharedInstance] wechatLogin:^(BOOL success, ShareParam *reqParam) {
        if (!success) {
            [AlertTool ShowErrorInView:self.view withTitle:@"微信登录失败"];
            return ;
        }
        [YZGShare sendOauthUserInfoWithParam:reqParam success:^(id response, BOOL successGetInfo) {
            if (successGetInfo) {
                [AlertTool Hidden];
                self.successLogin();
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:response];
            }
        }];
    }];
}
- (IBAction)qqLoginAction:(id)sender {
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    [[ThirdLoginService sharedInstance] qqlogin:^(BOOL success, ShareParam *reqParam) {
        
        if (!success) {
            [AlertTool ShowErrorInView:self.view withTitle:@"QQ登录失败"];
            return ;
        }
        [YZGShare sendOauthUserInfoWithParam:reqParam success:^(id response, BOOL successGetInfo) {
            if (successGetInfo) {
                [AlertTool Hidden];
                self.successLogin();
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:response];
            }
        }];
    }];
}
- (IBAction)zhuceBtnAction:(id)sender {
    RegiestController *regeist = [[RegiestController alloc]init];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:regeist];
}
- (IBAction)forgetPwdBtnAction:(id)sender {
    
    ForgetController *forget = [[ForgetController alloc]init];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:forget];
}



//- (IBAction)protocol:(id)sender {
//    BaseWebViewController *web = [[BaseWebViewController alloc]init];
//    web.title = @"用户注册协议";
//    NSString *url = [YZGAppSetting sharedInstance].appUrl;
//    web.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/portal/page/index/id/2",url]];
//    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:web];
//}


@end

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
@interface LoginController ()

//@property (weak, nonatomic) IBOutlet UIView *thirdButtonView;
@property (weak, nonatomic) IBOutlet UILabel *selectLoginType;

//@property (weak, nonatomic) IBOutlet BaseButton *weChat;
//@property (weak, nonatomic) IBOutlet BaseButton *QQ;
//@property (weak, nonatomic) IBOutlet BaseButton *sina;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;

@property (nonatomic , copy) void(^successLogin)(void);

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
    
    [_protocolButton setTitle:[NSString stringWithFormat:@"《%@注册协议》",[YZGAppSetting sharedInstance].appName] forState:UIControlStateNormal];
    [_protocolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"手机号登陆/注册"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_phone setAttributedTitle:str forState:UIControlStateNormal];
    
    //logo
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2.0-60, 100, 120, 120)];
    imageView.layer.cornerRadius = 30;
    [imageView.layer masksToBounds];
    imageView.clipsToBounds = YES;//切图
    imageView.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:imageView];
    
    //第三方登录
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight-250, KScreenWidth, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择第三方登录方式";
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    //1/6  2/9
    NSArray *titles = @[@"组-iconfont-weixin",@"组-iconfont-QQ"];
    float kBtnw = (KScreenWidth*2/9.0);
    for (int i=0; i<titles.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2.0-kBtnw+kBtnw*i,KScreenHeight- 200, kBtnw, 60)];
        [button setImage:[UIImage imageNamed:titles[i]] forState:0];
        [self.view addSubview:button];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(isThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}


- (void)isThirdLogin:(UIButton *)sender
{
    
//    if (sender.tag==1001) {
//        [AlertTool ShowErrorInView:self.view withTitle:@"功能开发中，敬请期待"];
//        return;
//    }
//    
    
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    [YZGShare loginWithPlatformType:sender.tag-998 success:^(id responseObj, BOOL successGetInfo){
        if (successGetInfo){
            [YZGShare sendOauthUserInfoWithParam:responseObj success:^(id response, BOOL successGetInfo) {
                if (successGetInfo) {
                    [AlertTool Hidden];
                    self.successLogin();
                }else{
                    [AlertTool ShowErrorInView:self.view withTitle:response];
                }
            }];
        }else{
            [AlertTool ShowErrorInView:self.view withTitle:responseObj];
        }
    }];

    
}


- (IBAction)phone:(id)sender {
    PhoneLoginController *phoneLogin = [[PhoneLoginController alloc] initWithSuccessLogin:self.successLogin];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:phoneLogin];
}

- (IBAction)protocol:(id)sender {
    BaseWebViewController *web = [[BaseWebViewController alloc]init];
    web.title = @"用户注册协议";
    NSString *url = [YZGAppSetting sharedInstance].appUrl;
    web.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/portal/page/index/id/2",url]];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:web];
}

- (IBAction)thirdLogin:(UIButton *)sender {
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    [YZGShare loginWithPlatformType:sender.tag success:^(id responseObj, BOOL successGetInfo){
        if (successGetInfo){
            [YZGShare sendOauthUserInfoWithParam:responseObj success:^(id response, BOOL successGetInfo) {
                if (successGetInfo) {
                    [AlertTool Hidden];
                    self.successLogin();
                }else{
                    [AlertTool ShowErrorInView:self.view withTitle:response];
                }
            }];
        }else{
            [AlertTool ShowErrorInView:self.view withTitle:responseObj];
        }
    }];
}

@end

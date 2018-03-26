//
//  PhoneLoginController.m
//  sisitv_ios
//
//  Created by winterfeel on 2016/12/16.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "PhoneLoginController.h"
#import "RegiestController.h"
#import "ForgetController.h"
#import "Account.h"
#import "RootTool.h"
#import "YZGShare.h"
#import "AlertTool.h"


@interface PhoneLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnForget;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic , copy) void(^successLogin)(void);

@end

@implementation PhoneLoginController

-(instancetype)initWithSuccessLogin:(void (^)(void))successLogin{
    if (self = [super init]) {
        self.successLogin = successLogin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView{

    self.navigationItem.title = @"手机号登陆";
    [self viewSetAtt:self.txtPhone withImageName:@"手机号" placeholderString:@"请输入手机号" color:[UIColor lightGrayColor] font:13];
    [self viewSetAtt:self.txtPsw withImageName:@"验证码" placeholderString:@"请输入密码" color:[UIColor lightGrayColor] font:13];
    
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.backgroundColor = [UIColor darkGrayColor];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码?"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_btnForget setAttributedTitle:str forState:UIControlStateNormal];
    
    NSMutableAttributedString *str2= [[NSMutableAttributedString alloc] initWithString:@"立即注册"];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:strRange2];
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    [_btnRegister setAttributedTitle:str2 forState:UIControlStateNormal];
}


-(void)viewSetAtt:(UIView *)view withImageName:(NSString *)name placeholderString:(NSString *)placeholder color:(UIColor *)color font:(CGFloat )font{
    UIFont  *textFont = [UIFont systemFontOfSize:font];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0;
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textFiled = (UITextField *)view;
        [self textFiledSetLeftView:textFiled withImageName:name placeholderString:placeholder color:color font:textFont];
    }
}
-(void)textFiledSetLeftView:(UITextField *)textFiled withImageName:(NSString *)name placeholderString:(NSString *)placeholder color:(UIColor *)color font:(UIFont *)textFont{
    textFiled.attributedPlaceholder  = [[NSAttributedString alloc]initWithString:placeholder attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:color}];
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    imagView.contentMode = UIViewContentModeCenter;
    imagView.width += 38;
    textFiled.leftView = imagView;
}


- (IBAction)forget:(id)sender {
    
    ForgetController *forget = [[ForgetController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
    
}

- (IBAction)phoneRegister:(id)sender {
    
    RegiestController *regeist = [[RegiestController alloc]init];
    [self.navigationController pushViewController:regeist animated:YES];
    
}


- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    
    [AlertTool ShowInView:self.view withTitle:@"正在登录"];
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.txtPhone.text;
    param.password = self.txtPsw.text;
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

@end

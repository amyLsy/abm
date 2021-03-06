//
//  RegiestController.m
//  liveFrame
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegiestController.h"
#import "BaseWebViewController.h"
#import "Account.h"
#import "YZGAppSetting.h"
#import "AlertTool.h"


@interface RegiestController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneToRight;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passTextFlied;
@property (weak, nonatomic) IBOutlet UIView *varCodeView;
@property (weak, nonatomic) IBOutlet UITextField *varcode;
@property (weak, nonatomic) IBOutlet UILabel *varCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *InviteCodeTextField;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) int time;


@property (weak, nonatomic) IBOutlet UIButton *regeistButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeProtocolButton;
@property (weak, nonatomic) IBOutlet UIButton *protocalButton;
@property (weak, nonatomic) IBOutlet UIView *sepView;

@end

@implementation RegiestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.regeistButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    
    UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(varCodeLabelClick)];
    [self.varCodeLabel addGestureRecognizer:tagGesture];
    [self setLayOut];
    self.navigationItem.title = @"注册";
    [self viewSetAtt:self.phoneTextFiled withImageName:@"login_user" placeholderString:@"请输入手机号" color:[UIColor lightGrayColor] font:13];
    [self textFiledSetLeftView:self.varcode withImageName:@"registration_captcha" placeholderString:@"请输入验证码" color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
    [self viewSetAtt:self.passTextFlied withImageName:@"registration_password" placeholderString:@"请设置密码" color:[UIColor lightGrayColor] font:13];
    [self viewSetAtt:self.againPwdTextField withImageName:@"registration_password" placeholderString:@"请确认密码" color:[UIColor lightGrayColor] font:13];
      [self viewSetAtt:self.InviteCodeTextField withImageName:@"registration_invitation" placeholderString:@"填写邀请码(可选)" color:[UIColor lightGrayColor] font:13];
    [self viewSetAtt:self.varCodeView withImageName:nil placeholderString:nil color:[UIColor lightGrayColor] font:13];
    self.agreeProtocolButton.selected = YES;
    [YZGAppSetting sharedInstance].isAutoUpSpring = YES;

}
- (IBAction)backBtnAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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


-(void)setLayOut{
    self.phoneHeight.constant = self.phoneHeight.constant *KHeightScale;
    self.phoneToLeft.constant = self.phoneToLeft.constant *KWidthScale;
    self.phoneToRight.constant = self.phoneToRight.constant *KWidthScale;
//    self.regeistButton.layer.cornerRadius = 5;
    self.varCodeLabel.layer.cornerRadius = 5;
    self.varCodeLabel.layer.masksToBounds = YES;
}

- (IBAction)backToPre {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreeProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)protocolClick {
    BaseWebViewController *web = [[BaseWebViewController alloc]init];
    web.title = @"用户注册协议";
    NSString *url = [YZGAppSetting sharedInstance].appUrl;
    web.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/portal/page/index/id/2",url]];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:web];
}

- (IBAction)regeist:(UIButton *)sender
{
//    if (!self.agreeProtocolButton.isSelected) {
//        [AlertTool ShowInView:self.view onlyWithTitle:@"请同意用户注册协议" hiddenAfter:1.0];
//        return;
//    }
    if (self.passTextFlied.text.length == 0) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"别忘了填写密码哦~" hiddenAfter:1.0];
        return;
    }
    if (![self.passTextFlied.text isEqualToString:self.againPwdTextField.text]) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"两次输入的密码不一致哦~" hiddenAfter:1.0];
        return;
    }
    if (self.varcode.text.length == 0) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"别忘了填写验证码哦~" hiddenAfter:1.0];
        return;
    }
    
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.phoneTextFiled.text;
    param.password = self.passTextFlied.text;
    param.repassword = self.passTextFlied.text;
    param.varcode  = self.varcode.text;
    param.uid = self.InviteCodeTextField.text;

    [AlertTool ShowInView:self.view withTitle:@"正在注册..."];
    KWeakSelf;
    [[Account shareInstance] regeistWithParam:param success:^(BOOL successGetInfo,id responseObj){
        if (!successGetInfo) {
            [AlertTool ShowInView:ws.view onlyWithTitle:responseObj hiddenAfter:1.0];
        }else{
            [AlertTool ShowInView:KKeyWindow onlyWithTitle:@"注册成功,请登录使用!" hiddenAfter:1.0];
            //
            [Account shareInstance].token = responseObj[@"token"];
            [Account firstRegister];
            
            [ws.navigationController popViewControllerAnimated:YES];
        }
    }];
}





-(void)varCodeLabelClick
{
    if (!self.phoneTextFiled.text.length) {
        [AlertTool ShowErrorInView:self.view withTitle:@"请先输入手机号"];
        return;
    }
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.phoneTextFiled.text;
    KWeakSelf;
    [AlertTool ShowInView:self.view];
    [[Account shareInstance] getVarcodeWithParam:param success:^(BOOL successGetInfo,id responseObj){
        if (!successGetInfo) {
            [AlertTool ShowErrorInView:ws.view withTitle:responseObj];
        }else{
            [AlertTool Hidden];
             [ws initTimer];
        }
    }];
}


-(void)updateLabelText
{
    self.time = self.time -1;
    self.varCodeLabel.text = [NSString stringWithFormat:@"请等待%d秒",self.time];
    if (self.time ==0)
    {
        [self resetTimer];
    }
}


-(void)initTimer{
    self.time = 60;
    self.varCodeLabel.userInteractionEnabled = NO;
    self.timer =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop ]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

-(void)resetTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.varCodeLabel.userInteractionEnabled = YES;
    self.varCodeLabel.text = @"获取验证码";
}


-(void)dealloc{
    [YZGAppSetting sharedInstance].isAutoUpSpring = NO;
}
@end

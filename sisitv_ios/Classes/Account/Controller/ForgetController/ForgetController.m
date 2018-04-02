//
//  ForgetController.m
//  liveFrame
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ForgetController.h"
#import "Account.h"
#import "AlertTool.h"
#import "YZGAppSetting.h"
@interface ForgetController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneToRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *varCodeView;
@property (weak, nonatomic) IBOutlet UITextField *varCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UILabel *varCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) int time;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIView *sepView;


@end

@implementation ForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(varCodeLabelClick)];
    [self.varCodeLabel addGestureRecognizer:tagGesture];
    [self setLayOut];
    self.navigationItem.title = @"忘记密码";
    [self viewSetAtt:self.phoneNumber withImageName:@"login_user" placeholderString:@"请输入手机号" color:[UIColor lightGrayColor] font:13];
    [self textFiledSetLeftView:self.varCode withImageName:@"registration_captcha" placeholderString:@"请输入验证码" color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
    [self viewSetAtt:self.password withImageName:@"registration_password" placeholderString:@"请输入新密码" color:[UIColor lightGrayColor] font:13];
    [self viewSetAtt:self.rePassword withImageName:@"registration_password" placeholderString:@"请确认新密码" color:[UIColor lightGrayColor] font:13];
    [self viewSetAtt:self.varCodeView withImageName:nil placeholderString:nil color:[UIColor whiteColor] font:13];

    [YZGAppSetting sharedInstance].isAutoUpSpring = YES;
}


-(void)viewSetAtt:(UIView *)view withImageName:(NSString *)name placeholderString:(NSString *)placeholder color:(UIColor *)color font:(CGFloat )font{
    UIFont  *textFont = [UIFont systemFontOfSize:font];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
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
//    self.confirmButton.layer.cornerRadius = 5;
    self.varCodeLabel.layer.cornerRadius = 5;
    self.varCodeLabel.layer.masksToBounds = YES;
}

-(void)varCodeLabelClick
{
    if (!self.phoneNumber.text.length) {
        [AlertTool ShowErrorInView:self.view withTitle:@"请先输入手机号"];
        return;
    }
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.phoneNumber.text;
    param.status = @"forgetPassword0";
    [[Account shareInstance] getVarcodeWithParam:param success:^(BOOL successGetInfo,id responseObj){
         if (!successGetInfo) {
             [AlertTool ShowErrorInView:self.view withTitle:responseObj];
         }else{
             [self initTimer];
         }
     }];
}


- (IBAction)confirmButtonClick {
    
    if (self.password.text.length == 0) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"别忘了填写密码哦~" hiddenAfter:1.0];
        return;
    }
    if (![self.password.text isEqualToString:self.rePassword.text]) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"两次输入的密码不一致哦~" hiddenAfter:1.0];
        return;
    }
    if (self.varCode.text.length == 0) {
        [AlertTool ShowInView:self.view onlyWithTitle:@"别忘了填写验证码哦~" hiddenAfter:1.0];
        return;
    }
    
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = self.phoneNumber.text;
    param.password = self.password.text;
    param.repassword = self.rePassword.text;
    param.varcode  = self.varCode.text;
    
    [AlertTool ShowInView:self.view withTitle:@"正在重设密码..."];
    KWeakSelf;
    [[Account shareInstance] forgetPasswordWithParam:param success:^(BOOL successGetInfo, id responseObj) {
        if (!successGetInfo) {
            [AlertTool ShowErrorInView:self.view withTitle:responseObj];
        }else{
            [AlertTool ShowInView:KKeyWindow onlyWithTitle:@"密码设置成功!" hiddenAfter:1.0];
            [ws.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)initTimer{
    self.time = 60;
    self.varCodeLabel.userInteractionEnabled = NO;
    self.timer =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop ]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
    
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

-(void)resetTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.varCodeLabel.userInteractionEnabled = YES;
    self.varCodeLabel.text = @"获取验证码";
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (UIView *view  in self.view.subviews) {
        [view removeFromSuperview];
    }
    [YZGAppSetting sharedInstance].isAutoUpSpring = NO;
}
 
@end

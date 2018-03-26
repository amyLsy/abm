//
//  PhoneBindingController.m
//  xiuPai
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "PhoneBindingController.h"
#import "AlertTool.h"
#import "Account.h"
@interface PhoneBindingController ()
@property (weak, nonatomic) IBOutlet UIView *bindedView;
@property (weak, nonatomic) IBOutlet UIButton *bindedButton;
@property (weak, nonatomic) IBOutlet UITextField *bindedPhone;
@property (weak, nonatomic) IBOutlet UITextField *bindedNewPhone;
@property (weak, nonatomic) IBOutlet UITextField *bindedVarCode;
@property (weak, nonatomic) IBOutlet UILabel *bindedGetVarCode;

@property (weak, nonatomic) IBOutlet UIView *notBindedView;
@property (weak, nonatomic) IBOutlet UIButton *notBindedButton;
@property (weak, nonatomic) IBOutlet UITextField *notBindedPhone;
@property (weak, nonatomic) IBOutlet UITextField *notBindedVarCode;
@property (weak, nonatomic) IBOutlet UILabel *notBindedGetVarCode;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) int time;
@end

@implementation PhoneBindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self chuShiHua];
    self.bindedButton.backgroundColor = [UIColor darkGrayColor];
    self.bindedGetVarCode.textColor = [UIColor darkGrayColor];
}

-(void)chuShiHua{
    self.bindedView.hidden = YES;
    self.notBindedView.hidden = YES;
    if ([self.bindingStatus isEqualToString:@"已绑定"]) {
        self.bindedView.hidden = NO;
        self.navigationItem.title = @"更换绑定";
        [self roundVarCode:self.bindedGetVarCode];
        [self roundVarCode:self.bindedButton];
    }else{
        self.notBindedView.hidden = NO;
        self.navigationItem.title = @"手机号绑定";
        [self roundVarCode:self.notBindedGetVarCode];
        [self roundVarCode:self.notBindedButton];
    }
}

-(void)roundVarCode:(UIView *)view{
    if ([view isKindOfClass:[UILabel class]]) {
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(varCodeLabelTaped)];
        [view addGestureRecognizer:tagGesture];
    }
    [view layoutIfNeeded];
    view.layer.cornerRadius = view.height/2.0;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    view.layer.borderWidth = 1.0;
}

- (IBAction)bindedButtonClick {
    [self beginBindedWithParam:[self configParam]];
}

- (IBAction)notBindedButtonClick {
    [self beginBindedWithParam:[self configParam]];
}


-(void)beginBindedWithParam:(AccountParam *)param{
    [AlertTool showWithCustomModeInView:self.view];
    KWeakSelf;
    [[Account shareInstance] bindingMobileWithParam:param success:^(BOOL successGetInfo,id responseObj){
            [AlertTool ShowInView:ws.view onlyWithTitle:responseObj hiddenAfter:1.0];
    }];
}

-(AccountParam *)configParam{
    AccountParam *param = [[AccountParam alloc]init];
    if ([self.bindingStatus isEqualToString:@"已绑定"]) {
        param.old_mobile_num = self.bindedPhone.text;
        param.mobile_num = self.bindedNewPhone.text;
        param.varcode  = self.bindedVarCode.text;
    }else{
        param.mobile_num = self.notBindedPhone.text;
        param.varcode  = self.notBindedVarCode.text;
    }
    return param;
}

-(void)varCodeLabelTaped
{
    NSString *phone ;
    if ([self.bindingStatus isEqualToString:@"已绑定"]) {
        if (self.bindedPhone.text.length < 10 || self.bindedNewPhone.text.length<10 || [self.bindedPhone.text isEqualToString:self.bindedNewPhone.text]) {
            return;
        }else{
            phone = self.bindedNewPhone.text;
        }
     }else{
         if (self.notBindedPhone.text.length < 10 ) {
             return;
         }else{
             phone = self.notBindedPhone.text;
         }
     }
    AccountParam *param = [[AccountParam alloc]init];
    param.mobile_num = phone;
    param.status = @"binding0";
    KWeakSelf;
    [[Account shareInstance] getVarcodeWithParam:param success:^(BOOL successGetInfo,id responseObj){
        if (successGetInfo)
        {
            [ws initTimer];
        }else{
            [AlertTool ShowErrorInView:ws.view withTitle:responseObj];
        }
    }];
}


-(void)updateLabelText
{
    self.time = self.time -1;
    self.bindedGetVarCode.text = [NSString stringWithFormat:@"请等待%d秒",self.time];
    self.notBindedGetVarCode.text = [NSString stringWithFormat:@"请等待%d秒",self.time];
    if (self.time ==0)
    {
        [self resetTimer];
    }
}


-(void)initTimer{
    self.time = 60;
    self.notBindedGetVarCode.userInteractionEnabled = NO;
    self.bindedGetVarCode.userInteractionEnabled = NO;
    self.timer =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop ]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

-(void)resetTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.bindedGetVarCode.userInteractionEnabled = YES;
    self.notBindedGetVarCode.userInteractionEnabled = YES;
    self.bindedGetVarCode.text = @"获取验证码";
    self.notBindedGetVarCode.text = @"获取验证码";
}

@end

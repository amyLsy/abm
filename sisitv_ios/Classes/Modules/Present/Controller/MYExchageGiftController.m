//
//  MYExchageGiftController.m
//  sisitv_ios
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "MYExchageGiftController.h"
#import "AlertTool.h"
#import "HttpTool.h"
#import "Account.h"

@interface MYExchageGiftController ()
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberLabel;

@end

@implementation MYExchageGiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)exchangeAtion:(id)sender {
    
    
    if (!self.addressLabel.text.length || !self.phoneNumberLabel.text.length) {
        
        [AlertTool ShowErrorInView:self.view withTitle:@"选项不能为空"];
        return;
    }
    if (self.phoneNumberLabel.text.length != 11) {
        
        [AlertTool ShowErrorInView:self.view withTitle:@"请填写正确的手机号码"];

        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"present_id"] = _model.id;
    param[@"exchange_type"] = @(2);
    param[@"token"] = [Account shareInstance].token;
    param[@"address"] = self.addressLabel.text;
    param[@"mobile"] = self.phoneNumberLabel.text;
    [AlertTool ShowInView:self.view];
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagPresentExchange param:param success:^(id responseObject) {
        [AlertTool Hidden];
        if ([responseObject[@"code"] integerValue] == 200) {
            [AlertTool ShowInView:self.view onlyWithTitle:@"兑换成功" hiddenAfter:1];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
        }
        
        
    } faile:^{
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

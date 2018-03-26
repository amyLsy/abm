//
//  UpdateView.m
//  sisitv
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 JLXX-YZG. All rights reserved.
//

#import "UpdateView.h"
@interface UpdateView ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation UpdateView
+(instancetype)updateView{
    UpdateView *updateView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    updateView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    updateView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    updateView.updateButton.backgroundColor = kNavColor;
    updateView.updateButton.layer.cornerRadius = updateView.updateButton.height/2.0;
    updateView.cancelButton.layer.cornerRadius = updateView.updateButton.height/2.0;
    return  updateView;
}

-(void)setUpdateInfo:(NSDictionary *)updateInfo{
    _updateInfo = updateInfo;
//    self.infoLabel.text = [NSString stringWithFormat:@"发现新版本:%@ \n %@",_updateInfo[@"ver_num"],_updateInfo[@"description"]];
}
- (IBAction)update {
    [self close];
    NSString *url = self.updateInfo[@"package_url"];
    if (kYZGiOS10OrLater) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:nil];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#pragma clang diagnostic pop
    }
}

- (IBAction)close {
    [self removeFromSuperview];
}

@end

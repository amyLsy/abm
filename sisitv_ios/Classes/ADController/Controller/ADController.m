//
//  OAuthViewController.m
//  Zhibo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ADController.h"
#import "BaseWebViewController.h"
#import "ADItem.h"
@interface ADController ()

@property (nonatomic , weak)  IBOutlet UIImageView *backGroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property (nonatomic , assign) BOOL backFromAdWebController;

@property (nonatomic , assign) NSTimeInterval timeInterval;

@property (nonatomic , copy) void(^disappearHandler)(void);

@end

@implementation ADController

-(instancetype)initWithTimeInterval:(NSTimeInterval)ti disappearHandler:(void (^)(void))disappearHandler{
    if (self = [super init]) {
        self.timeInterval = ti;
        self.disappearHandler = disappearHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backGroundImageView.image = self.adItem.adImage;
    [self performSelector:@selector(adControllerDisappear) withObject:nil afterDelay:self.timeInterval];
}

- (IBAction)ADImageViewTap:(UITapGestureRecognizer *)sender {
    if (![self.adItem.url hasPrefix:@"http"]) return;
    self.backFromAdWebController = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adControllerDisappear) object:nil];
    BaseWebViewController *ad = [[BaseWebViewController alloc]init];
    ad.title = @"广告";
    ad.url = [NSURL URLWithString:self.adItem.url];
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:ad];
}

- (IBAction)jumpClick {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adControllerDisappear) object:nil];
    [self adControllerDisappear];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.backFromAdWebController) {
        [self adControllerDisappear];
    }
}

-(void)adControllerDisappear
{
    self.disappearHandler();
}

@end




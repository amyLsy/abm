//
//  YZGEntranceAnimationView.m
//  一道金光
//
//  Created by apple on 17/2/14.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGEntranceAnimationView.h"
#import "ChatMessage.h"

@interface YZGradientView :UIView<CAAnimationDelegate>

@property (nonatomic , strong) UILabel *userName;

@property (nonatomic , strong) UIButton *userLevel;
/**
 进场动画结束回调
 */
@property (nonatomic , copy) void(^gradientAnimationEnd)(void);

@property (nonatomic , strong) UIView *light;

@property (nonatomic , strong) ChatMessage *chatMessage;
@end

@implementation YZGradientView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.light = [[UIView alloc]init];
    self.userName = [[UILabel alloc]init];
    self.userLevel = [[UIButton alloc]init];
    [self addSubview:self.light];
    [self addSubview:self.userLevel];
    [self addSubview:self.userName];
    
    
    [self.userLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 13));
        make.left.equalTo(self.mas_left).offset(10);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.userLevel.mas_right).offset(5);
        make.height.mas_equalTo(13);
    }];
    [self.light mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(5);
    }];
    
    self.userLevel.titleLabel.font = [UIFont systemFontOfSize:12];
    self.userName.font = [UIFont systemFontOfSize:12];
    self.userName.textColor = [UIColor whiteColor];
    
}
-(void)startAnimateWithChatMessage:(ChatMessage *)chatMessage{
    self.chatMessage = chatMessage;
    
    self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame  = CGRectMake(0, 0, 250, self.bounds.size.height);
    self.layer.mask = colorLayer;
    // 颜色分配
    CGColorRef innerColor = [UIColor greenColor].CGColor;
    CGColorRef endColor = [UIColor colorWithWhite:0.9 alpha:0.0].CGColor;
    colorLayer.colors = @[(__bridge id) innerColor,
                          (__bridge id) endColor];        // 颜色分割线
    colorLayer.locations  = @[@(0.6), @(1.0)];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint   = CGPointMake(1, 0);
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, 0, 250, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self addAnimationChatMessage:chatMessage];
    }];
}

- (void)addAnimationChatMessage:(ChatMessage *)chatMessage
{
    [self.userLevel setImage:[UIImage imageNamed:chatMessage.userLevelImageName] forState:UIControlStateNormal];
    self.userLevel.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.userLevel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.userLevel setTitle:chatMessage.localProcessedUserLevel forState:UIControlStateNormal];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0)];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.duration = 1;
    //    animation.cumulative = YES;
    //    animation.repeatCount = 1;
    __weak typeof(self) weakSelf = self;
    animation.delegate = weakSelf;
    [self.userLevel.layer addAnimation:animation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([anim isKindOfClass:[CABasicAnimation class]]){
        CABasicAnimation *animation =  (CABasicAnimation *)anim;
        if([animation.keyPath isEqualToString:@"transform"]){
            [self weiziYidongWithChatMessage:self.chatMessage];
        }else if ([animation.keyPath isEqualToString:@"position"]) {
            [self removeFromSuperview];
            self.gradientAnimationEnd();
        }
    }
}

-(void)weiziYidongWithChatMessage:(ChatMessage *)chatMessage{
    self.userName.text = chatMessage.content;
    [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(250);
    }];
    [UIView animateWithDuration:1.0 animations:^{
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self jinguang];
    }];
}
-(void)jinguang{
    self.light.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, self.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, self.center.y)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.duration = 0.5;
    animation.repeatCount = 2;
    __weak typeof(self) weakSelf = self;
    animation.delegate = weakSelf;
    [self.light.layer addAnimation:animation forKey:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)dealloc{
    NSLog(@"%@",self);
}

@end

@interface YZGEntranceAnimationView ()

@property (nonatomic , assign) BOOL isAnimationing;

///礼物总数组
@property (nonatomic , strong) NSMutableArray *allChatMessage;

@end

@implementation YZGEntranceAnimationView

-(instancetype)init{
    if (self =[super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.allChatMessage = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"allChatMessage" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)showEntranceAnimationForMessage:(ChatMessage *)chatMessage{
    [[self mutableArrayValueForKey:@"allChatMessage"] addObject:chatMessage];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"allChatMessage"]){
        ChatMessage *chatMessage = [self.allChatMessage firstObject];
        if (chatMessage) {
            [self excutingWithChatMessage:chatMessage];
        }else{
            [self removeFromSuperview];
        }
    }
}

-(void)excutingWithChatMessage:(ChatMessage *)chatMessage{
    if (self.isAnimationing) return;
    YZGradientView *gradientView = [[YZGradientView alloc]initWithFrame:CGRectMake(0, 0,0, self.bounds.size.height)];
    [self addSubview:gradientView];
    self.isAnimationing = YES;
    [gradientView startAnimateWithChatMessage:chatMessage];
    __weak typeof(self) ws = self;
    gradientView.gradientAnimationEnd = ^(){
        [ws animationImageViewStopAnimating:chatMessage];
    };
}
-(void)animationImageViewStopAnimating:(ChatMessage *)chatMessage{
    self.isAnimationing = NO;
    [[self mutableArrayValueForKey:@"allChatMessage"] removeObject:chatMessage];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"allChatMessage"];
    NSLog(@"%@",self);
}

@end

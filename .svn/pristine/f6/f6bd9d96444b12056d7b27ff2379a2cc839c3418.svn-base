//
//  GiftAnimationView.m
//  liveFrame
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YZGNormalGiftView.h"
#import "GiftCache.h"
#import "ChatMessage.h"
#import "UIImageView+Rouding.h"

static CGFloat const kAnimationViewWidth = 250 ;

static NSTimeInterval const animatonViewShowOrHidden = 4.0;

static NSTimeInterval const animatonTime = 0.6;


@class YZGAnimationView;

@protocol YZGAnimationViewDeleagte <NSObject>

-(void)didEndAnimationWithAnimationView:(YZGAnimationView *)animationView;

-(void)endShowingChatMessage:(ChatMessage *)chatMessage;

@end

@interface YZGAnimationView : UIView

@property (nonatomic , assign) BOOL isAtBottom;


@property (nonatomic , weak) id<YZGAnimationViewDeleagte> delegate;

@property (nonatomic , strong) ChatMessage *chatMessage;

@property (nonatomic , copy) NSString *continuousIdentifier;

@property (nonatomic,copy) NSString *animationCount; // 动画执行到了第几次

@property (nonatomic,strong) UIImageView *senderAvatar; // 送礼物者头像
@property (nonatomic,strong) UILabel *senderName; // 送礼物者名字
@property (nonatomic,strong) UIImageView *giftAvatar; // 礼物图片
@property (nonatomic,strong) UILabel *giftName; // 礼物的名称
@property (nonatomic,strong) UILabel *animationLabel;

@property (nonatomic , strong) NSTimer *removeTimer;

@end

@implementation YZGAnimationView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _animationCount = @"0";
        [self setUI];
    }
    return self;
}

-(void)dealloc{
    printf("YZGAnimationView dealloc\n");
}

-(void)setChatMessage:(ChatMessage *)chatMessage
{
    _chatMessage = chatMessage;
    [_senderAvatar sd_setImageWithURL:[NSURL URLWithString:_chatMessage.avatar]];
    _senderName.text = _chatMessage.userName;
    [_giftAvatar sd_setImageWithURL:[NSURL URLWithString:_chatMessage.other.giftInfo.gifticon]];
    _giftName.text = [NSString stringWithFormat:@"给主播送了%@",_chatMessage.other.giftInfo.giftname];
}

-(void)setAnimationCount:(NSString *)animationCount{
    _animationCount = [animationCount copy];
    if ([_animationCount integerValue] != 0) {
        
        [self.removeTimer invalidate];
        self.removeTimer = nil;
        
        self.animationLabel.text = [NSString stringWithFormat:@"X %ld",_animationCount.integerValue];
        [self startAnimWithDuration:animatonTime];
    }else{
        [self.delegate endShowingChatMessage:self.chatMessage];
        self.removeTimer = [NSTimer scheduledTimerWithTimeInterval:animatonViewShowOrHidden target:self selector:@selector(endAnimation) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.removeTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)startAnimWithDuration:(NSTimeInterval)duration
{
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.0 animations:^{
            self.animationLabel.transform = CGAffineTransformMakeScale(3, 3);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:duration/2.0 animations:^{
            self.animationLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:duration/2.0 relativeDuration:duration/2.0 animations:^{
            self.animationLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        self.animationCount = @"0";
    }];
}

-(void)endAnimation
{
    [self.delegate didEndAnimationWithAnimationView:self];
    [self.delegate endShowingChatMessage:self.chatMessage];
    _senderAvatar.image = nil;
    _giftAvatar.image = nil;
    _senderName.text = nil;
    _giftName.text = nil;
    _continuousIdentifier = nil;
    self.chatMessage = nil;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat avatarHeight = height- 4.0;
    CGFloat avatarWidth = avatarHeight;
    
    self.layer.cornerRadius = height/2.0;
    
    _senderAvatar.frame = CGRectMake(2.0, 2.0, avatarWidth,avatarHeight);
    _senderAvatar.layer.cornerRadius = avatarHeight/2.0;
    _senderAvatar.layer.masksToBounds = YES;
    _giftAvatar.frame = CGRectMake(width - 50, height - 50, 50, 50);
    _senderName.frame = CGRectMake(avatarWidth + 5, 5, avatarWidth * 3, 10);
    _giftName.frame = CGRectMake(_senderName.frame.origin.x, CGRectGetMaxY(_senderAvatar.frame) - 10 - 5, _senderName.frame.size.width, 10);
    _animationLabel.frame = CGRectMake(CGRectGetMaxX(self.frame) + 5,-10, 50, 40);
}

#pragma mark 初始化 UI
- (void)setUI {
    
    _senderAvatar= [[UIImageView alloc] init];
    _giftAvatar = [[UIImageView alloc] init];
    _senderName = [[UILabel alloc] init];
    _senderName.textColor  = RGB_COLOR(245, 253, 55, 1.0);
    _senderName.font = [UIFont systemFontOfSize:13];
    _giftName = [[UILabel alloc] init];
    _giftName.textColor  = [UIColor whiteColor];
    _giftName.font = [UIFont systemFontOfSize:13];
    // 初始化动画label
    _animationLabel =  [[UILabel alloc] init];
    _animationLabel.font = [UIFont systemFontOfSize:17];
    _animationLabel.textColor = RGB_COLOR(245, 253, 55, 1.0);
    _animationLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_senderAvatar];
    [self addSubview:_giftAvatar];
    [self addSubview:_senderName];
    [self addSubview:_giftName];
    [self addSubview:_animationLabel];
}


@end


@interface YZGNormalGiftView()<YZGAnimationViewDeleagte>

///所有未显示礼物数组
@property (nonatomic , strong) NSMutableArray *allCacheGiftMessage;
///当前正在正展示且支持连送的animationView字典
@property (nonatomic , strong) NSMutableDictionary *visiableAnimationView;

/** 礼物缓存:缓存送过礼物的人的id,判断是否动画显示连送 */
@property (nonatomic , strong) GiftCache *giftCache;



@end

@implementation YZGNormalGiftView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.allCacheGiftMessage = [NSMutableArray array];
        self.visiableAnimationView = [NSMutableDictionary dictionary];
        
        self.giftCache = [GiftCache sharedInstance];
    }
    return self;
}

-(void)showNormalAnimationForMessage:(ChatMessage *)chatMessage{
    [self showNormalAnimationForMessage:chatMessage isCacheMessage:NO];
}
-(void)showNormalAnimationForMessage:(ChatMessage *)chatMessage isCacheMessage:(BOOL)isCache{
    
    if (!chatMessage || ![chatMessage isKindOfClass:[ChatMessage class]]) return;
    
    NSString *continuousIdentifier = chatMessage.other.giftInfo.continuousIdentifier;
    YZGAnimationView  *animationView = nil;
    if (continuousIdentifier) {
        //若是连送消息
        animationView = [self visibleAnimationViewForIdentifier:continuousIdentifier];
    }else{
        continuousIdentifier = [NSString stringWithFormat:@"%@%lf",chatMessage.other.giftInfo.giftid,[[NSDate date] timeIntervalSince1970]];
        animationView = [self visibleAnimationViewForIdentifier:continuousIdentifier];
    }
    //先看看这个消息有没有正在显示
    if (animationView) {
        //若正在显示,则改变显示的数字
        [self excuteAnimationWithChatMessage:chatMessage withAnimationView:animationView withContinuousIdentifier:continuousIdentifier];
    }else{
        [self whetherOrNotImmediatelyDisplayedChatMessage:chatMessage continuousIdentifier:continuousIdentifier isCacheMessage:isCache];
    }
}
//是否立刻显示这个消息
-(void)whetherOrNotImmediatelyDisplayedChatMessage:(ChatMessage *)chatMessage continuousIdentifier:(NSString *)continuousIdentifier isCacheMessage:(BOOL)isCache{
    if (self.visiableAnimationView.count < 2){
        [self startShowChatMessage:chatMessage continuousIdentifier:continuousIdentifier];
    }else if(!isCache){
        [self.allCacheGiftMessage addObject:chatMessage];
    }
}

/**
 把动画view展示到屏幕上,并准备执行动画
 
 @param chatMessage 礼物消息
 @param continuousIdentifier 连送礼物标识符
 */
-(void)startShowChatMessage:(ChatMessage *)chatMessage continuousIdentifier:(NSString *) continuousIdentifier{
    
    if ([continuousIdentifier isKindOfClass:[NSString class]]) {
        YZGAnimationView  *animationView = [self createAnimationView];
        
        [self.visiableAnimationView setObject:animationView forKey:continuousIdentifier];
        [self addSubview:animationView];
        [UIView animateWithDuration:0.5 animations:^{
            animationView.x = 0;
        }completion:^(BOOL finished) {
            [self excuteAnimationWithChatMessage:chatMessage withAnimationView:animationView withContinuousIdentifier:continuousIdentifier];
        }];
    }
}

/**
 动画view开始执行礼物动画
 
 @param chatMessage 礼物消息
 @param animationView 具体的动画view
 @param continuousIdentifier 连送标识符
 */
-(void)excuteAnimationWithChatMessage:(ChatMessage *)chatMessage withAnimationView:(YZGAnimationView *)animationView withContinuousIdentifier:(NSString *)continuousIdentifier{
    if (chatMessage) {
        animationView.chatMessage = chatMessage;
        animationView.continuousIdentifier = continuousIdentifier;
        if (chatMessage.statusType == ChatReceivedMessage){
            animationView.animationCount = chatMessage.other.giftInfo.continuousNum;
        }else{
            [self sendMessage:chatMessage withContinusIdentifer:continuousIdentifier withAnimationView:animationView];
        }
    }
}

-(void)sendMessage: (ChatMessage *)chatMessage withContinusIdentifer:(NSString *)continuousIdentifier withAnimationView:(YZGAnimationView *)animationView{
    if (continuousIdentifier && self.giftCache.lastChatMessageIdentifie && ([self.giftCache.lastChatMessageIdentifie isEqualToString: continuousIdentifier])) {
        [self.giftCache startTimner];
        self.giftCache.countOfGift = [NSString stringWithFormat:@"%d",self.giftCache.countOfGift.intValue + 1];
    }else if(continuousIdentifier){
        [self.giftCache startTimner];
        self.giftCache.lastChatMessageIdentifie = continuousIdentifier;
        self.giftCache.countOfGift = @"1";
    }else{
        [self.giftCache stopTimner];
        self.giftCache.countOfGift = @"1";
    }
    chatMessage.other.giftInfo.continuousNum = self.giftCache.countOfGift;
    animationView.animationCount = self.giftCache.countOfGift;
}


#pragma mark delegate

-(void)endShowingChatMessage:(ChatMessage *)chatMessage{
    if ([self isObject:chatMessage inCollection:self.allCacheGiftMessage]) {
        [self.allCacheGiftMessage removeObject:chatMessage];
    }
    ChatMessage *cacheGiftMessage = self.allCacheGiftMessage.firstObject;
    [self showNormalAnimationForMessage:cacheGiftMessage isCacheMessage:YES];
}

-(void)didEndAnimationWithAnimationView:(YZGAnimationView *)animationView{
    [animationView removeFromSuperview];
    if ([self.visiableAnimationView objectForKey:animationView.continuousIdentifier]) {
        [self.visiableAnimationView removeObjectForKey:animationView.continuousIdentifier];
    }
}

-(BOOL)isObject:(id )obj inCollection:(NSArray *)arr{
    BOOL exists = NO;
    for (id existsObj in arr) {
        if (obj == existsObj) { exists = YES; break; }
    }
    return exists;
}

- (YZGAnimationView *)visibleAnimationViewForIdentifier:(NSString *)identifier{
    if (!identifier) {
        return nil;
    }
    return [self.visiableAnimationView objectForKey:identifier];
}

- (YZGAnimationView *)createAnimationView{
    
    YZGAnimationView *animationView = [[YZGAnimationView alloc] init];
    animationView.delegate = self;

    YZGAnimationView *subView = nil;
    for (YZGAnimationView *subAnimationView in self.subviews) {
        subView = subAnimationView;
    }
    CGFloat height = (self.height-10)/2.0;
    
    //subAnimationView只能有一个,因为最多显示2个animationView,在屏幕上没有显示或者只有显示一个时候才会,走这里创建新的animationView,所以创建的这个animationView,必定和显示animationView的位置不同.
    //这样做,而不是用self.isAtBottom标识创建的这个animationView的位置,是因为,当屏幕上边显示两个animationView
    //当执行animationView的代理方法,从父视图移除时,因为定时器的不准确,可能上边的那一个还没消失,但是下边的那一个已经消失了,此时就会创建新的animationView,这个属性的位置却要在上边,从而产生的覆盖的bug
    if (!subView || !subView.isAtBottom ) {
        animationView.frame = CGRectMake(-kAnimationViewWidth*KWidthScale, 0, kAnimationViewWidth*KWidthScale, height);

        animationView.isAtBottom = YES;

    }else {
        animationView.frame = CGRectMake(-kAnimationViewWidth*KWidthScale, height + 10, kAnimationViewWidth*KWidthScale,height);

        animationView.isAtBottom = NO;

    }
    return animationView;
}

@end

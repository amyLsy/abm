//
//  LGHotCell.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/8.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGHotCell.h"
#import "RoomInfo.h"
#import "YZGAppSetting.h"

@interface LGHotCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarConst;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UIButton *zhibobutton;

@end

@implementation LGHotCell{
    NSTimer *timer;//倒计时
    RoomInfo *roomInfo;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.status.layer.cornerRadius = 3;
    self.status.layer.masksToBounds = YES;
    self.status.layer.borderWidth = 1.0;
    self.status.layer.borderColor = [UIColor colorWithHexString:@"f12a6b"].CGColor;
    
    self.zhibobutton.layer.cornerRadius = 3;
    self.zhibobutton.layer.masksToBounds = YES;
    
    self.avtar.layer.masksToBounds = YES;
    self.avtar.layer.cornerRadius = 20;
//    self.avtar.layer.borderWidth = 1.0;
//    self.avtar.layer.borderColor = [kNavColor CGColor];
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.gimeTimeBgView.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(5,2)];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//
//    maskLayer.frame = self.gimeTimeBgView.bounds;
//
//    maskLayer.path = maskPath.CGPath;
//
//    self.gimeTimeBgView.layer.mask = maskLayer;

    
}

+ (CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    CGFloat widith = [YZGAppSetting sharedInstance].isBig == YES ? KScreenWidth:[YZGAppSetting sharedInstance].hotCellWidth;
    //lsy
    if ([YZGAppSetting sharedInstance].isBig == YES) {
         return CGSizeMake(widith,  widith);
    }else{
        
         return CGSizeMake(widith,  widith);
    }
    
   
    
}


+ (CGSize)collectionView:(UICollectionView *)collectionView headerSizeForSection:(NSInteger)section{

    return CGSizeMake(KScreenWidth, 247);
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath
{
    
    
    //lsy 首页直播推荐cell
    if ([YZGAppSetting sharedInstance].isBig == YES) {
       
        self.headViewHeightCons.constant =  50;
        self.avtar.layer.cornerRadius = self.headViewHeightCons.constant/2;
        self.name.font = [UIFont systemFontOfSize:18];
        self.subTitle.font = [UIFont systemFontOfSize:15];
        self.people.font = [UIFont systemFontOfSize:15];
        self.location.font = [UIFont systemFontOfSize:14];
        self.title.font = [UIFont systemFontOfSize:20];
        self.cityLabel.font = [UIFont systemFontOfSize:18];
        self.levelWidthCons.constant = 30;
        self.levelHeightCons.constant = 15;
        self.level.titleLabel.font = [UIFont systemFontOfSize:10];
        self.locationImageView.image = [UIImage imageNamed:@"定位直播"];
    }else{
            //小图
        self.headViewHeightCons.constant =  40;
        self.avtar.layer.cornerRadius = self.headViewHeightCons.constant/2;
        self.name.font = [UIFont systemFontOfSize:9];
        self.subTitle.font = [UIFont systemFontOfSize:7.5];
        self.people.font = [UIFont systemFontOfSize:7.5];
        self.location.font = [UIFont systemFontOfSize:7];
        self.title.font = [UIFont systemFontOfSize:12];
        self.cityLabel.font = [UIFont systemFontOfSize:10];
        self.levelWidthCons.constant = 30 * 0.5;
        self.levelHeightCons.constant = 15 * 0.5;
        self.level.titleLabel.font = [UIFont systemFontOfSize:5];
        self.locationImageView.image = [UIImage imageNamed:@"location_samll_icon"];
        
    }

    roomInfo = (RoomInfo *)item;
    
    self.cityLabel.text = roomInfo.location;
    self.name.text =  roomInfo.user_nicename  ;
    [self.preImageView sd_setImageWithURL:roomInfo.smeta];
    [self.avtar sd_setImageWithURL:[NSURL URLWithString: roomInfo.avatar ]];
    [self.location setText:roomInfo.location];
//    roomInfo.match_time = @"5";
    if ([roomInfo.match_time integerValue] > 0) {
        
        self.gimeTimeBgView.hidden = NO;
        self.gameTimeLabel.text = [NSString stringWithFormat:@"答题即将开始:%@s",roomInfo.match_time];
        if(!timer){
            timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(time) userInfo:nil repeats:YES];
             [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [timer fire];
        }
        

    }else{
        self.gimeTimeBgView.hidden = YES;
        [timer invalidate];
        timer = nil;
        
    }
    
//    if (roomInfo.term_name.length || roomInfo.type_name.length) {
//        NSString *gameName;
//        self.gimeTimeBgView.hidden = NO;
//        if ([YZGAppSetting sharedInstance].isBig == YES) {
//            
//            gameName = [NSString stringWithFormat:@"比赛中:%@",roomInfo.term_name];
//            
//        }else{
//            
//            gameName = [NSString stringWithFormat:@"比赛中:%@",roomInfo.term_name];
//        }
//        
//        
//        
//        self.gameTimeLabel.text = @"";
//        
//    }else{
//        self.gimeTimeBgView.hidden = YES;
////        self.gameTimeLabel.text = @"";
//    }
    
    
    
    [self.people setText:roomInfo.online_num];
    [self.people setTextColor:kNavColor];
    
    [self.title setText:roomInfo.channel_title];
    
    [self.level setTitle:roomInfo.localProcessedUserLevel forState:UIControlStateNormal];
    
    self.level.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.level setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.level setImage:[UIImage imageNamed:roomInfo.userLevelImageName] forState:UIControlStateNormal];
    
}

- (void)time{
    //比赛分类
//    @property (nonatomic , copy) NSString *term_name;
//    
//    //比赛类型
//    @property (nonatomic , copy) NSString *type_n
    NSInteger time = [roomInfo.match_time integerValue];
    time -= 1;
    roomInfo.match_time = [NSString stringWithFormat:@"%zd",time];
    self.gameTimeLabel.text = [NSString stringWithFormat:@"答题即将开始:%zds",time];
    
    if (time <= 0) {
       
        NSString *gameName;
        if ([YZGAppSetting sharedInstance].isBig == YES) {
            
           gameName = [NSString stringWithFormat:@"比赛中:%@-%@",roomInfo.type_name,roomInfo.term_name];
        }else{
            
             gameName = [NSString stringWithFormat:@"比赛中:%@",roomInfo.type_name];
        }
        
        
        
        self.gameTimeLabel.text = gameName;
        [timer invalidate];
        timer = nil;
        
    }
    
    
}


@end

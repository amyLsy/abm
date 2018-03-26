//
//  HotTopTypeCell.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/5.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "HotTopTypeCell.h"
#import "BannerRowItem.h"
#import "YZGAppSetting.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface HotTopTypeCell()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) NSArray *banneArray;
@property (nonatomic , strong)  SDCycleScrollView *cycleScrollView;

@end


@implementation HotTopTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:@"CELLTYPE"];
    
    if (type == 1) {
        //为大图
//        [self big:self.bigButton];
        [YZGAppSetting sharedInstance].isBig = YES;
        [self.samllButton setImage:[UIImage imageNamed:@"big_elect"] forState:UIControlStateNormal];
    }else{
        //为小图
           [YZGAppSetting sharedInstance].hotCellWidth = (KScreenWidth/2) - 1;
//        [self samll:self.samllButton];
        [YZGAppSetting sharedInstance].isBig = NO;
        [self.samllButton setImage:[UIImage imageNamed:@"small_elect"] forState:UIControlStateNormal];
        
    }
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath
{
    self.banneArray = item;
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (BannerRowItem *banner in item) {
        [imageUrls addObject:banner.pic];
    }
    self.cycleScrollView.imageURLStringsGroup = imageUrls;
}

-(SDCycleScrollView *)cycleScrollView{
    
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 150) delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        [self.bannerView addSubview:_cycleScrollView];
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}

- (IBAction)selectAtion:(UISegmentedControl *)sender {
    if (_selectAtion) {
         _selectAtion(sender.selectedSegmentIndex);
    }
   
}

- (IBAction)big:(id)sender {
    
    
    _bigButton.selected = YES;
    _samllButton.selected = NO;
    if (_bigOrSmallAtion) {
        
//        _bigOrSmallAtion(sender.tag);
    }
}
- (IBAction)samll:(id)sender {
    
//    _bigButton.selected = NO;
//    _samllButton.selected = YES;
    
    
    NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:@"CELLTYPE"];
    
    if (type == 1) {
        //当前为大图，要切换为小图
        [YZGAppSetting sharedInstance].isBig = NO;
        [self.samllButton setImage:[UIImage imageNamed:@"small_elect"] forState:UIControlStateNormal];
        if (_bigOrSmallAtion) {
            _bigOrSmallAtion(0);
        }
    }else{
        //当前为小图，要切换为大图
        [YZGAppSetting sharedInstance].isBig = YES;
        [self.samllButton setImage:[UIImage imageNamed:@"big_elect"] forState:UIControlStateNormal];
        if (_bigOrSmallAtion) {
            _bigOrSmallAtion(1);
        }
        
    }
}




#pragma mark - XRCarouselViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerRowItem *banner = self.banneArray[index];
    if (_tapBann) {
        _tapBann(banner);
    }
 
}
@end

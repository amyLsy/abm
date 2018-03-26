//
//  BannerTableViewCell.m
//  sisitv
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "BannerTableViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface BannerTableViewCell ()<SDCycleScrollViewDelegate>


@property (nonatomic , strong) NSArray *banneArray;
@property (nonatomic , strong)  SDCycleScrollView *cycleScrollView;
@end

@implementation BannerTableViewCell


-(SDCycleScrollView *)cycleScrollView{
    
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, 150) delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        [self.contentView addSubview:_cycleScrollView];
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{

    return CGSizeMake(KScreenWidth, 155);
}

+ (CGSize)collectionView:(UICollectionView *)collectionView headerSizeForSection:(NSInteger)section{

    return CGSizeMake(KScreenWidth, 190);
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
#pragma mark - XRCarouselViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerRowItem *banner = self.banneArray[index];
    if ([self.delegate respondsToSelector:@selector(tableViewCell:tapBanner:)]) {
        [self.delegate tableViewCell:self tapBanner:banner];
    }
}

@end

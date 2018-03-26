//
//  LGHotDataSource.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/8.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGHotDataSource.h"
#import "HotTopTypeCell.h"
#import "BannerTableViewCell.h"
#import "BannerRowItem.h"
#import "LGHotCell.h"
#import "LGMediaListModel.h"
#import "LGVideoListCell.h"

@interface LGHotDataSource()

@property(nonatomic,strong) HotTopTypeCell *headView;

@end


@implementation LGHotDataSource



-(HotTopTypeCell *)headView{
    
    if (_headView == nil) {
        _headView = [HotTopTypeCell viewFromeNib];
    }
    
    return _headView;
}

-(Class)collectionView:(UICollectionView *)collectionView cellClassForSection:(NSInteger )section{
    if (section == 0) {
        return [BannerTableViewCell class];
    }
    return [super collectionView:collectionView cellClassForSection:section];
}

- (Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(id)item{
    
    if ([item isKindOfClass:[NSArray class]]) {
          return [BannerTableViewCell class];
    }else if([item isKindOfClass:[LGMediaListModel class]]){
         return [LGVideoListCell class];
    }
    
    
    return [LGHotCell class];
}



- (UIView *)collectionView:(UICollectionView *)collectionView headerViewForHeaderItem:(id)headerItem{

    KWeakSelf;
    self.headView.selectAtion = ^(NSInteger type) {
        if (type == 0) {
            NSLog(@"热门视频");
            [ws.headViewDelegate headViewAtionWithType:1 headView:ws.headView];
            
        }else{
             [ws.headViewDelegate headViewAtionWithType:2 headView:ws.headView];
        }
        
        
    };
    
    self.headView.bigOrSmallAtion = ^(NSInteger type) {
        [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"CELLTYPE"];
        if (type == 1) {
            //大图
            [ws.headViewDelegate headViewAtionWithType:3 headView:ws.headView];
        }else{
            //小图
             [ws.headViewDelegate headViewAtionWithType:4 headView:ws.headView];
            
        }
       
        
    };
    
    self.headView.tapBann = ^(BannerRowItem *bannerItem) {
        
          [ws.headViewDelegate tableViewCell:ws.headView tapBanner:bannerItem];
        
    };
    
    
    
    
    return self.headView;
    
}



@end

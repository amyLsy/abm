//
//  LGVideoListCell.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGVideoListCell.h"
#import "LGMediaListModel.h"
#import "YZGAppSetting.h"

@implementation LGVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    
}

+ (CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    
    
    if ([YZGAppSetting sharedInstance].isBig ==  YES && [YZGAppSetting sharedInstance].isHot == YES) {
        
        return CGSizeMake(KScreenWidth , KScreenWidth/0.65);
    }else{
        
        CGFloat width = (KScreenWidth - 2)/2.0;
//        return CGSizeMake(width , width/0.65);
        return CGSizeMake(width , width);
    }
    
    
   
    
}


- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    LGMediaListModel *model = item;
    
    if (model.status == 2) {
        self.statusLabel.text = @"审核中";
    }else{
        self.statusLabel.text = @"";
        
    }
    
    [self.avatarImageView setHeader:model.avatar];;
   
    self.titleLabel.text = model.desc;
    self.commentCountLabel.text = model.comments;
    self.nickNameLabel.text = model.user_nicename;
    
    if (_isImageCell == YES) {
         [self.picImageVIew lg_setImageWithurl:model.uri placeholderImage:nil];
        
    }else{
        
         [self.picImageVIew lg_setImageWithurl:model.thumb placeholderImage:nil];
    }
    
    if (_isUserVieoCell == YES) {
        self.titleLabel.hidden = YES;
        self.nickNameLabel.hidden = YES;
    }
}
//+ (CGSize)collectionView:(UICollectionView *)collectionView headerSizeForSection:(NSInteger)section{
//
//    return CGSizeMake(KScreenWidth, 247);
//}
//+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
//    CGFloat width = (KScreenWidth - 1)/2.0;
//    return CGSizeMake(width , width/0.65);
//}

@end
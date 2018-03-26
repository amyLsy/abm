//
//  LGMediaDataSource.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGMediaDataSource.h"
#import "LGVideoListCell.h"

@implementation LGMediaDataSource

-(Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(YZGCollectionRowItem *)item{
   

    return [LGVideoListCell class];
  
}

@end

//
//  NewFeatureDataSource.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "NewFeatureDataSource.h"

@implementation NewFeatureDataSource
-(Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(id)item{
    return [NewFeatureCollectionCell class];
}
@end

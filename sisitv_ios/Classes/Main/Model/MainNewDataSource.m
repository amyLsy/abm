//
//  MainTopicDataSource.m
//  xiuPai
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MainNewDataSource.h"
#import "LGMediaListModel.h"
#import "LGUploadTermsModel.h"
#import "LGTermsTypeView.h"
#include "LGTopCell.h"
#import "LGUploadTermsModel.h"
#import "LGHotCell.h"

@implementation MainNewDataSource

-(Class)collectionView:(UICollectionView *)collectionView cellClassForItem:(YZGCollectionRowItem *)item{
    if ([item isKindOfClass:[RoomInfo class]]) {
        return [MainNewCollectionCell class];
    }else if([item isKindOfClass:[NSArray class]]){
        return [LGTopCell class];
    }else if([item isKindOfClass: [LGMediaListModel class]]){
        
        return [LGVideoListCell class];
    }else{
        
         return [MainNewSepCollectionCell class];
    }
}

//- (UIView *)collectionView:(UICollectionView *)collectionView headerViewForHeaderItem:(id)headerItem{
//
//    CGRect frame = CGRectMake(0, 0, 100, 36);
//    LGTermsTypeView *type = [[LGTermsTypeView alloc] initWithFrame:frame];
//
//
//
//
//
//    return type;
//
//}

@end
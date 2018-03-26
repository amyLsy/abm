//
//  BaseCollectionViewController.h
//  xiuPai
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "BaseViewController.h"
#import "YZGCollectionView.h"

 @class YZGCollectionDataSource;

@protocol YZGCollectionViewControllerDelegate <NSObject>

@required
- (void)createDataSourceAndLayout;
@end

@interface YZGCollectionViewController : BaseViewController<YZGCollectionViewDelegate,YZGCollectionViewControllerDelegate>

@property (nonatomic , strong) YZGCollectionView *collectionView;
@property (nonatomic , strong) UICollectionViewFlowLayout *layout;
@property (nonatomic , strong) YZGCollectionDataSource *dataSource;
@property (nonatomic , strong) NSArray<NSString *> *cellClassName;

@end

//
//  BaseCollectionViewController.m
//  xiuPai
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionViewController.h"
#import "LGUserMediaHeadView.h"
@interface YZGCollectionViewController ()

@end

@implementation YZGCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSourceAndLayout];
    NSAssert(self.layout, @"必须在 ""createDataSourceAndLayout方法中设置 self.layout 为你创建的 layout""");
    [self creatCollectionView];
}

-(void)creatCollectionView{
    self.collectionView = [[YZGCollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth, KHadTabBarAndNavBarViewHeight) collectionViewLayout:self.layout];
    self.collectionView.yzgDelegate = self;
    self.collectionView.yzgDataSource = self.dataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    for (NSString *cellClassName in self.cellClassName) {
        [self.collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellWithReuseIdentifier:cellClassName];
    }
    if (self.layout.headerReferenceSize.height > 0) {
        
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YZGCollectionReusableView"];
    }
    
    
}




-(void)createDataSourceAndLayout {
    @throw @"You Must implement This Mehtod ";
}
@end

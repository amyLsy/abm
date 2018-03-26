//
//  NewFeatureController.m
//  xiuPai
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "NewFeatureController.h"
#import "NewFeatureDataSource.h"
#import "ADController.h"
#import "YZGRequest.h"
@interface NewFeatureController ()

@property (nonatomic , strong) UIPageControl *pageControl;

@property (nonatomic , copy) void(^disappearHandler)(void);

@property (nonatomic , assign) NSInteger maxPage;
@property (nonatomic , strong) UIButton *jump;

@end

@implementation NewFeatureController

-(instancetype)initWithDisappearHandler:(void (^)(void))disappearHandler{
    if (self = [super init]) {
        self.disappearHandler = disappearHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//        YZGRequest *request = [[YZGRequest alloc]init];
//    request.requestUrl = @"getLaunchScreen";
//        [request startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
//
//            NSLog(@"%@",request.responseObject);
//        } failure:nil];
    
    
    // Do any additional setup after loading the vie
    self.collectionView.frame = self.view.bounds;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewFeatureCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"NewFeatureCollectionCell"];
    self.pageControl.currentPage = 0;
    
    self.jump = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jump.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.jump.layer.cornerRadius = 5;
    self.jump.layer.masksToBounds = YES;
    self.jump.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.jump];
    [self.jump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-75);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_offset(CGSizeMake(150, 44));
    }];
    [self.jump setTitle:@"立即开启" forState:UIControlStateNormal];
    [self.jump addTarget:self action:@selector(jumpNewFauture) forControlEvents:UIControlEventTouchUpInside];
    self.jump.hidden = YES;
}
-(void)jumpNewFauture{
    self.disappearHandler();
}

- (void)createDataSourceAndLayout{
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:0 columnSpacing:0];
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    self.layout = layout;
    
    self.dataSource = [[NewFeatureDataSource alloc]init];
    YZGCollectionSectionItem *sectionItem = [[YZGCollectionSectionItem alloc]init];
    NSArray *imageName = @[@"guidepageImage1",@"guidepageImage2",@"guidepageImage3"];
    _maxPage = imageName.count;
    for (NSString *nameString in imageName) {
        NewFeatureRowItem *rowItem = [[NewFeatureRowItem alloc]init];
        rowItem.imageName = nameString;
        [sectionItem.rowItems addObject:rowItem];
    }
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)scrollViewScrollToPage:(NSInteger)page{

    if (page == (_maxPage - 1)) {
        self.jump.hidden = NO;
    }else{

        self.jump.hidden = YES;
    }
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((KScreenWidth-100)/2.0,KScreenHeight-55, 100, 55)];
        [self.view addSubview:self.pageControl];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.hidden = YES;
    }
    return _pageControl;
}

@end

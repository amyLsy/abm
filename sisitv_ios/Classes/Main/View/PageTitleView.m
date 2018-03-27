//
//  PageTitleView.m
//  sisitv_ios
//
//  Created by Apple on 17/4/13.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "PageTitleView.h"
#import "TopicRowItem.h"


static CGFloat const kScrollLineH = 5.0;
static CGFloat const kTitleButtonHeight = 41.0;

@interface PageTitleView ()

@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) NSArray *titles;
@property (nonatomic , strong) NSMutableArray *titleLabels;
@property (nonatomic , strong) NSMutableArray *titleViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UILabel *selectedLabel;
@property (nonatomic , strong) UIView *selectedView;

@end

@implementation PageTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    [self setupTitleLabels];
}

- (void)setupTitleLabels{
    CGFloat btnX = 0.0;
    CGFloat btnW = 0.0;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    for (int i = 0; i < self.titles.count; i ++) {
        btnX += btnW;
        TopicRowItem *item = self.titles[i];
        
        if (self.titles.count>4) {
            CGSize size=[item.name sizeWithAttributes:attrs];
            btnW = size.width + 35;
        }else{
            btnW = self.frame.size.width/self.titles.count;
        }
       
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnX, 0, btnW, kTitleButtonHeight)];
        titleLabel.text = item.name;
        titleLabel.tag = i;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:titleLabel];
        [self.titleLabels addObject:titleLabel];
        titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClickWithTapGes:)];
        [titleLabel addGestureRecognizer:tapGes];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(btnX + btnW * 0.2 * 0.5, kTitleButtonHeight - 2, btnW * 0.8, kScrollLineH)];
        titleView.hidden = YES;
        //lsy
        UIImageView *lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_underline"]];
        [titleView addSubview:lineImgView];
        lineImgView.contentMode = UIViewContentModeScaleToFill;
        [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(titleView).offset(12);
//            make.right.mas_equalTo(titleView).offset(-12);
            make.centerX.mas_equalTo(titleView);
            make.width.mas_equalTo(20);
            make.bottom.mas_equalTo(titleView).offset(-4);
            make.height.mas_equalTo(kScrollLineH);
        }];
//        titleView.backgroundColor = RGB_COLOR(255, 102, 88, 1);
//        titleView.backgroundColor = RGBToColor(142, 63, 216);
        titleView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:titleView];
        [self.titleViews addObject:titleView];
    }
    self.scrollView.contentSize = CGSizeMake(btnX + btnW, 0);
}

- (void)titleLabelClickWithTapGes:(UITapGestureRecognizer *)tapGes{
    UILabel *currentLabel = (UILabel *)tapGes.view;
    if (currentLabel.tag == self.currentIndex) return;
    UILabel *oldLabel = self.titleLabels[self.currentIndex];
    UIView *currentView = self.titleViews[currentLabel.tag];
    UIView *oldView = self.titleViews[self.currentIndex];
    currentLabel.textColor = [UIColor blackColor];
    oldLabel.textColor = [UIColor darkGrayColor];
    currentView.hidden = NO;
    oldView.hidden = YES;
    [self scrollViewSetContentOffsetWithLabel:currentLabel];
    self.currentIndex = currentLabel.tag;
    if ([self.delegate respondsToSelector:@selector(pageTitleViewWithTitleView:selectedIndex:)]) {
        [self.delegate pageTitleViewWithTitleView:self selectedIndex:self.currentIndex];
    }
}

- (void)scrollViewSetContentOffsetWithLabel:(UILabel *)lable{
    CGFloat  scrollViewContentSizeW = self.scrollView.contentSize.width;
    CGFloat  selfW = self.frame.size.width;
    CGFloat contentOffsetX = lable.center.x - selfW/2.0;
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    }
    if (scrollViewContentSizeW - lable.center.x < selfW / 2.0) {
        contentOffsetX = scrollViewContentSizeW - selfW;
    }
    if (self.titles.count>4) {
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
    }
}

-(void)setTitleWithIndex:(NSInteger)index{
    self.selectedLabel.textColor = [UIColor lightGrayColor];
    self.selectedView.hidden = YES;
    self.selectedLabel = self.titleLabels[index];
    self.selectedView = self.titleViews[index];
    self.selectedLabel.textColor = [UIColor blackColor];
    self.selectedView.hidden = NO;
    self.currentIndex = index;
    [self scrollViewSetContentOffsetWithLabel:self.selectedLabel];
}

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    
    
//    UILabel *sourceLabel = self.titleLabels[sourceIndex];
//    UILabel *targetLabel = self.titleLabels[targetIndex];
//    sourceLabel.textColor = [UIColor blackColor];
//    targetLabel.textColor = [UIColor whiteColor];
//    UIView *sourceView = self.titleViews[sourceIndex];
//    UIView *targetView = self.titleViews[targetIndex];
//    sourceView.hidden = YES;
//    targetView.hidden = NO;
//    self.currentIndex = porgress;
    
    [self scrollViewSetContentOffsetWithLabel:self.selectedLabel];
}

#pragma mark - 懒加载
- (NSInteger)currentIndex{
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    return _currentIndex;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = [NSArray array];
    }
    return _titles;
}

- (NSMutableArray *)titleViews{
    if (!_titleViews) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
@end

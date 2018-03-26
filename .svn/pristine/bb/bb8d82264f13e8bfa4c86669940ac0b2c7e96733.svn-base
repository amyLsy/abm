//
//  YZGCollectionViewTagLayout.m
//  sisitv_ios
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "ChatGiftCollectionViewLayout.h"

@interface ChatGiftCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *totalAttributes;

@property (nonatomic, assign) CGFloat contentWidth;

@property (nonatomic, assign) CGFloat contentHeight;

@end


@implementation ChatGiftCollectionViewLayout

-(instancetype)init{
    if (self = [super init]) {
        self.scrollDirection = YZGGiftCollectionViewScrollVertical;
        self.contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
        self.horizontalSpacing = 5;
        self.verticalSpacing = 5;
    }
    return self;
}

-(instancetype)initWithScrollDirection:(YZGGiftCollectionViewScrollDirection )scrollDirection{
    if (self = [super init]) {
        self.scrollDirection = scrollDirection;
        self.contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
        self.horizontalSpacing = 5;
        self.verticalSpacing = 5;
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    
    if (_scrollDirection == YZGGiftCollectionViewScrollVertical) {
        [self prepareForScrollVertical];
    } else if (_scrollDirection == YZGGiftCollectionViewScrollHorizontal) {
        [self prepareForScrollHorizontal];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *currentIncludeAttributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [currentIncludeAttributes addObject:attributes];
        }
    }
    return currentIncludeAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    id <UICollectionViewDelegateFlowLayout> delegate = (id <UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
    CGSize itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    attributes.size = itemSize;
    attributes.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(_contentWidth, _contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

#pragma mark - Private methods
- (void)prepareForScrollVertical {
    CGFloat currentLineX = 0;
    CGFloat tmpHeight = 0;
    CGRect frame;
    
    CGFloat visibleWidth = CGRectGetWidth(self.collectionView.frame) - _contentInset.left - _contentInset.right;
    NSInteger itemscount = [self.collectionView numberOfItemsInSection:0];
    
    _totalAttributes = [[NSMutableArray alloc] initWithCapacity:itemscount];
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    
    // Create attributes and get each line max height and width
    for (NSUInteger i = 0; i < itemscount; i++) {
        // Create attributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_totalAttributes addObject:attributes];
        
        frame = attributes.frame;
        
        if (currentLineX + CGRectGetWidth(frame) > visibleWidth) {
            // New Line
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
            tmpHeight = 0;
            currentLineX = 0;
        }
        
        currentLineX += CGRectGetWidth(frame) + _horizontalSpacing;
        tmpHeight = MAX(CGRectGetHeight(frame), tmpHeight);
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
    [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
    // Check
    NSAssert(eachLineMaxHeightNumbers.count == eachLineWidthNumbers.count, @"eachLineMaxHeightNumbers and eachLineWidthNumbers not equal.");
    
    // Prepare
    currentLineX = 0;
    CGFloat currentYBase = _contentInset.top;
    NSUInteger currentAttributesIndex = 0;
    CGFloat currentLineMaxHeight = 0;
    CGFloat currentLineWidth = 0;
    
    // Set X and Y
    for (NSUInteger i = 0; i < eachLineWidthNumbers.count; i++) {
        currentLineWidth = eachLineWidthNumbers[i].floatValue;
        currentLineMaxHeight = eachLineMaxHeightNumbers[i].floatValue;
        
        // Alignment x offset
        CGFloat currentLineXOffset = 0;
        
        currentLineXOffset = _contentInset.left;
        
        // Current line
        while (currentLineX < currentLineWidth && currentAttributesIndex < _totalAttributes.count) {
            UICollectionViewLayoutAttributes *attributes = _totalAttributes[currentAttributesIndex];
            frame = attributes.frame;
            frame.origin.x = currentLineXOffset + currentLineX;
            frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
            attributes.frame = frame;
            
            currentLineX += CGRectGetWidth(frame) + _horizontalSpacing;
            currentAttributesIndex += 1;
        }
        
        // Next line
        currentLineX = 0;
        currentYBase += currentLineMaxHeight + _verticalSpacing;
    }
    
    _contentWidth = CGRectGetWidth(self.collectionView.frame);
    _contentHeight = currentYBase - _verticalSpacing + _contentInset.bottom;
}


#pragma mark - Setter

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self invalidateLayout];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    [self invalidateLayout];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    [self invalidateLayout];
}



//prepareForScrollHorizontal

- (void)prepareForScrollHorizontal {
    CGRect frame;
    _contentWidth = 0;
    _contentHeight = 0;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    _totalAttributes = [[NSMutableArray alloc] initWithCapacity:(NSUInteger) count];
    //至少1行
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;
    // Create attributes
    for (NSInteger i = 0; i < count; i++) {
        //获取每一个item的attributes,添加进_totalAttributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_totalAttributes addObject:attributes];
    }
    // Set X and Get each line max height
    for (NSInteger i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attributes = _totalAttributes[i];
        frame = attributes.frame;
        
        NSInteger page = i/8; //当前页
        NSInteger tmp = i % 8; //当前页第几个
        
        CGFloat y = tmp/ 4; //当前页第几行
        CGFloat x = tmp% 4; //当前页第几lie
        CGFloat  orginX = (x + page * 4) * frame.size.width;
        CGFloat  orginY = y * frame.size.height;
        frame = CGRectMake(orginX, orginY, frame.size.width, frame.size.height);
        
        attributes.frame = frame;
    }
    CGFloat pages = ceilf((count /8.0));
    _contentWidth = self.collectionView.width *pages;
    _contentHeight = self.collectionView.height;
}


@end

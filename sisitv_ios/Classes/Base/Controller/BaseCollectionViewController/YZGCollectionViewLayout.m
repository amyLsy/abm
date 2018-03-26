//
//  YZGCollectionViewTagLayout.m
//  sisitv_ios
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionViewLayout.h"

@interface YZGCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *totalAttributes;

@property (nonatomic, assign) CGFloat contentWidth;

@property (nonatomic, assign) CGFloat contentHeight;

@end


@implementation YZGCollectionViewLayout

-(instancetype)init{
    if (self = [super init]) {
        self.scrollDirection = YZGCollectionViewScrollVertical;
        self.contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
        self.horizontalSpacing = 5;
        self.verticalSpacing = 5;
    }
    return self;
}

-(instancetype)initWithScrollDirection:(YZGCollectionViewScrollDirection )scrollDirection{
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
    
    if (_scrollDirection == YZGCollectionViewScrollVertical) {
        [self prepareForScrollVertical];
    } else if (_scrollDirection == YZGCollectionViewScrollHorizontal) {
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
    CGFloat totalWidthInOneLine = 0, averageWidthEachLine = 0, currentX = _contentInset.left, currentYBase = -_verticalSpacing + _contentInset.top, tmpHeight = 0;
    CGRect frame;
    _contentWidth = 0;
    _contentHeight = 0;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTrueWidthNumbers = [NSMutableArray new];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    _totalAttributes = [[NSMutableArray alloc] initWithCapacity:(NSUInteger) count];
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;
    
    // Create attributes
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_totalAttributes addObject:attributes];
        totalWidthInOneLine += CGRectGetWidth(attributes.frame) + _horizontalSpacing;
    }
    
    // Calculate each line width
    averageWidthEachLine = totalWidthInOneLine / (CGFloat)_numberOfLines;
    
    // Set X and Get each line max height
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        frame = attributes.frame;
        frame.origin.x = currentX;
        attributes.frame = frame;
        
        currentX += CGRectGetWidth(frame) + _horizontalSpacing;
        _contentWidth = MAX(currentX - _horizontalSpacing, _contentWidth);
        tmpHeight = MAX(CGRectGetHeight(frame), tmpHeight);
        
        if (currentX > averageWidthEachLine && eachLineMaxHeightNumbers.count < _numberOfLines) {
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            [eachLineTrueWidthNumbers addObject:@(currentX - _contentInset.left - _horizontalSpacing)];
            tmpHeight = 0;
            currentX = _contentInset.left;
        }
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
    [eachLineTrueWidthNumbers addObject:@(currentX - _contentInset.left - _horizontalSpacing)];
    
    // Set Y
    NSUInteger currentLineIndex = 0;
    CGFloat currentLineMaxHeight = 0;
    CGFloat currentLineTrueWidth = 0;
    CGFloat currentLineXOffset = 0;
    
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        frame = attributes.frame;
        
        if (frame.origin.x == _contentInset.left && currentLineIndex < eachLineMaxHeightNumbers.count) {
            currentYBase += currentLineMaxHeight + _verticalSpacing;
            currentLineMaxHeight = eachLineMaxHeightNumbers[currentLineIndex].floatValue;
            currentLineTrueWidth = eachLineTrueWidthNumbers[currentLineIndex].floatValue;
            currentLineIndex += 1;
            currentLineXOffset = 0;
            
        }
        
        frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
        frame.origin.x += currentLineXOffset;
        attributes.frame = frame;
    }
    
    // Final content size
    _contentWidth += _contentInset.right;
    _contentHeight = currentYBase + currentLineMaxHeight + _contentInset.bottom;
}


@end

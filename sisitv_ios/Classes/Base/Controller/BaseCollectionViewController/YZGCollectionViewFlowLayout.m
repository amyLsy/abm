//
//  YZGFlowLayout.m
//  sisitv
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "YZGCollectionViewFlowLayout.h"

@interface YZGCollectionViewFlowLayout ()

@property (nonatomic , assign) CGFloat columnSpacing;

@property (nonatomic , assign) CGFloat rowSpacing;


@end

@implementation YZGCollectionViewFlowLayout{
    
    NSMutableArray *_attributeArray;
}

-(instancetype)initWithRowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.rowSpacing = rowSpacing;
        self.columnSpacing = columnSpacing;
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    self.minimumLineSpacing = self.columnSpacing;
    self.minimumInteritemSpacing = self.columnSpacing;
    
    _attributeArray = [NSMutableArray array];
    //头部视图
//    UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes   layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
//    layoutHeader.frame =CGRectMake(0,0, 375, 200);
//    [_attributeArray addObject:layoutHeader];
    
    
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    //为了防止出现This is likely occurring because the flow layout subclass YZGFlowLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them警告
    NSMutableArray *copyAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyAttributes addObject:[attribute copy]];
    }
    for(int i = 1; i < [copyAttributes count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = copyAttributes[i];
        NSInteger preIndex = i-1;
        UICollectionViewLayoutAttributes *prevLayoutAttributes = copyAttributes[preIndex];
        NSInteger rowSpacing = self.rowSpacing;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + rowSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + rowSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return copyAttributes;
}


@end

//
//  MainNewTopicCollectionCell.m
//  sisitv_ios
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "MainNewTopicCollectionCell.h"
@interface MainNewTopicCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation MainNewTopicCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    TopicRowItem *topic = (TopicRowItem *)item;
    self.name.text = topic.name;
}

+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id )item{
//    return CGSizeMake((KScreenWidth - 5) /2.0, 50);
    return CGSizeMake((KScreenWidth - 5) /2.0, 0);
}
@end

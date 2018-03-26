//
//  ShowingTopicCollectionCell.m
//  sisitv_ios
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ShowingTopicCollectionCell.h"

@interface ShowingTopicCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation ShowingTopicCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"ff4081"];
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}


+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id )item{
    return CGSizeMake((KScreenWidth-50)/3.0, 25);
}

-(void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    TopicRowItem *rowItem = (TopicRowItem *)item;
    if (rowItem.selected) {
        self.backgroundColor = kNavColor;
        self.tagLabel.textColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor lightGrayColor];
        self.tagLabel.textColor = [UIColor blackColor];
    }
    self.tagLabel.text = rowItem.name;
}


@end

//
//  MainNewCollectionCell.m
//  sisitv
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "MainNewCollectionCell.h"

@interface MainNewCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *showingType;
@end


@implementation MainNewCollectionCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.location.layer.cornerRadius = 3;
    self.location.layer.masksToBounds = YES;
}

- (void)setItem:(id)item forIndexPath:(NSIndexPath *)indexPath{
    RoomInfo *roomInfo  = (RoomInfo *)item;
    [self.avatar sd_setImageWithURL:roomInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_main_new"]];
    self.name.text = roomInfo.user_nicename;
    self.location.text = roomInfo.location;
}

+(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForItem:(id)item{
    CGFloat width = (KScreenWidth- 2) / 2.0;
    return CGSizeMake(width , width + 40);
}
@end

//
//  LGVideoPlayCell.h
//  sisitv_ios
//
//  Created by Ming on 2017/12/25.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionCell.h"
#import "LGMediaListModel.h"


typedef void(^LGPlayCellAtion) (NSInteger ationType ,LGMediaListModel *model);

@interface LGVideoPlayCell : YZGCollectionCell 
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *decLabel;
@property (weak, nonatomic) IBOutlet UILabel *sharesLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *islikeBUtton;
@property (weak, nonatomic) IBOutlet UILabel *firesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *playVideoView;



@property (strong ,nonatomic) LGMediaListModel *model;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (copy ,nonatomic) LGPlayCellAtion cellAtion;
@property (weak, nonatomic) IBOutlet UIButton *userAvatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (assign ,nonatomic) NSInteger cellType;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;





@property (nonatomic, assign)BOOL isStart;

@end

//
//  LGPlayScrollView.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/12.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGPlayScrollView.h"
#import "LGVideoPlayCell.h"
#import "LGMediaListModel.h"

@interface LGPlayScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * videos;

@property (nonatomic, strong) LGMediaListModel *upperLive, *middleLive, *downLive;
@property (nonatomic, assign) NSInteger currentIndex;
@end


@implementation LGPlayScrollView

- (NSMutableArray *)videos{
    
    if (_videos == nil) {
        _videos = [NSMutableArray array];
    }
    
    return _videos;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentSize = CGSizeMake(0, frame.size.height * 3);
        self.contentOffset = CGPointMake(0, frame.size.height);
        self.pagingEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor yellowColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        
        // image views
        // blur effect
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        // blur view
//        UIVisualEffectView *visualEffectViewUpper = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        UIVisualEffectView *visualEffectViewMiddle = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        UIVisualEffectView *visualEffectViewDown = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.upperImageView = [[[NSBundle mainBundle] loadNibNamed:@"LGVideoPlayCell" owner:nil options:nil] firstObject];
//        self.upperImageView = [LGVideoPlayCell viewFromeNib];
        self.upperImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.middleImageView = [LGVideoPlayCell viewFromeNib];
        self.middleImageView.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        
        self.downImageView = [LGVideoPlayCell viewFromeNib];
        self.downImageView.frame = CGRectMake(0, frame.size.height*2, frame.size.width, frame.size.height);
       
        // add video views
        [self addSubview:self.upperImageView];
        [self addSubview:self.middleImageView];
        [self addSubview:self.downImageView];
        
        
    }
    return self;
}

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger)index
{
    if (livesArray.count && [livesArray firstObject]) {
        [self.videos removeAllObjects];
        [self.videos addObjectsFromArray:livesArray];
        self.currentIndex = index;
        _upperLive = [[LGMediaListModel alloc] init];
        _middleLive = (LGMediaListModel *)_videos[_currentIndex];
        _downLive = [[LGMediaListModel alloc] init];
        
        if (_currentIndex == 0) {
            _upperLive = (LGMediaListModel *)[_videos lastObject];
        } else {
            _upperLive = (LGMediaListModel *)_videos[_currentIndex - 1];
        }
        if (_currentIndex == _videos.count - 1) {
            _downLive = (LGMediaListModel *)[_videos firstObject];
        } else {
            _downLive = (LGMediaListModel *)_videos[_currentIndex + 1];
        }
        
        [self prepareForImageView:self.upperImageView withLive:_upperLive];
        [self prepareForImageView:self.middleImageView withLive:_middleLive];
        [self prepareForImageView:self.downImageView withLive:_downLive];
    }
}
- (void)prepareForImageView: (LGVideoPlayCell *)imageView withLive:(LGMediaListModel *)video
{
    [imageView setItem:video forIndexPath:nil];
}
- (void)switchPlayer:(UIScrollView*)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.videos.count) {
        if (offset >= 2*self.frame.size.height)
        {
            // slides to the down player
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex++;
          
            self.upperImageView.model = self.middleImageView.model;
            self.middleImageView.model = self.downImageView.model;
            
            if (_currentIndex == self.videos.count - 1)
            {
                _downLive = [self.videos firstObject];
            } else if (_currentIndex == self.videos.count)
            {
                _downLive = self.videos[0];
                _currentIndex = 0;
                
            } else
            {
                _downLive = self.videos[_currentIndex+1];
            }
            [self prepareForImageView:self.downImageView withLive:_downLive];
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
            }
        }
        else if (offset <= 0)
        {
            // slides to the upper player
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex--;
            self.downImageView.model = self.middleImageView.model;
            self.middleImageView.model = self.upperImageView.model;
            if (_currentIndex == 0)
            {
                _upperLive = [self.videos lastObject];
                
            } else if (_currentIndex == -1)
            {
                NSInteger count = self.videos.count;
                
                if ((count - 2) < 0) {
                    
                    count = 0;
                    _currentIndex = 0;
                }else{
                    if ((count - 1) < 0) {
                        count = 1;
                    }
                    _upperLive = self.videos[self.videos.count - 2];
                    _currentIndex = count - 1;
                }
                
               
                
            } else
            {
                _upperLive = self.videos[_currentIndex - 1];
            }
            [self prepareForImageView:self.upperImageView withLive:_upperLive];
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
            }
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self switchPlayer:scrollView];
}






@end

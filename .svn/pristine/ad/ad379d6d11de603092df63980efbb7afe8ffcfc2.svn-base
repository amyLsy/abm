//
//  HSYTopPicView.m
//  百思不得姐
//
//  Created by Apple_Lzzy27 on 16/11/9.
//  Copyright © 2016年 Apple_Lzzy27. All rights reserved.
//

#import "HSYTopPicView.h"
//#import <AFNetworkReachabilityManager.h>
#import <DACircularProgress/DALabeledCircularProgressView.h>

@interface HSYTopPicView()

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressVIew;

@property (weak, nonatomic) IBOutlet UIImageView *gifButton;

@property (weak, nonatomic) IBOutlet UIButton *seeBigImageButton;

@end



@implementation HSYTopPicView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    //添加图片手势
    NSLog(@"%@",NSStringFromCGRect(_imageView.frame));
    _imageView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigImage)];
    [_imageView addGestureRecognizer:tap];
    
    
}
- (void)seeBigImage{
    
//    HSYSeeBigController *big = [[HSYSeeBigController alloc] init];
//    big.bigImageName = _list.large_image;
//    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
//
//    [tab.selectedViewController  presentViewController:big animated:YES completion:nil];
    
}

- (void)setList:(LGMediaListModel *)list{
    
    _list = list;

    NSString *urlStr = list.uri;
    if (urlStr.length) {
     NSURL *url = [NSURL URLWithString:urlStr];
    _seeBigImageButton.hidden = !list.is_BigImage;
    _gifButton.hidden = !list.is_gif;
    [_imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        _progressVIew.hidden = NO;
        _progressVIew.progress = 1.0 * receivedSize/expectedSize;
        _progressVIew.progressLabel.text = [NSString stringWithFormat:@"%zd%%",100 * receivedSize/expectedSize];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _progressVIew.hidden = YES;
    }];

    }
}
- (IBAction)seeBigImage:(id)sender {
//    HSYSeeBigController *big = [[HSYSeeBigController alloc] init];
//    big.bigImageName = _list.large_image;
//    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
//
//    [tab.selectedViewController  presentViewController:big animated:YES completion:nil];
}

@end

//
//  NoDataView.m
//  sisitv
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;

@end

@implementation NoDataView
+(instancetype)noDataView{
    return [[[NSBundle mainBundle]loadNibNamed:@"NoDataView" owner:nil options:nil]lastObject];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = [imageName copy];
    self.noDataImageView.image = [UIImage imageNamed:_imageName];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    return nil;
}
@end

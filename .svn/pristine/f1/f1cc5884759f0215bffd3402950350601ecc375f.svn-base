//
//  UIImage+Image.m
//  
//
//  Created by apple on 15-3-4.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
   UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
//    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height /4, image.size.width /4, image.size.height /4, image.size.width /4) resizingMode:UIImageResizingModeTile];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

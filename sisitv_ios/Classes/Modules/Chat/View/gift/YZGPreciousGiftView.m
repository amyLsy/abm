//
//  YZGPreciousGiftManager.m
//  xiuPai
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "YZGPreciousGiftView.h"
#import "ChatMessage.h"

#define KAnimalTime 4.0


@interface YZGPreciousGiftView()


@property (nonatomic , assign) BOOL isAnimationing;

@property (nonatomic , strong) UIImageView *animationImageView;
/**
 礼物总数组

 */
@property (nonatomic , strong) NSMutableArray *allGiftMessage;

@end


@implementation YZGPreciousGiftView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.allGiftMessage = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"allGiftMessage" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void)showPreciousAnimationForMessage:(ChatMessage *)chatMessage{
    [[self mutableArrayValueForKey:@"allGiftMessage" ] addObject:chatMessage];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"allGiftMessage"]){
        ChatMessage *chatMessage = [self.allGiftMessage firstObject];
        if (chatMessage) {
            [self excutingWithChatMessage:chatMessage];
        }else{
            [self removeFromSuperview];
        }
    }
}

-(void)excutingWithChatMessage:(ChatMessage *)chatMessage{
    if (self.isAnimationing) return;
    
//    [self normalAnimal:chatMessage];
//    [self otherAnimal:chatMessage];
    
    
    NSString *giftid = chatMessage.other.giftInfo.giftid;
    NSString *giftName = [self getGiftNameForGiftId:giftid];

    NSMutableArray *arr = [NSMutableArray array];
    for (int i =1; i<200; i++) {
        
        NSString *imageString;
        if ([giftName isEqualToString:@"62"]||[giftName isEqualToString:@"63"]) {
            imageString = [NSString stringWithFormat:@"%@%d",giftName,i];
            
            if ([UIImage imageNamed:imageString]) {
                [arr addObject:[UIImage imageNamed:imageString]];
            }else{
                break;
            }
            
        }else{
            NSString *index = i*4<10?[NSString stringWithFormat:@"00%d",(int)i*4]:[NSString stringWithFormat:@"0%d",(int)i*4];
            index = i*4>99?[NSString stringWithFormat:@"%d",(int)i*4]:index;
            imageString = [NSString stringWithFormat:@"%@%@",giftName,index];
            
            if ([UIImage imageNamed:imageString]) {
                
                
                dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^{
                    NSLog(@"%@",[NSThread currentThread]);    // 这里放任务代码
                    
                    
                });
//                UIImage *newiamge = [self imageByScalingAndCroppingForSize:CGSizeMake(KScreenWidth-40, KScreenHeight-40) withSourceImage:[UIImage imageNamed:imageString]];
//                [arr addObject:newiamge];
                [arr addObject:[UIImage imageNamed:imageString]];
            }else{
                break;
            }
        }
        
        
        
    }
    if (arr.count<=0) {
        [self animationImageViewStopAnimating:chatMessage];
    }else{
        self.animationImageView.animationImages  = arr;
        self.animationImageView.animationDuration = KAnimalTime;
        self.animationImageView.animationRepeatCount = 1;
        [self.animationImageView startAnimating];
        self.isAnimationing = YES;
        [self performSelector:@selector(animationImageViewStopAnimating:) withObject:chatMessage afterDelay:KAnimalTime];
    }
}

//
//- (void)otherAnimal:(ChatMessage *)chatMessage
//{
//    if (self.isAnimationing) return;
//    NSString *giftid = chatMessage.other.giftInfo.giftid;
//    NSString *giftName = [self getGiftNameForGiftId:giftid];
//     if ([giftName isEqualToString:@"62"]||[giftName isEqualToString:@"63"]) {
//         return;
//     }
//    NSMutableArray *arr = [NSMutableArray array];
//    
//    //异步串行
//    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
//    KWeakSelf;
//    dispatch_async(queue, ^{
//        NSLog(@"%@",[NSThread currentThread]);    // 这里放任务代码
//        for (int i =1; i<200; i++) {
//            
//            NSString *index = i*4<10?[NSString stringWithFormat:@"00%d",(int)i*4]:[NSString stringWithFormat:@"0%d",(int)i*4];
//            index = i*4>99?[NSString stringWithFormat:@"%d",(int)i*4]:index;
//            NSString *imageString = [NSString stringWithFormat:@"%@%@",giftName,index];
//            if ([UIImage imageNamed:imageString]) {
//                UIImage *newiamge = [ws imageByScalingAndCroppingForSize:CGSizeMake(KScreenWidth-40, KScreenHeight-40) withSourceImage:[UIImage imageNamed:imageString]];
//                [arr addObject:newiamge];
//                
//            }else{
//                break;
//            }
//        }
//        
//        //进入主线程
//        
//        dispatch_queue_t queue = dispatch_get_main_queue();
//        dispatch_sync(queue, ^{
//           
//            if (arr.count<=0) {
//                [ws animationImageViewStopAnimating:chatMessage];
//            }else{
//                ws.animationImageView.animationImages  = arr;
//                ws.animationImageView.animationDuration = KAnimalTime;
//                ws.animationImageView.animationRepeatCount = 1;
//                [ws.animationImageView startAnimating];
//                ws.isAnimationing = YES;
//                [ws performSelector:@selector(animationImageViewStopAnimating:) withObject:chatMessage afterDelay:KAnimalTime];
//            }
//        });
//        
//        
//        
//    });
//    
//   
//    
//}
//


//- (void)normalAnimal:(ChatMessage *)chatMessage
//{
//    if (self.isAnimationing) return;
//    NSString *giftid = chatMessage.other.giftInfo.giftid;
//    NSString *giftName = [self getGiftNameForGiftId:giftid];
//    if (![giftName isEqualToString:@"62"]||![giftName isEqualToString:@"63"]) {
//        return;
//    }
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i =1; i<200; i++) {
//        
//        NSString *imageString= [NSString stringWithFormat:@"%@%d",giftName,i];
//        if ([UIImage imageNamed:imageString]) {
//            [arr addObject:[UIImage imageNamed:imageString]];
//        }else{
//            break;
//        }
//
//    }
//    
//    if (arr.count<=0) {
//        [self animationImageViewStopAnimating:chatMessage];
//    }else{
//        self.animationImageView.animationImages  = arr;
//        self.animationImageView.animationDuration = KAnimalTime;
//        self.animationImageView.animationRepeatCount = 1;
//        [self.animationImageView startAnimating];
//        self.isAnimationing = YES;
//        [self performSelector:@selector(animationImageViewStopAnimating:) withObject:chatMessage afterDelay:KAnimalTime];
//    }
//    
//}





-(NSString *)getGiftNameForGiftId:(NSString *)giftid{
    NSString *giftName = nil;
    if ([giftid isEqualToString:@"5"]) {
        giftName = @"63";
    }else if ([giftid isEqualToString:@"4"]){
        giftName = @"62";
    }else if ([giftid isEqualToString:@"2"]){
        giftName = @"求婚_00";
    }else if ([giftid isEqualToString:@"1"]){
        giftName = @"rose_00";
    }else if ([giftid isEqualToString:@"3"]){
        giftName = @"necklace_00";
    }
    
    return giftName;
}
-(void)animationImageViewStopAnimating:(ChatMessage *)chatMessage{
    self.isAnimationing = NO;
    [[self mutableArrayValueForKey:@"allGiftMessage"] removeObject:chatMessage];
}

-(UIImageView *)animationImageView{
    if(!_animationImageView){
        _animationImageView = [[UIImageView alloc]init];
        [self addSubview:_animationImageView];
//        KWeakSelf;
//        [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(ws.frame.origin.x);
//            make.centerY.mas_equalTo(ws.frame.origin.y);
//        }];
        [_animationImageView setFrame:self.frame];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _animationImageView;
}



/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"allGiftMessage"];
}

@end

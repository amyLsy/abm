//
//  LGJubaoView.m
//  爱发现
//
//  Created by ming on 17/2/8.
//  Copyright © 2017年 ming. All rights reserved.
//

#import "LGJubaoView.h"
#import "AlertTool.h"
@interface LGJubaoView()
@property (weak, nonatomic) IBOutlet UILabel *jubaoLable;
@property (weak, nonatomic) IBOutlet UILabel *cancel;
@property (weak, nonatomic) IBOutlet UIView *jubaoView;

@end
@implementation LGJubaoView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *jubaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jubaoTap)];
    [self.jubaoLable addGestureRecognizer:jubaoTap];
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView:)];
    [self.cancel addGestureRecognizer:cancelTap];
    
    [self addGestureRecognizer:cancelTap];
    
}

- (void)removeView{
    
    [self removeFromSuperview];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self removeView];
//}

+ (void)showView{
    
    UIView *view = [self viewFromeNib];
    view.frame = [UIScreen mainScreen].bounds;
    view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
    }];
 
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    
}
- (void)jubaoTap{
    self.jubaoView.hidden = NO;
    self.jubaoView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
       self.jubaoView.alpha = 1;
    }];
    
    
}

- (IBAction)cancelView:(id)sender {
    [self removeView];
}

- (IBAction)jubaoContent:(id)sender {
     [self removeView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [AlertTool ShowErrorInView:[UIApplication sharedApplication].keyWindow withTitle:@"举报成功"];
    });
    
   
 
    
}


@end

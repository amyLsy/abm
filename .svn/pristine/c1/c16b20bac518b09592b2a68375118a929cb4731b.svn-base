//
//  LGTermsTypeView.m
//  sisitv_ios
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGTermsTypeView.h"
#import "LGUploadTermsModel.h"
#import "LGButtont.h"

@interface LGTermsTypeView()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) LGUploadTermsModel *currentModel;

@end

@implementation LGTermsTypeView


- (NSMutableArray *)btns{
    
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    
    return _btns;
    
}

- (UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupUI];
}



-(void)setupUI{
    
    self.scrollView.frame = self.bounds;
    self.scrollView.width = KScreenWidth;
    [self addSubview:self.scrollView];
    
}

- (void)setTypeStrArray:(NSArray *)typeStrArray{
    
    _typeStrArray = typeStrArray;
    [self layoutIfNeeded];
    [self removeButn];
    CGFloat contenSizeWidth = 0;
    for (int i = 0; i < typeStrArray.count; i ++) {
        
        LGUploadTermsModel *termsModel = typeStrArray[i];
     CGFloat strSizeWidth = [termsModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size.width;
        LGButtont *typeButton = [LGButtont buttonWithType:UIButtonTypeCustom];
        if ([_currentModel.id isEqualToString:termsModel.id]) {
            
            typeButton.selected = YES;
        }
        
        if (_currentModel == nil && i == 0) {
            
            typeButton.selected = YES;
            
        }
        
        [typeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [typeButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        typeButton.object = termsModel;
        strSizeWidth += 20;
        if (self.btns.count >= 1) {
            
            UIButton *btn = self.btns[i - 1];
            typeButton.frame = CGRectMake(CGRectGetMaxX(btn.frame), 0, strSizeWidth, 36);
            [typeButton setTitle:termsModel.name forState:(UIControlStateNormal)];
            contenSizeWidth += typeButton.width;
            [self.btns addObject:typeButton];
            [self.scrollView addSubview:typeButton];
        }else{
            
            typeButton.frame = CGRectMake(0, 0, strSizeWidth, 36);
            [typeButton setTitle:termsModel.name forState:(UIControlStateNormal)];
            [self.btns addObject:typeButton];
            [self.scrollView addSubview:typeButton];
            contenSizeWidth += strSizeWidth;
        }
 
    }
    
    if (contenSizeWidth < KScreenWidth) {
        contenSizeWidth = 0;
         [self removeButn];
        CGFloat btnWidth = KScreenWidth/typeStrArray.count;
        for (int i = 0; i < typeStrArray.count; i ++) {
             LGUploadTermsModel *termsModel = typeStrArray[i];
            LGButtont *typeButton = [LGButtont buttonWithType:UIButtonTypeCustom];
            if ([_currentModel.id isEqualToString:termsModel.id]) {
                
                typeButton.selected = YES;
            }
            if (_currentModel == nil && i == 0) {
                
                typeButton.selected = YES;
                
            }
            [typeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [typeButton addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            typeButton.object = termsModel;
            if (self.btns.count >= 1) {
                
                UIButton *btn = self.btns[i - 1];
                
                typeButton.frame = CGRectMake(CGRectGetMaxX(btn.frame), 0, btnWidth, 36);
                
                
                [typeButton setTitle:termsModel.name forState:(UIControlStateNormal)];
                contenSizeWidth += typeButton.width;
                [self.btns addObject:typeButton];
                [self.scrollView addSubview:typeButton];
            }else{
                
                typeButton.frame = CGRectMake(0, 0, btnWidth, 36);
                [typeButton setTitle:termsModel.name forState:(UIControlStateNormal)];
                [self.btns addObject:typeButton];
                [self.scrollView addSubview:typeButton];
                contenSizeWidth += btnWidth;
            }
            
        }
    }
    

    
    NSLog(@"%f--%f",contenSizeWidth, self.height);
    self.scrollView.contentSize = CGSizeMake(contenSizeWidth, self.height);
    
}


- (void)defaultSelect{
    
    [self didClick:self.btns.firstObject];
    
    
}

- (void)removeButn{
 
    [self.btns removeAllObjects];
    for (LGButtont *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[LGButtont class]]) {
            
            [btn removeFromSuperview];
        }
    }
    
}
    
    
    

- (void)didClick:(LGButtont *)button{
    
    for (UIView *subView in self.scrollView.subviews) {
        
        if ([subView isKindOfClass:[LGButtont class]]) {
            LGButtont *btn = (LGButtont *)subView;
            if (button == btn) {
                btn.selected = YES;
            }else{
                
                btn.selected = NO;
            }
            
        }
        
        
    }
    _currentModel = button.object;
    if (self.delegate) {
        
        [self.delegate termsViewAtionWithType:button headView:self];
    }
    
    
}

@end

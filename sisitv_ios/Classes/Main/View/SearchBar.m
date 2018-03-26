//
//  SearchBar.m
//  TongYouQuan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchBar.h"

@interface SearchBar ()<UITextFieldDelegate>
@property (nonatomic , strong) UIButton  *searhButton;
@end

@implementation SearchBar

-(instancetype)init{
    if (self = [super init]) {
        [self addSearchBar];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:12] ;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.textColor = [UIColor darkGrayColor];
        self.returnKeyType = UIReturnKeySearch;

        self.delegate = self;
        [self addSearchBar];
    }
    return self;
}

-(void)addSearchBar{
    if (self.searhButton) return;
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState: UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState: UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];;
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [searchButton sizeToFit];
    searchButton.width += 20;
    searchButton.contentMode = UIViewContentModeCenter;
    [searchButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.rightView = searchButton;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.searhButton = searchButton;
}

-(void)setPlaceholderString:(NSString *)placeholderString{
    _placeholderString = placeholderString;
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:_placeholderString attributes:@{NSForegroundColorAttributeName:kNavDarkColor}];
    self.attributedPlaceholder = att;
}

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}
//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchButtonClick];
    return YES;
}
-(void)searchButtonClick{
    if (!self.text.length) return;
    self.clickSearchButton();
    [self resignFirstResponder];
}
@end

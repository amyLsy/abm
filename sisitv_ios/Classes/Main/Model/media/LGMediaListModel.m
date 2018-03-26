//
//  LGMediaListModel.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/24.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGMediaListModel.h"

@implementation LGMediaListModel


- (void)parseServerData:(NSDictionary *)responseObject{
    
    [LGMediaListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
       
        return @{@"desc":@"description"};
    }];
    NSArray * model = [LGMediaListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    [self.responseObject addObjectsFromArray:model];
    NSLog(@"测试");
    
}
- (CGFloat)rowHeight{
    
    if (_rowHeight) {
        return _rowHeight;
    }
    
    CGFloat height = 0;
    CGFloat iconHeight = 35;
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    //头像
    height += iconHeight + 2 * 10;
    //中间文字
    CGFloat textHeigint = [_desc boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    height += textHeigint + 10;
    //中间Vew的
    if (_width > 0) {
        
        CGFloat viewW = [UIScreen mainScreen].bounds.size.width - 2 * 10;
        CGFloat viewH = viewW * _height/_width;
        if (_height > [UIScreen mainScreen].bounds.size.height) {
            _is_BigImage = YES;
            viewH = 200;
        }
        _centnViewFrame = CGRectMake(10, height + 10, viewW, viewH);
        height += viewH + 10;
        
    }
    
    height += 35 + 10;
    
    return height;
}

- (BOOL)is_gif{
    
    NSString *ext = self.uri.lowercaseString;
    
    if ([ext isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
    
}
@end

//
//  LGSubCommt.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/11.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGSubCommt.h"
#import "LGComment.h"
#import <MJExtension/MJExtension.h>

@implementation LGSubCommt


+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"sub_comments":[self class]};
}
- (CGFloat)rowHeght{
    //如果行高存在就不需要再次计算行高了
    if (_rowHeght) {
        return _rowHeght;
    }
    
    CGFloat height = 0;
    
    height += 14 + 2 * 5;
    
    height += [self.content boundingRectWithSize:CGSizeMake(KScreenWidth - 3*10 - 2 * 5 - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGFloat timeLableH = 20;
    if ([_sub_comments count] > 0) {
            //存在子评论
            for (LGSubCommt *commtt in self.sub_comments) {
                height += commtt.subHeight + 6;
            }
    }
    
    height += timeLableH +2 * 10 + 5;
    
    _rowHeght = height;
    
    
    
    return _rowHeght;
}

- (CGFloat )subHeight{
    
    if (_rowHeght) {
        return _rowHeght;
    }
    NSString *subComentStr = [NSString stringWithFormat:@"%@:%@",_user_nicename,_content];
    _rowHeght += [subComentStr boundingRectWithSize:CGSizeMake(KScreenWidth - 3*10 - 2 * 5 - 35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    
    return _rowHeght;
}



@end

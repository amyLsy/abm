//
//  BaseItem.m
//  sisitv
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 JLXX-YZG. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem
@synthesize localProcessedUserLevel = _localProcessedUserLevel;

-(void)setUser_level:(NSString *)user_level{
    _user_level = [user_level copy];
    self.localProcessedUserLevel = _user_level;
}
-(void)setLocalProcessedUserLevel:(NSString *)localProcessedUserLevel{
    NSString *userLevel = [localProcessedUserLevel copy];
    if (userLevel.length>0) {
        NSInteger  level = userLevel.integerValue;
        if (level<1) {
            self.userLevelImageName = @"level";
        }else if (level<6) {
            self.userLevelImageName = @"level";
        }else if (level<11) {
            self.userLevelImageName = @"level";
        }else if (level<16) {
            self.userLevelImageName = @"level";
        }else if (level<21) {
            self.userLevelImageName = @"level";
        }else if (level<31) {
            self.userLevelImageName = @"level";
        }else if (level<41) {
            self.userLevelImageName = @"level";
        }else{
            self.userLevelImageName = @"level";
        }
        _localProcessedUserLevel = [NSString stringWithFormat:@"%@",userLevel];
    }else{
        self.userLevelImageName = @"grade";
        _localProcessedUserLevel = @"1";
    }
}

-(NSString *)localProcessedUserLevel{
    if (!_localProcessedUserLevel) {
        self.userLevelImageName = @"level";
        return @"1";
    }
    return _localProcessedUserLevel;
}

-(void)setSex:(NSString *)sex{
    _sex = [sex copy];
    if ([_sex isEqualToString:@"1"]) {
        _sex = @"boy";
    }else if([_sex isEqualToString:@"2"]|| [_sex isEqualToString:@"0"]){
        _sex =@"nv";
    }
}


-(void)setAttention_status:(NSString *)attention_status{
    _attention_status = [attention_status copy];
    if (_attention_status.integerValue ==1 ||[_attention_status isEqualToString:@"已关注"]) {
        _attention_status=@"已关注";
        self.attentionStatusColor = [UIColor colorWithHexString:@"d3d3d3"];
        self.attentionStatusImageName = nil;
    }else if (_attention_status.integerValue ==0 ||[_attention_status isEqualToString:@"关注"]) {
        _attention_status=@"关注";
        self.attentionStatusColor = [UIColor colorWithHexString:@"ffc000"];
        self.attentionStatusImageName = @"加关注";
    }
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end

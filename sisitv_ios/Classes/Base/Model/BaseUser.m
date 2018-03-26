//
//  BaseUser.m
//  sisitv_ios
//
//  Created by apple on 17/1/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "BaseUser.h"

@implementation BaseUser

-(void)setMobile_status:(NSString *)mobile_status{
    _mobile_status = [mobile_status copy];
    if (_mobile_status.integerValue ==1) {
        _mobile_status=@"已绑定";
        self.mobileStatusColor = [UIColor colorWithHexString:@"c3c3c3"];
    }else{
        _mobile_status=@"未绑定";
        self.mobileStatusColor = [UIColor colorWithHexString:@"e82262"];
    }
}

-(void)setChannel_status:(NSString *)channel_status{
    _channel_status = [channel_status copy];
    if (_channel_status.integerValue ==1) {
        _channel_status = @"未直播";
    }else if (_channel_status.integerValue ==2){
        _channel_status = @"正在直播";
    }
}


-(void)setIs_truename:(NSString *)is_truename{
    _is_truename = [is_truename copy];
    if ([_is_truename isEqualToString:@"0"]) {
        _is_truename = @"未实名";
    }else if([_is_truename isEqualToString:@"1"]){
        _is_truename = @"已实名";
    }else{
        _is_truename = @"认证失败";
    }
}


-(NSString *)location{
    if (!_location || [_location isEqual: [NSNull null]] || !_location.length) {
        _location = @"未知";
    }
    return _location;
}

-(NSString *)signature{
    if ( !_signature ||[_signature isKindOfClass:[NSNull class]] || !_signature.length) {
        _signature = @"暂无个性签名.";
    }
    return _signature;
}

-(NSString *)total_spend{
    if (!_total_spend.length||![_total_spend isKindOfClass:[NSString class]]) {
        _total_spend = @"0";
    }
    return _total_spend;
}
//@synthesize total_spend = _total_spend;

-(NSString *)balance{
    if (!_balance|| [_balance isKindOfClass:[NSNull class]]  || !_balance.length) {
        _balance = @"0";
    }
    return _balance;
}

-(void)setMobile:(NSString *)mobile{
    _mobile = mobile;
    if (!_mobile|| [_mobile isKindOfClass:[NSNull class]]  || !_mobile.length) {
        _mobile = @"未填写";
    }
}
@end

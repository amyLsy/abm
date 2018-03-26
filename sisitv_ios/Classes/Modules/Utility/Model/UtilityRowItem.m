//
//  UtilityRowItem.m
//  xiuPai
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "UtilityRowItem.h"

@implementation UtilityRowItem
 

-(void)setChannel_status:(NSString *)channel_status{
    _channel_status = [channel_status copy];
    if (_channel_status.integerValue == 2) {
        _channel_status=@"[直播中] ";
    }else if (_channel_status.integerValue ==0 ||_channel_status.integerValue ==1) {
        _channel_status=@" ";
    }
}
-(NSString *)signature{
    if ( !_signature ||[_signature isKindOfClass:[NSNull class]] || !_signature.length) {
        _signature = @"暂无个性签名.";
    }
    return _signature;
}
@end

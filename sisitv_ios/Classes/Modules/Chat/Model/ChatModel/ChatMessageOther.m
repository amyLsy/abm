//
//  ChatMessageOther.m
//  sisitv
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "ChatMessageOther.h"

@implementation ChatMessageOther

+(instancetype)other{
    
    return [[self.class alloc]init];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"giftInfo = %@ totalEarn = %@",self.giftInfo,self.totalEarn];
}
@end

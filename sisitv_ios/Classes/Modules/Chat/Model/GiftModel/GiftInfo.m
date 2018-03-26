//
//  GiftInfo.m
//  sisitv
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "GiftInfo.h"

@implementation GiftInfo


-(NSString *)description{
    return [NSString stringWithFormat:@"giftname = %@ needcoin = %@ giftid = %@ gifticon = %@ continuous = %@ containuousNum = %@",self.giftname,self.needcoin,self.giftid,self.gifticon,self.continuous,self.continuousNum];
}

@end

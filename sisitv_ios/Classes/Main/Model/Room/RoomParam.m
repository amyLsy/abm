//
//  RoomParam.m
//  sisitv
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 JLXXYZG. All rights reserved.
//

#import "RoomParam.h"

@implementation RoomParam

-(instancetype)initWithToken:(NSString *)token withRoomId:(NSString *)room_id{
    if (self = [super init]) {
        self.token = token;
        self.room_id = room_id;
    }
    return self;
}

+(instancetype)roomParam{
    
    return [[self alloc]init];
}
@end

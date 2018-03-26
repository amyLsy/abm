//
//  ChatMessage.m
//  liveFrame
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

-(instancetype)init{
    
    if (self = [super init]) {
        self.type = ChatNomalMessage;
    }
    return self;
}

-(instancetype)initWithUserName:(NSString *)userName content:(NSString *)content userId:(NSString *)userId userLevel:(NSString *)userLevel avatar:(NSString *)avatar{
    if (self = [super init]) {
        self.type = ChatNomalMessage;
        self.content = content;
        self.userName = userName;
        self.userLevel = userLevel;
        self.userId = userId;
        self.avatar = avatar;
    }
    return self;
}

+(instancetype)chatMessage{
    return [[self.class alloc]init];
}

-(void)setUserLevel:(NSString *)userLevel{
    _userLevel = [userLevel copy];
    self.localProcessedUserLevel = _userLevel;
}

-(NSString *)description{
       return [NSString stringWithFormat:@"content = %@ userName = %@( userLevel = )%@( userId = )%@ avatar = %@ other = %@",_content,_userName,_userLevel,_userId,self.avatar,self.other];
 }

@end

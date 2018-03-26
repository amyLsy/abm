//
//  YZGSingleton.m
//  sisitv_ios
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGSingleton.h"
static NSMutableDictionary *_yzgSharedInstances = nil;

@implementation YZGSingleton
#pragma mark -

+ (void)initialize
{
    if (_yzgSharedInstances == nil) {
        _yzgSharedInstances = [NSMutableDictionary dictionary];
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    // Not allow allocating memory in a different zone
    return [self sharedInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    // Not allow copying to a different zone
    return [self sharedInstance];
}

#pragma mark -

+ (instancetype)sharedInstance
{
    id sharedInstance = nil;
    @synchronized(self) {
        NSString *instanceClass = NSStringFromClass(self);
        
        // Looking for existing instance
        sharedInstance = [_yzgSharedInstances objectForKey:instanceClass];
        
        // If there's no instance – create one and add it to the dictionary
        if (sharedInstance == nil) {
            sharedInstance = [[super allocWithZone:nil] init];
            [_yzgSharedInstances setObject:sharedInstance forKey:instanceClass];
        }
    }
    
    return sharedInstance;
}

+ (instancetype)instance
{
    return [self sharedInstance];
}

#pragma mark -

+ (void)destroyInstance
{
    [_yzgSharedInstances removeObjectForKey:NSStringFromClass(self)];
}

#pragma mark -

- (id)init
{
    self = [super init];
    
    if (self && !self.isInitialized) {
        // Thread-safe because it called from +sharedInstance
        _isInitialized = YES;
    }
    
    return self;
}

@end

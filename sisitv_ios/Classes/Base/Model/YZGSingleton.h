//
//  YZGSingleton.h
//  sisitv_ios
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGSingleton : NSObject
/// @name Obtaining the Shared Instance

/**
 Returns the shared instance of the receiver class, creating it if necessary.
 
 You shoudn't override this method in your subclasses.
 
 @return Shared instance of the receiver class.
 */
+ (instancetype)sharedInstance;

/**
 `sharedInstance` alias.
 
 @return Shared instance of the receiver class.
 */
+ (instancetype)instance;

/// @name Destroy Singleton Instance

/**
 Destroys shared instance of singleton class (if there are no other references to that instance).
 
 @warning *Note:* calling `+sharedInstance` after calling this method will create new singleton instance.
 */
+ (void)destroyInstance;

/// @name Testing Singleton Initialization

/**
 A Boolean value that indicates whether the receiver has been initialized.
 
 This property is usefull if you make you own initializer or override `-init` method.
 You should check if your singleton object has already been initialized to prevent repeated initialization in your custom initializer.
 
 @warning *Important:* you should check whether your instance already initialized before calling `[super init]`.
 
	- (id)init
	{
 if (!self.isInitialized) {
 self = [super init];
 
 if (self) {
 // Initialize self.
 }
 }
 
 return self;
	}
 */
@property (assign, readonly) BOOL isInitialized;
@end

//
//  AFBlipUserModelSingleton.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"

NSString* const kAFBlipsUserNotificationPreferenceToggle       = @"kAFBlipsUserNotificationPreferenceToggle";
NSString* const kAFBlipsUserNotificationNotificationRegister   = @"kAFBlipsUserNotificationNotificationRegister";
NSString* const kAFBlipsUserNotificationNotificationUnRegister = @"kAFBlipsUserNotificationNotificationUnRegister";

@implementation AFBlipUserModelSingleton

#pragma mark - Reset
- (void)resetUserModel {
    
    _userModel = nil;
}

#pragma mark - Setters
- (void)updateUserModelWithUserModel:(AFBlipUserModel *)model {
    
    _userModel = model;
}

#pragma mark - Singleton instance
+ (AFBlipUserModelSingleton *)sharedUserModel {
    
    static dispatch_once_t pred;
    static AFBlipUserModelSingleton *_singletonInstance = nil;
    
    dispatch_once(&pred, ^{
        _singletonInstance = [[AFBlipUserModelSingleton alloc] init];
    });
    
	return _singletonInstance;
}

@end

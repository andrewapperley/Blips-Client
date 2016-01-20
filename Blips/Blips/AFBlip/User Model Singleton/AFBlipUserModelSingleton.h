//
//  AFBlipUserModelSingleton.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kAFBlipsUserNotificationPreferenceToggle;
extern NSString* const kAFBlipsUserNotificationNotificationRegister;
extern NSString* const kAFBlipsUserNotificationNotificationUnRegister;

@class AFBlipUserModel;

@interface AFBlipUserModelSingleton : NSObject

@property (nonatomic, strong, readonly) AFBlipUserModel *userModel;

+ (AFBlipUserModelSingleton *)sharedUserModel;

- (void)updateUserModelWithUserModel:(AFBlipUserModel *)model;
- (void)resetUserModel;

@end

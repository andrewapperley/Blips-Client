//
//  AFPlatformUtility.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFPlatformUtility : NSObject

/** Returns the device name such as "My iPhone". */
+ (NSString *)deviceName;

/** Returns the device model such as "iPhone" or "iPod touch". */
+ (NSString *)deviceModel;

/** Returns the device model as a localized string such as "iPhone" or "iPod touch". */
+ (NSString *)deviceModelLocalized;

/** Returns the device OS such as "iOS". */
+ (NSString *)deviceOS;

/** Returns the device OS version such as "4.0". */
+ (NSString *)deviceOSVersion;

/** Returns the device platform string such as "iPhone 1G". */
+ (NSString *)platformString;

/** Returns the device platform string such as "iPhone1,1". */
+ (NSString *)platform;

/** Returns if the device is on the blacklist or not. */
+ (BOOL)isSupported:(NSArray *)blacklist;


@end
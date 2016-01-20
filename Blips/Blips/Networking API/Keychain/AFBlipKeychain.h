//
//  AFBlipKeychain.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/1/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipKeychain : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, strong) NSString *userName;

#pragma mark - Expiry Date Checking
- (BOOL)accessTokenValid;

#pragma mark - Saving
- (void)setAccessToken:(NSString *)accessToken expiryDate:(NSString *)expiryDate userName:(NSString *)userName;

#pragma mark - Reset
- (void)resetKeychain;

#pragma mark - Singleton
+ (instancetype)keychain;

@end

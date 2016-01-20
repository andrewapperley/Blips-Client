//
//  AFBlipKeychain.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/1/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipKeychain.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import "AFBlipBaseNetworkStatics.h"
#import "AFBlipDateFormatter.h"
#import <Security/Security.h>

//Keys
NSString *const kIdentityTokenIdentifier = @"com.apple.%@.UbiquityIdentityToken";
NSString *const kBundleKeyName           = @"CFBundleName";

//Access Token handling
NSString *const kAFBlipAccessToken                    = @"userAccessToken";
NSString *const kAFBlipAccessTokenExpiry              = @"userAccessTokenExpiry";
NSString *const kAFBlipAccessUsername                 = @"userAccessUsername";

static NSDate* _staticExpiryDate;
static NSDate* _staticCurrentDate;

@implementation AFBlipKeychain

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        
        [self registerForNotifications];
        [self loadiCloudToken];
        [self loadAccessToken];
    }
    return self;
}

#pragma mark - Register for notifications
- (void)registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudAccountAvailabilityChanged:)name:NSUbiquityIdentityDidChangeNotification object:nil];
}

#pragma mark - Access token
- (void)setAccessToken:(NSString *)accessToken expiryDate:(NSString *)expiryDate userName:(NSString *)userName {
    
    _accessToken    = accessToken;
    _expiryDate     = expiryDate;
    _userName       = userName;
    [SSKeychain setPassword:accessToken forService:kAFBlipAccessToken account:iCloudTokenName()];
    [SSKeychain setPassword:expiryDate forService:kAFBlipAccessTokenExpiry account:iCloudTokenName()];
    [SSKeychain setPassword:userName forService:kAFBlipAccessUsername account:iCloudTokenName()];
}

- (BOOL)accessTokenValid {
    return ((_accessToken && _expiryDate) && [self accessTokenNotExpired]);
}

- (BOOL)accessTokenNotExpired {
    
    AFBlipDateFormatter *expiryDateFormatter = [AFBlipDateFormatter expiryDateFormat];

    _staticExpiryDate                      = [expiryDateFormatter dateFromString:_expiryDate];
    _staticCurrentDate                     = [expiryDateFormatter dateFromString:[expiryDateFormatter stringFromDate:[NSDate date]]];
    
    return ([[_staticExpiryDate earlierDate:_staticCurrentDate] isEqualToDate:_staticCurrentDate]);
}

- (void)loadAccessToken {
    
    _accessToken    = [SSKeychain passwordForService:kAFBlipAccessToken account:iCloudTokenName()];
    _expiryDate     = [SSKeychain passwordForService:kAFBlipAccessTokenExpiry account:iCloudTokenName()];
    _userName       = [SSKeychain passwordForService:kAFBlipAccessUsername account:iCloudTokenName()];
}

- (void)iCloudAccountAvailabilityChanged:(NSNotification *)notification {
    BOOL accountStillActive = NO;
    
    for (NSDictionary* account in [SSKeychain allAccounts]) {
        if ([account[@"acct"] isEqualToString:iCloudTokenName()]) {
            accountStillActive = YES;
        }
    }
    if (!accountStillActive) {
        _accessToken    = nil;
        _expiryDate     = nil;
    }
}

#pragma mark - iCloud token handling
#pragma mark - Retrieve token 
- (void)loadiCloudToken {
    [self loadAccessToken];
}

#pragma mark - Utility methods
#pragma mark - iCloud token name
NSString *iCloudTokenName(void) {
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleKeyName];
    NSString *tokenName = [NSString stringWithFormat:kIdentityTokenIdentifier, appName];
    
    return tokenName;
}

#pragma mark - Reset keychain
- (void)resetKeychain {
    
    _accessToken = nil;
    _userName    = nil;
    _expiryDate  = nil;
    [SSKeychain deletePasswordForService:kAFBlipAccessToken account:iCloudTokenName()];
    [SSKeychain deletePasswordForService:kAFBlipAccessTokenExpiry account:iCloudTokenName()];
    [SSKeychain deletePasswordForService:kAFBlipAccessUsername account:iCloudTokenName()];
}

#pragma mark - Singleton instance
+ (instancetype)keychain {
    static dispatch_once_t pred;
    static AFBlipKeychain *_singletonInstance = nil;
    
    dispatch_once(&pred, ^{
        _singletonInstance = [[AFBlipKeychain alloc] init];
    });
    
	return _singletonInstance;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

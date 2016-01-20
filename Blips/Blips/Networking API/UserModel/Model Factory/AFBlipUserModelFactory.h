//
//  AFBlipUserModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"
#import "AFBlipUserModel.h"
#import "AFBlipLimitedProfileModel.h"

typedef void(^AFBlipUserLoginSuccess)(AFBlipUserModel *userModel, NSString *accessToken, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUserModelSuccess)(AFBlipUserModel *userModel, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUserCreationSuccess)(AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUserSearchSuccess)(NSArray* searchResults, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUserLimitedProfileSuccess)(AFBlipLimitedProfileModel* limitedProfileModel, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUsernameAvailabilitySuccess)(AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipUserUpdateTokenSuccess)(NSString *accessToken, AFBlipBaseNetworkModel *networkCallback);

@interface AFBlipUserModelFactory : NSObject

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserId:(NSString *)userId friendUserId:(NSString *)friendUserId accessToken:(NSString *)accessToken success:(AFBlipUserModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - User login / fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipUserLoginSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - User logout
- (void)fetchLogoutUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Deactivate user
- (void)fetchDeactivateUserId:(NSString *)userId password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Create user
- (void)createUserWithUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipUserCreationSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Update user
- (void)updateUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken displayName:(NSString *)displayName password:(NSString *)password email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipUserModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFBlipUsernameAvailabilitySuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Update token
- (void)fetchUserUpdateTokenWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipUserUpdateTokenSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Search users
- (void)fetchUsersBySearchingWithSearchTerm:(NSString *)searchQuery userID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipUserSearchSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Limited User Profile
- (void)fetchLimitedUserProfileForUser:(NSString *)user userID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipUserLimitedProfileSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove friend
- (void)removeFriendWithUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Reset Password
- (void)resetPasswordWithEmail:(NSString *)email success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end
//
//  AFBlipUserModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkDatasource.h"

@interface AFBlipUserModelDatasource : AFBlipBaseNetworkDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserId:(NSString *)userId friendUserId:(NSString *)friendUserId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - User login
- (void)postLoginUserWithUsername:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - User logout
- (void)postLogoutUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Create user
- (void)postCreateUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Update user
- (void)postUpdateUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken displayName:(NSString *)displayName password:(NSString *)password email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Deactivate user
- (void)postDeactivateUserId:(NSString *)userId password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Update token
- (void)postUpdateTokenWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Search Users
- (void)fetchUsersBySearchingWithSearchTerm:(NSString *)searchQuery userID:(NSString *)userID accessToken:(NSString *)accessToken  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Limited User Profile
- (void)fetchLimitedUserProfileForUser:(NSString *)user userID:(NSString *)userID accessToken:(NSString *)accessToken  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove friend
- (void)postRemoveFriendWithUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Reset Password
- (void)resetPasswordWithEmail:(NSString *)email success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end
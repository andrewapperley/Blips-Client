//
//  AFBlipUserModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipUserModelDatasource.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipUserModel.h"
#import "AFHash.h"

//User model endpoint
NSString *kAFBlipUserModelEndpointURL                     = @"/user/info";
NSString *kAFBlipUserModelParameterKeyUserName            = @"username";
NSString *kAFBlipUserModelParameterKeyUserID              = @"user_id";
NSString *kAFBlipUserModelParameterKeyAcessToken          = @"access_token";
NSString *kAFBlipUserModelParameterKeyEmail               = @"email";
NSString *kAFBlipUserModelParameterKeyProfileImage        = @"profile_image";
NSString *kAFBlipUserModelParameterKeyDisplayName         = @"display_name";

//Create user endpoint
NSString *kAFBlipCreateUserModelEndpointURL               = @"/user/";

//Update user endpoint
NSString *kAFBlipUpdateUserModelEndpointURL               = @"/user/updateUser/";
NSString *kAFBlipUpdateUserModelParameterKeyChanges       = @"changes";

//User login endpoint
NSString *kAFBlipUserLoginEndpointURL                     = @"/user/login/";
NSString *kAFBlipUserModelParameterKeyPassword            = @"password";

//User logout endpoint
NSString *kAFBlipUserLogoutEndpointURL                    = @"/user/logout/";

//Username check endpoint
NSString *kAFBlipUserNameCheckEndpointURL                 = @"/user/check_username";

//Deactivate user endpoint
NSString *kAFBlipDeactivateUserEndpointURL                = @"/user/removeUser/";

//Search users endpoint
NSString *kAFBlipsSearchUsersEndpointURL                  = @"/user/search/";
NSString *kAFBlipUserModelParameterKeySearchQuery         = @"search_query";

//Limited Profile endpoint
NSString *kAFBlipsLimitedProfileEndpointURL               = @"/user/limited/";
NSString *kAFVDUserModelParameterKeyLimitedProfile        = @"user";

//Remove friend
NSString *kAFBlipRemoveConnectionEndpointURL              = @"/user/remove_connection/";
NSString *kAFBlipRemoveConnectionParameterKeyConnectionId = @"connection_id";

//Reset Password
NSString *kAFBlipResetPasswordEndpointURL                 = @"/user/reset_password/";

@implementation AFBlipUserModelDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserId:(NSString *)userId friendUserId:(NSString *)friendUserId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userId,
                                 kAFVDUserModelParameterKeyLimitedProfile : friendUserId,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipUserModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User login
- (void)postLoginUserWithUsername:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{kAFBlipUserModelParameterKeyUserName : userName,
                                         kAFBlipUserModelParameterKeyPassword : hashed_password(password)}];
    
    if(accessToken) {
        [parameters setObject:accessToken forKey:kAFBlipUserModelParameterKeyAcessToken];
    }
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipUserLoginEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User logout
- (void)postLogoutUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userId,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipUserLogoutEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create User
- (void)postCreateUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserName : userName,
                                 kAFBlipUserModelParameterKeyDisplayName : displayName,
                                 kAFBlipUserModelParameterKeyPassword : hashed_password(password),
                                 kAFBlipUserModelParameterKeyEmail : email};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipCreateUserModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            if(profileImage) {
                
                AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
                [imageFactory setObjectWithData:profileImage forKey:networkCallback.responseData[kAFBlipUserModelParameterKeyProfileImage] completion:^{
                    success(networkCallback);
                } failure:^(NSError *error) {
                    success(networkCallback);
                }];
            } else {
                success(networkCallback);
            }
        } else {
            failure(nil);
        }

    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Update user
- (void)postUpdateUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken displayName:(NSString *)displayName password:(NSString *)password email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSMutableDictionary *changes = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if(displayName) {
        [changes setObject:displayName forKey:kAFBlipUserModelParameterKeyDisplayName];
    }

    if(password) {
        [changes setObject:hashed_password(password) forKey:kAFBlipUserModelParameterKeyPassword];
    }

    if(email) {
        [changes setObject:email forKey:kAFBlipUserModelParameterKeyUserName];
    }

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userId, kAFBlipUserModelParameterKeyUserID, accessToken, kAFBlipUserModelParameterKeyAcessToken, nil];
    if(changes && changes.allKeys.count > 0 && changes.allValues.count > 0) {
        [parameters setObject:changes forKey:kAFBlipUpdateUserModelParameterKeyChanges];
    }
    
    if ((!displayName || !password || !email) && profileImage) {
        AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
        [imageFactory setObjectWithData:profileImage forKey:[AFBlipUserModelSingleton sharedUserModel].userModel.userImageUrl completion:^{
            success(nil);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipUpdateUserModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
            
            if (networkCallback.success) {
                if (password) {
                    NSString* newAccessToken = networkCallback.responseData[@"access_token"];
                    NSString* expiryDate     = networkCallback.responseData[@"expiry_date"];
                    if (![newAccessToken isEqualToString:@""] && ![expiryDate isEqualToString:@""]) {
                        [[AFBlipKeychain keychain] setAccessToken:newAccessToken expiryDate:expiryDate userName:[AFBlipUserModelSingleton sharedUserModel].userModel.userName];
                    }
                }
                
                if (profileImage) {
                    
                    AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
                    [imageFactory setObjectWithData:profileImage forKey:networkCallback.responseData[@"User"][@"profile_image"] completion:^{
                        success(networkCallback);
                    } failure:^(NSError *error) {
                        success(networkCallback);
                    }];
                    
                } else {
                    success(networkCallback);
                }
                
            } else {
                failure(nil);
            }
            
        } failure:^(NSError *error) {
            
            failure(error);
        }];
    }

}

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserName : userName};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipUserNameCheckEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Deactivate user
- (void)postDeactivateUserId:(NSString *)userId password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{kAFBlipUserModelParameterKeyUserID : userId,
                                         kAFBlipUserModelParameterKeyPassword : hashed_password(password),
                                         kAFBlipUserModelParameterKeyAcessToken : accessToken}];
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipDeactivateUserEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Update token
- (void)postUpdateTokenWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userId,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipDeactivateUserEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Search Users
- (void)fetchUsersBySearchingWithSearchTerm:(NSString *)searchQuery userID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userID,
                                 kAFBlipUserModelParameterKeySearchQuery : searchQuery,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipsSearchUsersEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Limited User Profile
- (void)fetchLimitedUserProfileForUser:(NSString *)user userID:(NSString *)userID accessToken:(NSString *)accessToken  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userID,
                                 kAFVDUserModelParameterKeyLimitedProfile : user,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipsLimitedProfileEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove friend
- (void)postRemoveFriendWithUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserID : userId,
                                 kAFBlipRemoveConnectionParameterKeyConnectionId : connectionId,
                                 kAFBlipUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipRemoveConnectionEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Reset Password
- (void)resetPasswordWithEmail:(NSString *)email success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    NSDictionary *parameters = @{kAFBlipUserModelParameterKeyUserName : email};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipResetPasswordEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end
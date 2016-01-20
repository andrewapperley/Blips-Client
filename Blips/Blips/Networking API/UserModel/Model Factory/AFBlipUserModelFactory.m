//
//  AFBlipUserModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipUserModelDatasource.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipKeychain.h"

@implementation AFBlipUserModelFactory

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserId:(NSString *)userId friendUserId:(NSString *)friendUserId accessToken:(NSString *)accessToken success:(AFBlipUserModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource fetchUserModelWithUserId:userId friendUserId:friendUserId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipUserModel *model;
            
            if(networkCallback.success) {
                model = [AFBlipUserModelFactory userModelForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(model, networkCallback);
            });
        });
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - User login / fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipUserLoginSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    typeof(userName) __block newUsername = userName;
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postLoginUserWithUsername:userName password:password accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipUserModel *model;
            NSString *newAccessToken;
            NSString *expiryDate;
            
            if(networkCallback.success) {
                model          = [AFBlipUserModelFactory userModelForData:networkCallback.responseData];
                newAccessToken = networkCallback.responseData[@"access_token"];
                expiryDate     = networkCallback.responseData[@"expiry_date"];
                [[AFBlipKeychain keychain] setAccessToken:newAccessToken expiryDate:expiryDate userName:newUsername];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(model, newAccessToken, networkCallback);
            });
        });

    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User logout
- (void)fetchLogoutUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postLogoutUserWithUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Deactivate user
- (void)fetchDeactivateUserId:(NSString *)userId password:(NSString *)password accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postDeactivateUserId:userId password:password accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create user
- (void)createUserWithUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipUserCreationSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postCreateUsername:userName password:password displayName:displayName email:email profileImage:profileImage success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Update user
- (void)updateUserWithUserId:(NSString *)userId accessToken:(NSString *)accessToken displayName:(NSString *)displayName password:(NSString *)password email:(NSString *)email profileImage:(NSData *)profileImage success:(AFBlipUserModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postUpdateUserWithUserId:userId accessToken:accessToken displayName:displayName password:password email:email profileImage:profileImage success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        AFBlipUserModel* userModel = [AFBlipUserModelFactory userModelForData:networkCallback.responseData];
        
        success(userModel, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFBlipUsernameAvailabilitySuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource checkIfUsernameIsAvailable:userName success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        BOOL isUsernameAvailable = networkCallback.success;
        
        if(isUsernameAvailable) {
            success(networkCallback);
        } else {
            failure(nil);
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Update token
- (void)fetchUserUpdateTokenWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipUserUpdateTokenSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource postUpdateTokenWithUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *accessToken;
            
            if(networkCallback.success) {
                accessToken = networkCallback.responseData[@"access_token"];
                [AFBlipKeychain keychain].accessToken = accessToken;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(accessToken, networkCallback);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Search Users
- (void)fetchUsersBySearchingWithSearchTerm:(NSString *)searchQuery userID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipUserSearchSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
        
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource fetchUsersBySearchingWithSearchTerm:searchQuery userID:userID accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray* searchResults = [[NSMutableArray alloc] init];
            for (NSDictionary* user in networkCallback.responseData[@"users"]) {
                [searchResults addObject:[AFBlipUserModelFactory userModelForData:user]];

            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(searchResults, networkCallback);
            });
        });
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Limited User Profile
- (void)fetchLimitedUserProfileForUser:(NSString *)user userID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipUserLimitedProfileSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    
    [dataSource fetchLimitedUserProfileForUser:user userID:userID accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success([AFBlipUserModelFactory limitedUserModelForData:networkCallback.responseData], networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Remove friend
- (void)removeFriendWithUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    
    [dataSource postRemoveFriendWithUserId:userId connectionId:connectionId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        if(success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

#pragma mark - Reset Password
- (void)resetPasswordWithEmail:(NSString *)email success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipUserModelDatasource *dataSource = [[AFBlipUserModelDatasource alloc] init];
    [dataSource resetPasswordWithEmail:email success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Limited User model
+ (AFBlipLimitedProfileModel *)limitedUserModelForData:(NSDictionary *)data {
    
    AFBlipLimitedProfileModel *model = [[AFBlipLimitedProfileModel alloc] init];
    
    NSDictionary *userDictionary = data[@"user"];
    
    //User info
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"user_id"] forKey:@"user_id"];
    [model setValue:userDictionary[@"profile_image"] forKey:@"userImageUrl"];
    [model setValue:userDictionary[@"display_name"] forKey:@"displayName"];
    
    BOOL isDeactivated = [userDictionary[@"deactivated"] boolValue];
    model.isDeactivated = isDeactivated;
    
    NSInteger videoCount = [userDictionary[@"video_count"] integerValue];
    model.videosCount = videoCount;
    
    NSInteger connectionCount = [userDictionary[@"connection_count"] integerValue];
    model.connectionsCount = connectionCount;
    
    return model;
}

#pragma mark - User model
+ (AFBlipUserModel *)userModelForData:(NSDictionary *)data {
    
    AFBlipUserModel *model = [[AFBlipUserModel alloc] init];
    
    NSDictionary *userDictionary = data[@"User"];
    if (!userDictionary) {
        userDictionary = data;
    }
    
    //User info
    id userIdValue = userDictionary[@"user_id"];
    
    if(userIdValue) {
        //Check if string type
        if([userIdValue isKindOfClass:[NSString class]]) {
            [model setValue:userIdValue forKey:@"user_id"];
            
        //Check if number type
        } else if([userIdValue isKindOfClass:[NSNumber class]]) {
            NSString *userIdString = [NSString stringWithFormat:@"%ld", (long)[userIdValue integerValue]];
            [model setValue:userIdString forKey:@"user_id"];
        }
    }
    
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"profile_image"] forKey:@"userImageUrl"];
    [model setValue:userDictionary[@"display_name"] forKey:@"displayName"];

    BOOL isDeactivated = [userDictionary[@"deactivated"] boolValue];
    model.isDeactivated = isDeactivated;
    
    return model;
}

@end

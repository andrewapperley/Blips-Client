//
//  AFBlipNotificationsDatasource.m
//  Blips
//
//  Created by Andrew Apperley on 2014-06-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipNotificationsDatasource.h"
#import "AFBlipUserModel.h"

//Notifications registration endpoint
NSString *kAFBlipNotificationsDatasource_RegisterEndpointURL            = @"/notification/register/";
NSString *kAFBlipNotificationsDatasource_UnregisterEndpointURL          = @"/notification/unregister/";
NSString *kAFBlipNotificationsDatasource_ParameterKeyAccessToken        = @"access_token";
NSString *kAFBlipNotificationsDatasource_ParameterKeyUserID             = @"user_id";
NSString *kAFBlipNotificationsDatasource_ParameterKeyToken              = @"unique_token";

//Notification list endpoint
NSString *kAFBlipNotificationsDatasource_ListEndpointURL                = @"/notification/list/";

//Notification as read endpoint
NSString *kAFBlipNotificationsDatasource_NotificationsAsReadEndpointURL = @"/notification/read/";
NSString *kAFBlipNotificationsDatasource_ParameterKeyNotificationUserId = @"sender_id";

@implementation AFBlipNotificationsDatasource

- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {

    if(!uniqueToken || !userId || !accessToken) {
        return;
    }
    
    NSDictionary *params = @{kAFBlipNotificationsDatasource_ParameterKeyToken: uniqueToken,
                             kAFBlipNotificationsDatasource_ParameterKeyUserID: userId,
                             kAFBlipNotificationsDatasource_ParameterKeyAccessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipNotificationsDatasource_RegisterEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)unregisterForNotificationsWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    if(!userId || !accessToken) {
        return;
    }
    
    NSDictionary *params = @{kAFBlipNotificationsDatasource_ParameterKeyUserID: userId,
                             kAFBlipNotificationsDatasource_ParameterKeyAccessToken:accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipNotificationsDatasource_UnregisterEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)notificationCountForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *params = @{kAFBlipNotificationsDatasource_ParameterKeyUserID : userId,
                             kAFBlipNotificationsDatasource_ParameterKeyAccessToken : accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipNotificationsDatasource_ListEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)markNotificationAsReadForNotificationUserId:(NSString *)notificationUserId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {

    NSDictionary *params = @{kAFBlipNotificationsDatasource_ParameterKeyNotificationUserId : notificationUserId,
                             kAFBlipNotificationsDatasource_ParameterKeyUserID : userId,
                             kAFBlipNotificationsDatasource_ParameterKeyAccessToken : accessToken};

    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipNotificationsDatasource_NotificationsAsReadEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
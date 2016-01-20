//
//  AFBlipConnectionModelDatasource.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionModelDatasource.h"

NSString* kConnectionModelCreateConnectionEndpoint          = @"/user/connection/";
NSString* kConnectionModelChangeConnectionStatusEndpoint    = @"/user/connection_status_change";
NSString* kConnectionModelGetConnectionsEndpoint            = @"/user/connections/";
NSString* kConnectionModelGetConnectionFromTimelineEndpoint = @"/user/connection/timeline/";


NSString* kConnectionModelParameterKeyUserID                = @"user_id";
NSString* kConnectionModelParameterKeyAcessToken            = @"access_token";
NSString* kConnectionModelParameterKeyUser2                 = @"user2";
NSString* kConnectionModelParameterKeyTimelineID            = @"timeline_id";
NSString* kConnectionModelParameterKeyConnectionID          = @"connection_id";
NSString* kConnectionModelParameterKeyStatus                = @"status";

@implementation AFBlipConnectionModelDatasource

- (void)createConnectionWithUserID:(NSString *)userID friendsUserID:(NSString *)friendsUserID accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary* params = @{kConnectionModelParameterKeyUserID: userID,
                             kConnectionModelParameterKeyUser2: friendsUserID,
                             kConnectionModelParameterKeyAcessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kConnectionModelCreateConnectionEndpoint parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        success(networkCallback);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

- (void)changeConnectionStatusWithUserID:(NSString *)userID connectionID:(NSString *)connectionID status:(BOOL)status accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary* params = @{kConnectionModelParameterKeyUserID: userID,
                             kConnectionModelParameterKeyConnectionID: connectionID,
                             kConnectionModelParameterKeyStatus: @(status),
                             kConnectionModelParameterKeyAcessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kConnectionModelChangeConnectionStatusEndpoint parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        success(networkCallback);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

- (void)connectionListWithUserID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary* params = @{kConnectionModelParameterKeyUserID: userID,
                             kConnectionModelParameterKeyAcessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kConnectionModelGetConnectionsEndpoint parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        success(networkCallback);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

- (void)connectionWithUserID:(NSString *)userID accessToken:(NSString *)accessToken timelineID:(NSString *)timelineID success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary* params = @{kConnectionModelParameterKeyUserID: userID,
                             kConnectionModelParameterKeyTimelineID: timelineID,
                             kConnectionModelParameterKeyAcessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kConnectionModelGetConnectionFromTimelineEndpoint parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        success(networkCallback);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

@end
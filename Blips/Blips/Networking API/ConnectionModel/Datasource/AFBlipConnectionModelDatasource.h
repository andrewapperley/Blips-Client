//
//  AFBlipConnectionModelDatasource.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseNetworkDatasource.h"

@interface AFBlipConnectionModelDatasource : AFBlipBaseNetworkDatasource

- (void)createConnectionWithUserID:(NSString *)userID friendsUserID:(NSString *)friendsUserID accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)changeConnectionStatusWithUserID:(NSString *)userID connectionID:(NSString *)connectionID status:(BOOL)status accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)connectionListWithUserID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)connectionWithUserID:(NSString *)userID accessToken:(NSString *)accessToken timelineID:(NSString *)timelineID success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end
//
//  AFBlipNotificationsDatasource.h
//  Blips
//
//  Created by Andrew Apperley on 2014-06-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseNetworkDatasource.h"

@interface AFBlipNotificationsDatasource : AFBlipBaseNetworkDatasource

- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)unregisterForNotificationsWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)notificationCountForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)markNotificationAsReadForNotificationUserId:(NSString *)notificationUserId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end
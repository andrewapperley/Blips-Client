//
//  AFBlipNotificationsModelFactory.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"

/** Returns an array of AFBlipNotificationsModel objects. */
typedef void(^AFBlipNotificationsModelFactoryNotificationCountCompletion) (NSUInteger notificationCount, AFBlipBaseNetworkModel *networkCallback);

@interface AFBlipNotificationsModelFactory : NSObject

- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)unregisterForNotificationsWithUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)notificationCountForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipNotificationsModelFactoryNotificationCountCompletion)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)markNotificationAsReadForNotificationUserId:(NSString *)notificationUserId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end
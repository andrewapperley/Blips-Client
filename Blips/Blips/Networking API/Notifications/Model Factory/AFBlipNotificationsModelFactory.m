//
//  AFBlipNotificationsModelFactory.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipNotificationsDatasource.h"
#import "AFBlipNotificationsModelFactory.h"

@implementation AFBlipNotificationsModelFactory

- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipNotificationsDatasource *dataSource = [[AFBlipNotificationsDatasource alloc] init];
    [dataSource registerForNotificationsWithUniqueToken:uniqueToken userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
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
    
    AFBlipNotificationsDatasource *dataSource = [[AFBlipNotificationsDatasource alloc] init];
    [dataSource unregisterForNotificationsWithUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)notificationCountForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipNotificationsModelFactoryNotificationCountCompletion)success failure:(AFBlipBaseNetworkFailure)failure {

    AFBlipNotificationsDatasource *dataSource = [[AFBlipNotificationsDatasource alloc] init];
    [dataSource notificationCountForUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSUInteger notificationCount = 0;
            
            if(networkCallback.success) {
                notificationCount = [AFBlipNotificationsModelFactory notificationCountFromDictionary:networkCallback.responseData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success) {
                    success(notificationCount, networkCallback);
                }
            });
        });
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSUInteger)notificationCountFromDictionary:(NSDictionary *)dictionary {
    
    if(!dictionary) {
        return 0;
    }
    
    NSUInteger notificationCount = [dictionary[@"notification_count"] unsignedIntegerValue];

    return notificationCount;
}

- (void)markNotificationAsReadForNotificationUserId:(NSString *)notificationUserId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {

    AFBlipNotificationsDatasource *dataSource = [[AFBlipNotificationsDatasource alloc] init];
    [dataSource markNotificationAsReadForNotificationUserId:[notificationUserId copy] userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        if(success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

@end
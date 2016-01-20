//
//  AFBlipNavigationMediatorViewController.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-06.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFNavigationViewController.h"

@interface AFBlipNavigationMediatorViewController : AFNavigationViewController

#pragma mark - Notifications
- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken;
- (void)unregisterForNotifications;
- (void)displayPushNotification:(NSDictionary *)pushNotification state:(UIApplicationState)state;
- (void)displayPendingPushNotification;
- (void)setPendingNotificationData:(NSDictionary *)data;
@end
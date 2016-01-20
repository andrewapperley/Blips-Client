//
//  AFBlipConnectionsCollectionViewCellUser.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipNotificationBadgeStatics.h"

@class AFBlipConnectionModel, AFBlipUserModel;

@interface AFBlipConnectionsCollectionViewCellUser : UIView

@property(nonatomic, readonly)BOOL hasNotifications;

- (void)createUserWithConnectionModel:(AFBlipConnectionModel *)model;
- (void)createUserWithSearchModel:(AFBlipUserModel *)model;
- (void)updateUserWithNotifications:(NSInteger)notificationCount badgeType:(AFBlipNotificationBadgeType)badgeType;
- (void)prepareForReuse;
@end
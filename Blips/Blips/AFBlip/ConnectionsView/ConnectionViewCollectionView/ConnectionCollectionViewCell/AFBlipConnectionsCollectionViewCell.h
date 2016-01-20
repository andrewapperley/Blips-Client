//
//  AFBlipConnectionsCollectionViewCell.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipConnectionsCollectionViewCellUser.h"
#import "AFBlipNotificationBadgeStatics.h"

@interface AFBlipConnectionsCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong, readonly)AFBlipConnectionsCollectionViewCellUser* user;

- (void)createConnection:(AFBlipConnectionModel *)user;
- (void)createSearchResult:(AFBlipUserModel *)user;
- (void)updateUsersNotifications:(NSInteger)notificationCount badgeType:(AFBlipNotificationBadgeType)badgeType;

@end
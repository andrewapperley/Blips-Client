//
//  AFBlipNotificationBadge.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipNotificationBadgeStatics.h"

@interface AFBlipNotificationBadge : UIView

@property (nonatomic, assign, readonly) NSUInteger badgeCount;

- (void)updateBadgeCount:(NSUInteger)badgeCount badgeType:(AFBlipNotificationBadgeType)badgeType animated:(BOOL)animated;

+ (CGSize)preferredSize;

@end

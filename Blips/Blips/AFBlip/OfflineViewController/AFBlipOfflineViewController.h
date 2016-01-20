//
//  AFBlipOfflineViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-31.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFViewController.h"

@class AFBlipOfflineViewController;

@protocol AFBlipOfflineViewControllerDelegate <NSObject>

@required
- (void)offlineViewControllerDidReconnect:(AFBlipOfflineViewController *)offlineViewController;

@end

@interface AFBlipOfflineViewController : AFViewController

@property (nonatomic, weak) id<AFBlipOfflineViewControllerDelegate> delegate;

@end
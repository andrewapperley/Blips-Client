//
//  AFBlipMainViewController.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-06.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFViewController.h"

@class AFBlipMainViewController;
@class AFBlipVideoModel;
@class AFBlipVideoTimelineModel;

@protocol AFBlipMainViewControllerDelegate <NSObject>

@required
- (void)mainViewControllerDidLogout:(AFBlipMainViewController *)mainViewController;

@end

@interface AFBlipMainViewController : AFViewController

@property (nonatomic, weak) id<AFBlipMainViewControllerDelegate> delegate;

#pragma mark - Notifications
/** Update notifications list count. */
- (void)updateNotificationListCount;

#pragma mark - Video handling
/** Open video creation screen. */
- (void)openVideoCreationScreenWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;

/** Open video viewing screen. */
- (void)openVideoViewingScreenWithVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;
                                                       
@end
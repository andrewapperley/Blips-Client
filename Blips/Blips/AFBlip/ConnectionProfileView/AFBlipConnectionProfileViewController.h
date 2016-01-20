//
//  AFBlipConnectionProfileViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseFullScreenModalViewController.h"

@class AFBlipConnectionModel;
@class AFBlipConnectionProfileViewController;
@class AFBlipVideoTimelineModel;

@protocol AFBlipConnectionProfileViewControllerDelegate <NSObject>

@required

/** Called when the 'new timeline' cell is selected. */
- (void)connectionProfileViewControllerDidSelectCreateNewTimeline:(AFBlipConnectionProfileViewController *)connectionViewController;

/** Called when a timeline cell is selected. */
- (void)connectionProfileViewController:(AFBlipConnectionProfileViewController *)connectionViewController didSelectTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

@end

@interface AFBlipConnectionProfileViewController : AFBlipBaseFullScreenModalViewController

@property (nonatomic, weak) id<AFBlipConnectionProfileViewControllerDelegate> delegate;

- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle connectionModel:(AFBlipConnectionModel *)connectionModel;

@end
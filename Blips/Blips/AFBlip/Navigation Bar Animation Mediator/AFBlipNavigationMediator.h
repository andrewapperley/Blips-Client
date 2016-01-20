//
//  AFBlipNavigationMediator.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFBlipNavigationMediator;

typedef void (^AFBlipNavigationMediatorAnimationCompletion)(void);

@protocol AFBlipNavigationMediatorDelegate <NSObject>

@required
- (void)navigationMediatorDidTapBlockedViewFromMediator:(AFBlipNavigationMediator *)navigationMediator;

@end

/** AFBlipNavigationBarAnimationMediator is a class used to handle transitions between two views and a navigation bar. This is used for navigating between main sections of the application. */
@interface AFBlipNavigationMediator : NSObject

@property (nonatomic, weak) UIViewController<AFBlipNavigationMediatorDelegate> *delegate;

#pragma mark - Navigation methods
/** Navigate from timeline to settings. */
- (void)navigateToSettingsViewController:(UIViewController *)settingsViewController fromTimelineViewController:(UIViewController *)timelineViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion;

/** Navigate from settings to timeline. */
- (void)navigateToTimelineViewController:(UIViewController *)timelineViewController fromSettingsViewController:(UIViewController *)settingsViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion;

/** Navigate from timeline to connections. */
- (void)navigateToConnectionsViewController:(UIViewController *)connectionsViewController fromTimelineViewController:(UIViewController *)timelineViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion;

/** Navigate from settings to connections. */
- (void)navigateToTimelineViewController:(UIViewController *)timelineViewController fromConnectionsViewController:(UIViewController *)connectionsViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion;

@end
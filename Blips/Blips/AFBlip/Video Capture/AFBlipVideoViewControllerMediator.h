//
//  AFBlipVideoViewControllerMediator.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseFullScreenModalViewController.h"
#import "AFBlipVideoViewControllerMediatorStatics.h"

@class AFBlipVideoModel;
@class AFBlipVideoTimelineModel;
@class AFBlipVideoViewControllerMediator;

@protocol AFBlipVideoViewControllerMediatorDelegate <NSObject>

@required
- (void)videoViewControllerMediatorRequiresTimelineReload:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator;
- (void)videoViewControllerMediatorRequiresTimelineDelete:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator videoModel:(AFBlipVideoModel *)model;
- (void)videoViewControllerMediatorRequiresCellReloadForModel:(AFBlipVideoModel *)model mediator:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator;

@end

@interface AFBlipVideoViewControllerMediator : AFBlipBaseFullScreenModalViewController

@property (nonatomic, weak) id<AFBlipVideoViewControllerMediatorDelegate> delegate;

- (instancetype)initWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel initialState:(AFBlipVideoViewControllerMediatorState)initialState viewVideoModel:(AFBlipVideoModel *)viewVideoModel;

@end
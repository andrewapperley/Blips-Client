//
//  AFBlipVideoViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerBaseViewController.h"

@class AFBlipVideoModel;
@class AFBlipVideoTimelineModel;
@class AFBlipVideoViewController;

@protocol AFBlipVideoViewControllerDelegate <NSObject>

@required
- (void)videoViewControllerDidFavouriteVideo:(AFBlipVideoViewController *)videoViewController videoModel:(AFBlipVideoModel *)videoModel;
- (void)videoViewControllerDidPressDelete:(AFBlipVideoViewController *)videoViewController;
- (void)videoViewControllerDidFlag:(AFBlipVideoViewController *)videoViewController videoModel:(AFBlipVideoModel *)videoModel;
- (AFBlipVideoModel *)videoViewControllerVideoModel:(AFBlipVideoViewController *)videoViewController;
- (AFBlipVideoTimelineModel *)videoViewControllerTimelineVideoModel:(AFBlipVideoViewController *)videoViewController;

@end

@interface AFBlipVideoViewController : AFBlipVideoViewControllerBaseViewController

@property (nonatomic, weak) id<AFBlipVideoViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<AFBlipVideoViewControllerDelegate>)delegate;
- (void)removeTempVideoFile;
- (void)stopVideo;

@end
//
//  AFBlipCaptureViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerMediatorStatics.h"
#import "AFBlipVideoViewControllerBaseViewController.h"

@class AFBlipCaptureViewController;

@protocol AFBlipCaptureViewControllerDelegate <NSObject>

@required
- (void)captureViewDidPressReset:(AFBlipCaptureViewController *)captureView;
- (void)captureView:(AFBlipCaptureViewController *)captureView didFinishVideoCaptureWithVideoFilePath:(NSURL *)filePath videoThumbnailFilePath:(NSURL *)videoThumbnailFilePath;
- (void)captureViewDidUpdateVideoDimensions:(CGSize)videoSize captureView:(AFBlipCaptureViewController *)captureView;

@end

@interface AFBlipCaptureViewController : AFBlipVideoViewControllerBaseViewController

@property (nonatomic, weak) id<AFBlipCaptureViewControllerDelegate> delegate;

- (instancetype)initWithState:(AFBlipVideoPlayerState)state;

@end
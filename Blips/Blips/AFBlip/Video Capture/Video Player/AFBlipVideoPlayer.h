//
//  AFBlipVideoPlayer.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerMediatorStatics.h"
#include <AVFoundation/AVFoundation.h>

@class AFBlipVideoPlayer;

@protocol AFBlipVideoPlayerDelegate <NSObject>

@required
- (NSURL *)videoPlayerOutputFilePath:(AFBlipVideoPlayer *)videoPlayer;

@optional
- (NSURL *)videoPlayerOutputThumbnailFilePath:(AFBlipVideoPlayer *)videoPlayer;
- (CMTime)videoPlayerMaximumRecordingDuration:(AFBlipVideoPlayer *)videoPlayer;
- (void)videoPlayerDidFinishCapturingVideo:(AFBlipVideoPlayer *)videoPlayer;
- (void)videoPlayerVideoSize:(CGSize)videoSize videoPlayer:(AFBlipVideoPlayer *)videoPlayer;


@end

@interface AFBlipVideoPlayer : UIView

- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality  state:(AFBlipVideoPlayerState)state;

@property(nonatomic, strong)AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, weak) id<AFBlipVideoPlayerDelegate> delegate;
@property (nonatomic, assign, readonly) AFBlipVideoPlayerState state;

/** Switch camera input. */
- (void)switchCameraDevicePosition:(AVCaptureDevicePosition)devicePosition;

/** Starts recording. */
- (void)start:(AFBlipVideoPlayerState)state;

/** Stop recording. */
- (void)stop;

/** Stop and reset recording. */
- (void)reset;

/** Toggle activity indicator. */
- (void)showActivityIndicator:(BOOL)show;

@end
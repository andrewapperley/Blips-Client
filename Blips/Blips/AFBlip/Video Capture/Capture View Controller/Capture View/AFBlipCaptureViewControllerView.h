//
//  AFBlipCaptureViewControllerView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipVideoViewControllerMediatorStatics.h"

@class AFBlipCaptureViewControllerView;

@protocol AFBlipCaptureViewControllerViewDelegate <NSObject>

@required
- (NSURL *)captureViewVideoFilePath:(AFBlipCaptureViewControllerView *)captureView;
- (NSURL *)captureViewVideoThumbnailFilePath:(AFBlipCaptureViewControllerView *)captureView;
- (void)captureViewDidFinishCapture:(AFBlipCaptureViewControllerView *)captureView;
- (void)captureViewDidPressReset:(AFBlipCaptureViewControllerView *)captureView;
- (void)captureViewDidUpdateCurrentVideoDimensions:(CGSize)videoSize captureView:(AFBlipCaptureViewControllerView *)captureView;

@end

@interface AFBlipCaptureViewControllerView : UIView

@property (nonatomic, weak) id<AFBlipCaptureViewControllerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality state:(AFBlipVideoPlayerState)state delegate:(id<AFBlipCaptureViewControllerViewDelegate>)delegate;
- (void)startVideo;

@end
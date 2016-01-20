//
//  AFBlipVideoViewControllerView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerMediatorStatics.h"

@class AFBlipVideoViewControllerView;

@protocol AFBlipVideoViewControllerViewDelegate <NSObject>

@required
- (void)videoView:(AFBlipVideoViewControllerView *)viewVideo didPressFavourite:(BOOL)favourited;
- (void)videoView:(AFBlipVideoViewControllerView *)viewVideo didPressFlag:(BOOL)flag;
- (void)videoViewDidPressDelete:(AFBlipVideoViewControllerView *)viewVideo;
- (void)videoViewDidFinishPlayingVideo:(AFBlipVideoViewControllerView *)viewVideo;
- (NSString *)videoViewVideoMessage:(AFBlipVideoViewControllerView *)viewVideo;
- (NSURL *)videoViewVideoURL:(AFBlipVideoViewControllerView *)viewVideo;

@end

@interface AFBlipVideoViewControllerView : UIView

@property (nonatomic, weak) id<AFBlipVideoViewControllerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality delegate:(id<AFBlipVideoViewControllerViewDelegate>)delegate userVideo:(BOOL)isUserVideo;

- (void)start;
- (void)stop;
- (void)showActivityIndicator:(BOOL)show;

- (void)setVideoFavourited:(BOOL)favourited;
- (void)setVideoFlagged:(BOOL)flagged;

@end

//
//  AFBlipCaptureViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipCaptureViewController.h"
#import "AFBlipCaptureViewControllerView.h"
#import "AFPlatformUtility.h"

#pragma mark - Constants
NSString *const kAFBlipCaptureViewController_VideoPath          = @"blips_temp_video_capture.m4v";
NSString *const kAFBlipCaptureViewController_VideoThumbnailPath = @"blips_temp_video_thumbnail_capture.jpg";

@interface AFBlipCaptureViewController () <AFBlipCaptureViewControllerViewDelegate> {
    
    AFBlipCaptureViewControllerView *_view;
    BOOL _hasCapturedVideo;
    NSURL *_videoURLFilePath;
    NSURL *_videoThumbnailURLFilePath;
}

@end

@implementation AFBlipCaptureViewController

#pragma mark - Init
- (instancetype)initWithState:(AFBlipVideoPlayerState)state {

    self = [super init];
    if(self) {
        _hasCapturedVideo = state == AFBlipVideoPlayerState_Play;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCaptureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_view startVideo];
}

- (void)createCaptureView {
    
    AFBlipVideoPlayerState state = _hasCapturedVideo ? AFBlipVideoPlayerState_Play : AFBlipVideoPlayerState_Idle;
    
    _view = [[AFBlipCaptureViewControllerView alloc] initWithFrame:self.view.bounds quality:defaultVideoQuality() state:state delegate:self];
    [self.view addSubview:_view];
}

#pragma mark - AFBlipCaptureViewControllerViewDelegate
- (NSURL *)captureViewVideoFilePath:(AFBlipCaptureViewControllerView *)captureView {
    
    return [self videoPath];
}

- (NSURL *)captureViewVideoThumbnailFilePath:(AFBlipCaptureViewControllerView *)captureView {
    
    return [self videoThumbnailPath];
}

- (void)captureViewDidFinishCapture:(AFBlipCaptureViewControllerView *)captureView {

    _hasCapturedVideo = YES;
    [self.delegate captureView:self didFinishVideoCaptureWithVideoFilePath:[self videoPath] videoThumbnailFilePath:[self videoThumbnailPath]];
}

- (void)captureViewDidPressReset:(AFBlipCaptureViewControllerView *)captureView {
    
    _hasCapturedVideo          = NO;
    _videoURLFilePath          = nil;
    _videoThumbnailURLFilePath = nil;
    [self.delegate captureViewDidPressReset:self];
}

- (void)captureViewDidUpdateCurrentVideoDimensions:(CGSize)videoSize captureView:(AFBlipCaptureViewControllerView *)captureView {
    [self.delegate captureViewDidUpdateVideoDimensions:videoSize captureView:self];
}

#pragma mark - Video path string
- (NSURL *)videoPath {
    
    if(_videoURLFilePath) {
        return _videoURLFilePath;
    }
    
    NSString *videoPathString = NSTemporaryDirectory();
    NSURL *videoPath          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", videoPathString, kAFBlipCaptureViewController_VideoPath]];
    
    _videoURLFilePath = videoPath;
    if (!_videoURLFilePath) {
        NSLog( @"Not able to create the directory which contains path %@ : ", videoPath);
    }
    
    return videoPath;
}

#pragma mark - Video thumbnail path string
- (NSURL *)videoThumbnailPath {
    
    if(_videoThumbnailURLFilePath) {
        return _videoThumbnailURLFilePath;
    }
    
    NSString *videoThumbnailPathString = NSTemporaryDirectory();
    NSURL *videoThumbnailPath          = [NSURL fileURLWithPath:videoThumbnailPathString];

    NSError *error;
    if([[NSFileManager defaultManager] createDirectoryAtURL:videoThumbnailPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        _videoThumbnailURLFilePath = [videoThumbnailPath URLByAppendingPathComponent:kAFBlipCaptureViewController_VideoThumbnailPath];
        
    } else {
        NSLog( @"Not able to create the directory which contains path %@ : \nError : %@", videoThumbnailPath, error.localizedDescription);
    }
    
    return videoThumbnailPath;
}

#pragma mark - Overrides
- (BOOL)viewControllerCanProceedToNextSection {
    
    return _hasCapturedVideo;
}

#pragma mark - Dealloc
- (void)dealloc {
    self.delegate = nil;
}

@end
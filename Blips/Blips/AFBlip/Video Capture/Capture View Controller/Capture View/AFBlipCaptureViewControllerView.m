//
//  AFBlipCaptureViewControllerView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipCaptureViewControllerView.h"
#import "AFBlipCaptureViewProgressBar.h"
#import "AFBlipVideoPlayer.h"

#pragma mark - Constants
const CGFloat kAFBlipCaptureViewControllerView_RecordDurationMin                                = 2.0f;
const Float64 kAFBlipCaptureViewControllerView_RecordDuration                                   = 10.0f;

//Progress indicator
const CGFloat kAFBlipCaptureViewControllerView_ProgressIndicatorHeight                          = 15.0f;
const CGFloat kAFBlipCaptureViewControllerView_ProgressIndicatorBorderWidth                     = 2.0f;
const NSTimeInterval kAFBlipCaptureViewControllerView_ProgressIndicatorTickerRate               = 1.0f / 60.0f;
const NSTimeInterval kAFBlipCaptureViewControllerView_ProgressIndicatorAnimationDurationShowIn  = 0.2f;
const NSTimeInterval kAFBlipCaptureViewControllerView_ProgressIndicatorAnimationDurationShowOut = 0.15f;

//Buttons
const CGFloat kAFBlipCaptureViewControllerView_MotionEffectsAmountX                             = 10.0f;
const CGFloat kAFBlipCaptureViewControllerView_MotionEffectsAmountY                             = 10.0f;
const CGFloat kAFBlipCaptureViewControllerView_ButtonSize                                       = 70.0f;
const CGFloat kAFBlipCaptureViewControllerView_ButtonOffsetY                                    = 5.0f;
const CGFloat kAFBlipCaptureViewControllerView_ScreenOffsetHeight                               = 15.0f;

//Record button
const CGFloat kAFBlipCaptureViewControllerView_RecordButtonPaddingBottom                        = 130.0f;
const CGFloat kAFBlipCaptureViewControllerView_RecordButtonBorderWidth                          = 7.0f;

//Reset button
const CGFloat kAFBlipCaptureViewControllerView_ResetButtonPaddingLeft                           = 30.0f;

//Swap button
const CGFloat kAFBlipCaptureViewControllerView_SwapButtonPaddingRight                           = 30.0f;

@interface AFBlipCaptureViewControllerView () <AFBlipVideoPlayerDelegate> {
    
    NSTimeInterval                  _progressIndicatorElapsedTime;
    AFBlipCaptureViewProgressBar    *_progressIndicator;
    NSTimer                         *_progressIndicatorTimer;
    AFBlipVideoPlayer               *_videoPlayer;
    AVCaptureDevicePosition         _currentCaptureDevicePosition;
    UIButton                        *_recordButton;
    UIButton                        *_cameraSwapButton;
    UIButton                        *_resetButton;
    AFBlipVideoPlayerState          _videoPlayerState;
}

@end

@implementation AFBlipCaptureViewControllerView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality state:(AFBlipVideoPlayerState)state delegate:(id<AFBlipCaptureViewControllerViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _videoPlayerState  = state;
        _delegate          = delegate;
        self.clipsToBounds = YES;

        [self createVideoPlayer:quality];
        [self createProgressIndicator];
        [self createRecordButton];
        [self createCameraSwapButton];
        [self createResetButton];
        
        if(state == AFBlipVideoPlayerState_Play) {
            [self endCapture];
            _cameraSwapButton.enabled = NO;
            _resetButton.enabled      = YES;
        }
    }
    return self;
}

- (void)startVideo {
    
    [_videoPlayer start:_videoPlayerState];
}

- (void)createVideoPlayer:(AFBlipVideoCaptureQuality)quality {
 
    CGSize defaultSize    = defaultVideoPlayerSize();
    CGFloat width         = defaultSize.width;
    CGFloat height        = defaultSize.height;
    CGFloat padding       = (CGRectGetWidth(self.bounds) - width) / 2;
    CGRect frame          = CGRectMake(padding, padding, width, height);

    _videoPlayer          = [[AFBlipVideoPlayer alloc] initWithFrame:frame quality:quality state:_videoPlayerState];
    _videoPlayer.delegate = self;
    [self addSubview:_videoPlayer];
    
    _currentCaptureDevicePosition = AVCaptureDevicePositionBack;
}

- (void)createProgressIndicator {

    CGFloat width                         = CGRectGetWidth(_videoPlayer.frame);
    CGFloat height                        = kAFBlipCaptureViewControllerView_ProgressIndicatorHeight;
    CGFloat posY                          = CGRectGetMaxX(_videoPlayer.frame) + 5.0f;
    CGRect frame                          = CGRectMake( -width, posY, width, height);

    _progressIndicator                    = [[AFBlipCaptureViewProgressBar alloc] initWithFrame:frame];
    _progressIndicator.autoresizingMask   = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _progressIndicator.layer.borderColor  = [UIColor whiteColor].CGColor;
    _progressIndicator.layer.borderWidth  = kAFBlipCaptureViewControllerView_ProgressIndicatorBorderWidth;
    _progressIndicator.layer.cornerRadius = kAFBlipCaptureViewControllerView_ProgressIndicatorBorderWidth;
    [self addSubview:_progressIndicator];
}

#pragma mark - Record button
- (void)createRecordButton {
    
    CGRect frame   = CGRectMake(0, 0, kAFBlipCaptureViewControllerView_ButtonSize, kAFBlipCaptureViewControllerView_ButtonSize);
    frame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2;
    CGFloat heightOfButtonArea = self.bounds.size.height - CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight;
    frame.origin.y = CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight + ((heightOfButtonArea - frame.size.height)/2);
    
    _recordButton = [[UIButton alloc] initWithFrame:frame];
    [_recordButton addTarget:self action:@selector(onRecordButton) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(onRecordButtonDown) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(onRecordButtonDown) forControlEvents:UIControlEventTouchDownRepeat];
    [_recordButton addTarget:self action:@selector(onRecordButtonDown) forControlEvents:UIControlEventTouchDragEnter];
    [_recordButton addTarget:self action:@selector(onRecordButtonUp) forControlEvents:UIControlEventTouchCancel];
    [_recordButton addTarget:self action:@selector(onRecordButtonUp) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(onRecordButtonUp) forControlEvents:UIControlEventTouchDragOutside];
    [_recordButton addTarget:self action:@selector(onRecordButtonUp) forControlEvents:UIControlEventTouchUpOutside];
    
    //Border
    _recordButton.layer.cornerRadius = CGRectGetWidth(_recordButton.frame) / 2;
    _recordButton.layer.borderColor  = [UIColor whiteColor].CGColor;
    _recordButton.layer.borderWidth  = kAFBlipCaptureViewControllerView_RecordButtonBorderWidth;
    
    [self onRecordButtonUp];
    [self applyMotionEffectsToButton:_recordButton];
    [self addSubview:_recordButton];
}

- (void)onRecordButton {
    
    [self onRecordButtonDown];
    
    _recordButton.selected    = !_recordButton.selected;
    
    //Start recording
    if(_recordButton.selected) {
        [self startCapture];
        
        _recordButton.enabled = NO;
        typeof(_recordButton) __weak weakRecordButton = _recordButton;
        
        CGFloat delayInSeconds = kAFBlipCaptureViewControllerView_RecordDurationMin;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            weakRecordButton.enabled = YES;
        });

        _cameraSwapButton.enabled = NO;
        _resetButton.enabled      = NO;
        [_videoPlayer start:AFBlipVideoPlayerState_Record];
    //Stop recording
    } else {
        [self endCapture];
        _cameraSwapButton.enabled = NO;
        _resetButton.enabled      = YES;
        [_videoPlayer start:AFBlipVideoPlayerState_Play];
    }
}

- (void)onRecordButtonDown {
    
    _recordButton.backgroundColor = [self recordButtonBackgroundForDownState:YES];
}

- (void)onRecordButtonUp {
    
    _recordButton.backgroundColor = [self recordButtonBackgroundForDownState:NO];
}

- (UIColor *)recordButtonBackgroundForDownState:(BOOL)downState {
    
    //Selected
    if(_recordButton.selected) {
        if(downState) {
            return [UIColor afBlipRecordButtonNonRecordingStateColor];
        }
        
        return [UIColor afBlipRecordButtonRecordingStateColor];
    }
    //Not selected
    if(downState) {
        return [UIColor afBlipRecordButtonRecordingStateColor];
    }
    
    return [UIColor afBlipRecordButtonNonRecordingStateColor];
}

#pragma mark - Reset button
- (void)createResetButton {
    
    CGRect frame         = CGRectMake(0, 0, kAFBlipCaptureViewControllerView_ButtonSize, kAFBlipCaptureViewControllerView_ButtonSize);
    frame.origin.x       = kAFBlipCaptureViewControllerView_ResetButtonPaddingLeft;
    CGFloat heightOfButtonArea = self.bounds.size.height - CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight;
    frame.origin.y = CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight + ((heightOfButtonArea - frame.size.height)/2);

    UIImage *image       = [UIImage imageNamed:@"BlipsRemoveFriendIcon"];
    UIImage *imageDown   = [UIImage imageNamed:@"BlipsRemoveFriendIconDown"];

    _resetButton         = [[UIButton alloc] initWithFrame:frame];
    [_resetButton addTarget:self action:@selector(onResetButton) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton setImage:image forState:UIControlStateNormal];
    [_resetButton setImage:imageDown forState:UIControlStateHighlighted];
    _resetButton.enabled = NO;
    [self applyMotionEffectsToButton:_resetButton];
    [self addSubview:_resetButton];
}

- (void)onResetButton {
    
    _resetButton.enabled      = NO;
    _recordButton.selected    = NO;
    [self onRecordButtonUp];
    _cameraSwapButton.enabled = YES;
    if (_videoPlayer.state != AFBlipVideoPlayerState_None && _videoPlayer.state != AFBlipVideoPlayerState_Idle) {
        [_videoPlayer reset];
    }
    
    [_delegate captureViewDidPressReset:self];
}

#pragma mark - Camera swap button
- (void)createCameraSwapButton {
    
    CGRect frame   = CGRectMake(0, 0, kAFBlipCaptureViewControllerView_ButtonSize, kAFBlipCaptureViewControllerView_ButtonSize);
    frame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(frame) - kAFBlipCaptureViewControllerView_SwapButtonPaddingRight;
    CGFloat heightOfButtonArea = self.bounds.size.height - CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight;
    frame.origin.y = CGRectGetMaxY(_videoPlayer.frame) - kAFBlipCaptureViewControllerView_ScreenOffsetHeight + ((heightOfButtonArea - frame.size.height)/2);
    
    UIImage *image       = [UIImage imageNamed:@"BlipsCameraSwapIcon"];
    UIImage *imageDown   = [UIImage imageNamed:@"BlipsCameraSwapIconDown"];
    
    _cameraSwapButton                 = [[UIButton alloc] initWithFrame:frame];
    [_cameraSwapButton addTarget:self action:@selector(onCameraSwapButton) forControlEvents:UIControlEventTouchUpInside];
    [_cameraSwapButton setImage:image forState:UIControlStateNormal];
    [_cameraSwapButton setImage:imageDown forState:UIControlStateHighlighted];
    _cameraSwapButton.enabled         = YES;
    [self applyMotionEffectsToButton:_cameraSwapButton];
    [self addSubview:_cameraSwapButton];
}

- (void)onCameraSwapButton {
    
    if(_currentCaptureDevicePosition == AVCaptureDevicePositionFront) {
        _currentCaptureDevicePosition = AVCaptureDevicePositionBack;
    } else {
        _currentCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    
    [_videoPlayer switchCameraDevicePosition:_currentCaptureDevicePosition];
    [self onResetButton];
}

#pragma mark - Motion effects
- (void)applyMotionEffectsToButton:(UIButton *)button {
    
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - kAFBlipCaptureViewControllerView_MotionEffectsAmountX);
    motionEffectHorizontal.maximumRelativeValue         = @( kAFBlipCaptureViewControllerView_MotionEffectsAmountX);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - kAFBlipCaptureViewControllerView_MotionEffectsAmountY);
    motionEffectVertical.maximumRelativeValue           = @( kAFBlipCaptureViewControllerView_MotionEffectsAmountY);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    [button addMotionEffect:motionEffectGroup];
}

#pragma mark - Progress indicator
- (void)startCapture {
    
    _resetButton.enabled      = NO;
    
    CGRect __block frame     = _progressIndicator.frame;
    frame.origin.x           = - CGRectGetWidth(frame);
    _progressIndicator.frame = frame;
    frame.origin.x           = CGRectGetMinX(_videoPlayer.frame);

    typeof(_progressIndicator) __weak weakProgressIndicator = _progressIndicator;
    [UIView animateWithDuration:kAFBlipCaptureViewControllerView_ProgressIndicatorAnimationDurationShowIn delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

        weakProgressIndicator.frame = frame;
    } completion:nil];
    
    typeof(self) __weak weakSelf = self;
    _progressIndicatorTimer = [NSTimer scheduledTimerWithTimeInterval:kAFBlipCaptureViewControllerView_ProgressIndicatorTickerRate target:weakSelf selector:@selector(onCaptureTick) userInfo:nil repeats:YES];
}

- (void)endCapture {
    
    CGRect __block frame = _progressIndicator.frame;
    frame.origin.x       = CGRectGetWidth(self.bounds);
    
    typeof(_progressIndicator) __weak weakProgressIndicator = _progressIndicator;
    [UIView animateWithDuration:kAFBlipCaptureViewControllerView_ProgressIndicatorAnimationDurationShowOut delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        weakProgressIndicator.frame = frame;
    } completion:^(BOOL finished) {
        [weakProgressIndicator updateToPercentage:0.0f];
    }];
    
    [_progressIndicatorTimer invalidate];
    _progressIndicatorTimer       = nil;

    _progressIndicatorElapsedTime = 0.0f;
    if (_recordButton.isSelected) {
        [self onRecordButtonDown];
    }
}

- (void)onCaptureTick {
    
    _progressIndicatorElapsedTime     += kAFBlipCaptureViewControllerView_ProgressIndicatorTickerRate;
    CGFloat percentage                = _progressIndicatorElapsedTime / kAFBlipCaptureViewControllerView_RecordDuration;
    [_progressIndicator updateToPercentage:percentage];
    
    if(_progressIndicatorElapsedTime >= kAFBlipCaptureViewControllerView_RecordDuration) {
        [self endCapture];
    }
}

#pragma mark - AFBlipVideoPlayerDelegate
- (NSURL *)videoPlayerOutputFilePath:(AFBlipVideoPlayer *)videoPlayer {

    return [_delegate captureViewVideoFilePath:self];
}

- (NSURL *)videoPlayerOutputThumbnailFilePath:(AFBlipVideoPlayer *)videoPlayer {
    
    return [_delegate captureViewVideoThumbnailFilePath:self];
}

- (CMTime)videoPlayerMaximumRecordingDuration:(AFBlipVideoPlayer *)videoPlayer {
    
    return CMTimeMakeWithSeconds(kAFBlipCaptureViewControllerView_RecordDuration + 1, 1.0f);
}

- (void)videoPlayerVideoSize:(CGSize)videoSize videoPlayer:(AFBlipVideoPlayer *)videoPlayer {
    [_delegate captureViewDidUpdateCurrentVideoDimensions:videoSize captureView:self];
}

- (void)videoPlayerDidFinishCapturingVideo:(AFBlipVideoPlayer *)videoPlayer {
    
    [self endCapture];
    [_delegate captureViewDidFinishCapture:self];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [_progressIndicatorTimer invalidate];
    _progressIndicatorTimer = nil;
    _delegate = nil;
}

@end
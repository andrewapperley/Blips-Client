//
//  AFBlipVideoPlayer.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipVideoPlayer.h"

const CGFloat kAFBlipVideoPlayer_AnimationDuration = 0.35f;

@interface AFBlipVideoPlayer () <AVCaptureFileOutputRecordingDelegate> {
    
    //Capture setup
    AVCaptureSession           *_captureSession;
    AVCaptureDeviceInput       *_captureDeviceInput;
    AVCaptureDeviceInput       *_captureAudioInput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    AVCaptureMovieFileOutput   *_captureFileOutput;
    
    //Video player
    AVPlayer                   *_videoPlayer;
    AVPlayerLayer              *_videoPlayerLayer;
    CAShapeLayer               *_cornerShapes;
    CGSize                     _videoDimensions;
    
    //Activity indicator
    AFBlipActivityIndicator    *_activityIndicator;
    
    //State
    AFBlipVideoPlayerState     _currentState;
    AFBlipVideoCaptureQuality  _quality;
}

@end

@implementation AFBlipVideoPlayer

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality state:(AFBlipVideoPlayerState)state {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _quality = quality;
        _state   = state;
        [self createBackground];
        [self createVideoPreviewLayerCorners];
        [self showActivityIndicator:YES];
    }
    return self;
}

- (void)createBackground {
    
    self.clipsToBounds   = NO;
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
}

- (void)createCaptureSession {
    
    _captureSession = [[AVCaptureSession alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabVideoDimensions:) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
    [_captureSession beginConfiguration];
}

- (void)grabVideoDimensions:(NSNotification *)event {
    
    AVCaptureInputPort *port = event.object;
    CMFormatDescriptionRef formatDescription = port.formatDescription;
    
    if (CMFormatDescriptionGetMediaType(formatDescription) == kCMMediaType_Video) {
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
        _videoDimensions = CGSizeMake(dimensions.height, dimensions.width);
        if ([_delegate respondsToSelector:@selector(videoPlayerVideoSize:videoPlayer:)]) {
            [_delegate videoPlayerVideoSize:_videoDimensions videoPlayer:self];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
    }
}


- (void)createCaptureDeviceInput {
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if(videoDevice) {
        
        NSError *error;
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if(!_captureDeviceInput) {
            NSLog(@"error : %@", error.localizedDescription);
        }
        
        if(_captureDeviceInput) {
            if([_captureSession canAddInput:_captureDeviceInput]) {
                [_captureSession addInput:_captureDeviceInput];
            }
        }
    }
}

- (void)createAudioInput {
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    if(audioDevice) {
        
        NSError *error;
        _captureAudioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if(!_captureAudioInput) {
            NSLog(@"error : %@", error.localizedDescription);
        }
        
        if(_captureAudioInput) {
            if([_captureSession canAddInput:_captureAudioInput]) {
                [_captureSession addInput:_captureAudioInput];
            }
        }
    }
}

- (void)createVideoOutput {
    
    _captureFileOutput                     = [[AVCaptureMovieFileOutput alloc] init];
}

- (void)createVideoPreviewLayerWithQuality:(AFBlipVideoCaptureQuality)quality {
    
    _captureVideoPreviewLayer              = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.borderColor  = [UIColor colorWithWhite:0.396 alpha:1.000].CGColor;
    _captureVideoPreviewLayer.borderWidth  = 1;
    _captureVideoPreviewLayer.opacity      = 0;
    
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.frame        = self.bounds;
    
    if([_captureVideoPreviewLayer.connection isVideoOrientationSupported]) {
        [_captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [_captureVideoPreviewLayer.connection setAutomaticallyAdjustsVideoMirroring:NO];
    [_captureVideoPreviewLayer.connection setVideoMirrored:NO];
    
    [_captureSession setSessionPreset:[AFBlipVideoPlayer AFBlipVideoCaptureQualityToString:quality]];
    [self.layer insertSublayer:_captureVideoPreviewLayer below:_cornerShapes];
    
    if([_captureSession canAddOutput:_captureFileOutput] ) {
        [_captureSession addOutput:_captureFileOutput];
    }
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];

}

- (void)createVideoPlayer {
    
    _videoPlayer = [[AVPlayer alloc] initWithURL:nil];
    
    _videoPlayer.actionAtItemEnd   = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(previewDidReachEnd:)
                                                      name:AVPlayerItemDidPlayToEndTimeNotification
                                                    object:nil];
    
    _videoPlayerLayer              = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    _videoPlayerLayer.opacity      = 0;
    _videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPlayerLayer.frame        = self.bounds;
    
    [self.layer insertSublayer:_videoPlayerLayer below:_cornerShapes];
}

- (void)createVideoPreviewLayerCorners {
    
    NSInteger borderWidth = 3;
    NSInteger borderHeight = 27;

    _cornerShapes  = [[CAShapeLayer alloc] init];
    _cornerShapes.frame          = CGRectMake(self.bounds.origin.x - borderWidth/2, self.bounds.origin.y - borderWidth / 2, self.bounds.size.width + borderWidth, self.bounds.size.height + borderWidth);
    _cornerShapes.strokeColor    = [UIColor clearColor].CGColor;
    _cornerShapes.fillColor      = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;

    UIBezierPath *path = [[UIBezierPath alloc] init];

    [path moveToPoint:CGPointMake(0, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, borderHeight)];

    [path moveToPoint:CGPointMake(_cornerShapes.frame.size.width, borderHeight)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderHeight, 0)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width, borderHeight)];

    [path moveToPoint:CGPointMake(_cornerShapes.frame.size.width, _cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderWidth, _cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderWidth, _cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderHeight, _cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width - borderHeight, _cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.width, _cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(_cornerShapes.frame.size.height, _cornerShapes.frame.size.height - borderHeight)];

    [path moveToPoint:CGPointMake(0, _cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, _cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, _cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, _cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, _cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, _cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, _cornerShapes.frame.size.height - borderHeight)];

    [path closePath];
        
    _cornerShapes.path = path.CGPath;

    [self.layer addSublayer:_cornerShapes];
}

#pragma mark - Video player methods
- (void)start:(AFBlipVideoPlayerState)state {
    
    if(!_videoPlayer) {
        [self createCaptureSession];
        [self createCaptureDeviceInput];
        [self createAudioInput];
        [self createVideoOutput];
        [self createVideoPreviewLayerWithQuality:_quality];
        [self createVideoPlayer];
        [self showActivityIndicator:NO];
    }
    
    if(_captureSession.isRunning && _captureFileOutput.isRecording) {
        [self stop];
    }
    
    _state = state;
    AVPlayerItem *playerItem;
    NSURL *videoPlayerOutputFilePath = [_delegate videoPlayerOutputFilePath:self];
    CMTime duration                     = kCMTimeZero;
    
    if([_delegate respondsToSelector:@selector(videoPlayerMaximumRecordingDuration:)]) {
        duration = [_delegate videoPlayerMaximumRecordingDuration:self];
    }

    switch(_state) {
        case AFBlipVideoPlayerState_Play:
            _currentState = AFBlipVideoPlayerState_Play;
            playerItem = [AVPlayerItem playerItemWithURL:videoPlayerOutputFilePath];
            [_videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
            [_videoPlayer play];
            
            [self animateInLayer:_videoPlayerLayer outLayer:_captureVideoPreviewLayer];
            
            break;
        case AFBlipVideoPlayerState_Record:
            [self reset];
            _currentState = AFBlipVideoPlayerState_Record;
            playerItem = [AVPlayerItem playerItemWithURL:nil];
            
            [self animateInLayer:_captureVideoPreviewLayer outLayer:_videoPlayerLayer];

            if (!_captureSession.isRunning) {
                [_captureSession startRunning];
            }
            [_videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
            _captureFileOutput.maxRecordedDuration = duration;
            [_captureFileOutput startRecordingToOutputFileURL:videoPlayerOutputFilePath recordingDelegate:self];
            
            break;
        case AFBlipVideoPlayerState_Idle:
            [self stop];
            playerItem = [AVPlayerItem playerItemWithURL:nil];
            if (!_captureSession.isRunning) {
                [_captureSession startRunning];
            }
            [_videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
            
            [self animateInLayer:_captureVideoPreviewLayer outLayer:_videoPlayerLayer];

            break;
        default:
            break;
    }
}

- (void)animateInLayer:(CALayer *)inLayer outLayer:(CALayer *)outLayer {
    
    //In layer
    CABasicAnimation *inLayerAnimation    = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inLayerAnimation.duration             = kAFBlipVideoPlayer_AnimationDuration;
    inLayerAnimation.fromValue            = @(inLayer.opacity);
    inLayerAnimation.toValue              = @(1.0f);
    inLayerAnimation.fillMode             = kCAFillModeForwards;
    inLayerAnimation.removedOnCompletion  = NO;
    [inLayer addAnimation:inLayerAnimation forKey:nil];

    //Out layer
    CABasicAnimation *outLayerAnimation   = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outLayerAnimation.duration            = kAFBlipVideoPlayer_AnimationDuration;
    outLayerAnimation.fromValue           = @(outLayer.opacity);
    outLayerAnimation.toValue             = @(0.0f);
    outLayerAnimation.fillMode             = kCAFillModeForwards;
    outLayerAnimation.removedOnCompletion  = NO;
    [outLayer addAnimation:outLayerAnimation forKey:nil];
}

- (void)switchCameraDevicePosition:(AVCaptureDevicePosition)devicePosition {
    
    NSArray *devicesAvailable = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *newDevice;
    
    for(AVCaptureDevice *device in devicesAvailable) {
        if(device.position == devicePosition) {
            newDevice = device;
            break;
        }
    }
    
    [_captureSession stopRunning];
    [_captureSession beginConfiguration];
    
    NSError *error;
    if(newDevice) {
        [_captureSession removeInput:_captureDeviceInput];
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:&error];
        
        if(error) {
            NSLog(@"error : %@", error.localizedDescription);
            return;
        }
    }
    
    [_captureSession addInput:_captureDeviceInput];
    [_captureSession commitConfiguration];
    [_captureSession startRunning];
    
    _currentState = AFBlipVideoPlayerState_Idle;
    [self start:_currentState];
}

- (void)stop {
    
    if (_captureSession.isRunning) {
        [_captureSession stopRunning];
    }
    if (_captureFileOutput.isRecording) {
        [_captureFileOutput stopRecording];
    }
    
    [_videoPlayer replaceCurrentItemWithPlayerItem:nil];
    
}

- (void)reset {
    
    _currentState = AFBlipVideoPlayerState_Idle;

    //Video
    NSURL *videoPlayerOutputFilePath = [_delegate videoPlayerOutputFilePath:self];
    unlink([videoPlayerOutputFilePath.path UTF8String]);
    NSFileManager *fileManager       = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:videoPlayerOutputFilePath.path]) {
        
        NSError *error;
        BOOL hasError = [fileManager removeItemAtPath:videoPlayerOutputFilePath.path error:&error];
        if(hasError) {
            NSLog(@"error : %@", error.localizedDescription);
        }
    }
    
    //Thumbnail
    NSURL *videoPlayerThumbnailOutputFilePath = [_delegate videoPlayerOutputThumbnailFilePath:self];
    unlink([videoPlayerThumbnailOutputFilePath.absoluteString UTF8String]);
    if([fileManager fileExistsAtPath:videoPlayerOutputFilePath.absoluteString]) {
        
        NSError *error;
        BOOL hasError = [fileManager removeItemAtPath:videoPlayerThumbnailOutputFilePath.absoluteString error:&error];
        if(hasError) {
            NSLog(@"error : %@", error.localizedDescription);
        }
    }
    
    [self start:_currentState];
}

- (void)previewDidReachEnd:(NSNotification *)event {
    AVPlayerItem *p = [event object];
    if ([_videoPlayer.currentItem isEqual:p]) {
        [p seekToTime:CMTimeMake(1, 2)];
        [_videoPlayer play];
        
        if([_delegate respondsToSelector:@selector(videoPlayerDidFinishCapturingVideo:)]) {
            
            [_delegate videoPlayerDidFinishCapturingVideo:self];
        }
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate Methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {

    [_delegate videoPlayerDidFinishCapturingVideo:self];

    [_captureFileOutput stopRecording];
    
    AFBlipVideoPlayerState state = AFBlipVideoPlayerState_Play;
    
    if (error) {
        switch (error.code) {
                /*This code is for when switching devices while recording*/
                case -11818:
                /*This code is for when resetting the recording*/
                case 2:
                    state = AFBlipVideoPlayerState_Record;
                break;
                case -11810:
                    state = AFBlipVideoPlayerState_Play;
                break;
                default:
                    return;
                break;
        }
    }
    if (_currentState == AFBlipVideoPlayerState_Idle) {
        state = _currentState;
        _currentState = AFBlipVideoPlayerState_None;
    }
    [self start:state];
}

#pragma mark - Utilities 
+ (NSString *)AFBlipVideoCaptureQualityToString:(AFBlipVideoCaptureQuality)quality {

    NSString *qualityString;
    
    switch(quality) {
        case AFBlipVideoCapturePreset_640x480:
            qualityString = @"AVCaptureSessionPreset640x480";
            break;
        case AFBlipVideoCapturePreset_960x540:
            qualityString = @"AVCaptureSessionPresetiFrame960x540";
            break;
        case AFBlipVideoCapturePreset_InputPriority:
            qualityString = @"AVCaptureSessionPresetInputPriority";
            break;
        case AFBlipVideoCapturePreset_Low:
            qualityString = @"AVCaptureSessionPresetLow";
            break;
        case AFBlipVideoCapturePreset_Medium:
            qualityString = @"AVCaptureSessionPresetMedium";
            break;
        case AFBlipVideoCapturePreset_High:
        default:
            qualityString = @"AVCaptureSessionPresetHigh";
            break;
    }
    
    return qualityString;
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.center;
        [self addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    } else if(show) {
        [_activityIndicator startAnimating];
    }
    
    
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    _delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_captureSession stopRunning];
    [_captureSession beginConfiguration];
    [_captureFileOutput stopRecording];
    [_captureVideoPreviewLayer setSession:nil];
    
    [_captureSession removeInput:_captureDeviceInput];
    [_captureSession removeInput:_captureAudioInput];
    [_captureSession removeOutput:_captureFileOutput];
    
    _captureFileOutput = nil;
    _captureDeviceInput = nil;
    _captureAudioInput = nil;
    _captureVideoPreviewLayer = nil;
    
    [_captureSession commitConfiguration];
}

@end
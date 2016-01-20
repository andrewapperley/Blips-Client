//
//  AFBlipVideoViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModel.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipVideoViewController.h"
#import "AFBlipVideoViewControllerView.h"
#import "AFBlipAlertView.h"
#import "AFBlipAmazonS3Statics.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import <AFHTTPRequestOperation.h>

#pragma mark - Constants
NSString *const kAFBlipVideoViewController_VideoPath          = @"blips_temp_video_view.m4v";

@interface AFBlipVideoViewController () <AFBlipVideoViewControllerViewDelegate> {
    
    AFHTTPRequestOperation        *_videoRequestOperation;
    AFBlipVideoViewControllerView *_videoView;
    NSURL                         *_tempVideoPath;
}

@end

@implementation AFBlipVideoViewController

#pragma mark - Init
- (instancetype)initWithDelegate:(id<AFBlipVideoViewControllerDelegate>)delegate {
    
    self = [super init];
    if(self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCaptureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadVideo];
}

- (void)createCaptureView {

    AFBlipUserModel *userModel   = [AFBlipUserModelSingleton sharedUserModel].userModel;
    AFBlipVideoModel *videoModel = [self.delegate videoViewControllerVideoModel:self];
    BOOL favourited              = videoModel.favourited;
    BOOL flagged                 = videoModel.flagged;
    BOOL isUserVideo             = [videoModel.userThumbnailURLString isEqualToString:userModel.userImageUrl];
    
    _videoView = [[AFBlipVideoViewControllerView alloc] initWithFrame:self.view.bounds quality:defaultVideoQuality() delegate:self userVideo:isUserVideo];
    [_videoView setVideoFavourited:favourited];
    [_videoView setVideoFlagged:flagged];
    [self.view addSubview:_videoView];
}

#pragma mark - AFBlipVideoViewControllerViewDelegate
- (void)videoView:(AFBlipVideoViewControllerView *)viewVideo didPressFavourite:(BOOL)favourited {

    NSString *userId                = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken           = [AFBlipKeychain keychain].accessToken;
    AFBlipVideoModel *videoModel    = [self.delegate videoViewControllerVideoModel:self];
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];

    //Favourite
    if(favourited) {
        [factory setFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoModel.videoId favouritedDate:((long)[[NSDate date] timeIntervalSince1970]) timelineId:videoModel.timelineId success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (networkCallback.success) {
//                [viewVideo setVideoFavourited:favourited];
            }
        } failure:^(NSError *error) {
            
        }];
    //Unfavourite
    } else {
        [factory removeFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoModel.videoId success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (networkCallback.success) {
//                [viewVideo setVideoFavourited:!favourited];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    [self.delegate videoViewControllerDidFavouriteVideo:self videoModel:videoModel];
}

- (void)videoView:(AFBlipVideoViewControllerView *)viewVideo didPressFlag:(BOOL)flagged {
    
    NSString *userId                = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken           = [AFBlipKeychain keychain].accessToken;
    AFBlipVideoModel *videoModel    = [self.delegate videoViewControllerVideoModel:self];
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    
    //Flag
    if(flagged) {
        [factory setFlaggedVideoWithUserId:userId accessToken:accessToken videoId:videoModel.videoId videoPath:videoModel.videoURL timelineId:videoModel.timelineId success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (networkCallback.success) {
//                [viewVideo setVideoFlagged:flagged];
            }
        } failure:^(NSError *error) {
            
        }];
  //Unflag
    } else {
        [factory removeFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoModel.videoId success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (networkCallback.success) {
//                [viewVideo setVideoFlagged:flagged];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    [self.delegate videoViewControllerDidFlag:self videoModel:videoModel];
}

- (void)videoViewDidPressDelete:(AFBlipVideoViewControllerView *)viewVideo {
    
    [self.delegate videoViewControllerDidPressDelete:self];
}

- (void)videoViewDidFinishPlayingVideo:(AFBlipVideoViewControllerView *)viewVideo {
    
}

- (NSString *)videoViewVideoMessage:(AFBlipVideoViewControllerView *)viewVideo {
    
    return [self.delegate videoViewControllerVideoModel:self].videoDescription;
}

- (NSURL *)videoViewVideoURL:(AFBlipVideoViewControllerView *)viewVideo {
    
    return _tempVideoPath;
}

#pragma mark - Playback
- (void)loadVideo {
    
    //Check for temp file
    if(_tempVideoPath) {
        [self removeTempVideoFile];
    }
    
    //Video model
    AFBlipVideoModel *videoModel = [self.delegate videoViewControllerVideoModel:self];
    NSString *videoModelKey = videoModel.videoURL;
    
    //Load video
    typeof(self) __weak weakSelf            = self;
    typeof(_videoView) __weak weakVideoView = _videoView;
    
    //Load AWS object
    [_videoRequestOperation cancel];
    
    AFBlipAWSS3AbstractFactory *factory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    _videoRequestOperation = [factory objectForKey:videoModelKey completion:^(NSData *data) {
        
        //Create file name
        NSString *videoPathString = NSTemporaryDirectory();
        NSURL *videoPath          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", videoPathString, kAFBlipVideoViewController_VideoPath] isDirectory:NO];
        
        _tempVideoPath = videoPath;
        if (!_tempVideoPath) {
            NSLog( @"Not able to create the directory which contains path %@ : ", videoPath);
        }
        
        [data writeToURL:videoPath atomically:YES];
        [weakSelf startVideo];
        if (self.loaded) {
            self.loaded();
            self.loaded = NULL;
        }
        
    } failure:^(NSError *error) {
        
        [weakVideoView showActivityIndicator:NO];

        AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:error.userInfo[kAFBlipAWSErrorNoObjectTitleKey] message:error.userInfo[kAFBlipAWSErrorNoObjectMessageKey] buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
        [alertView show];
    }];
}

- (void)startVideo {
    
    [_videoView start];
}

- (void)stopVideo {
    
    [_videoView stop];
}

- (void)removeTempVideoFile {
    
    if(_tempVideoPath) {
        unlink([_tempVideoPath.path UTF8String]);
    }
}

#pragma mark - Proceed
- (BOOL)viewControllerCanProceedToNextSection {
    
    if (self.loaded) {
        return NO;
    }
    
    AFBlipVideoTimelineModel *timelineVideoModel = [self.delegate videoViewControllerTimelineVideoModel:self];
    
    return timelineVideoModel.type == AFBlipVideoTimelineModelType_Recent;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [_videoRequestOperation cancel];
    self.delegate = nil;
    [self removeTempVideoFile];
}

@end
//
//  AFBlipShareViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipKeychain.h"
#import "AFBlipShareViewController.h"
#import "AFBlipShareViewControllerView.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipVideoTimelineModel.h"

const CGFloat kAFBlipShareViewController_ActivityIndicatorTopPadding = 185.0f;

@interface AFBlipShareViewController () {
    
    AFBlipActivityIndicator       *_activityIndicator;
    AFBlipVideoTimelineModel      *_videoTimelineModel;
    AFBlipShareViewControllerView *_shareView;
    NSURL                         *_videoContentURL;
    NSURL                         *_videoContentThumbnailURL;
}

@end

@implementation AFBlipShareViewController

#pragma mark - Init
- (instancetype)initWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel videoContentURL:(NSURL *)videoContentURL videoContentThumbnailURL:(NSURL *)videoContentThumbnailURL message:(NSString *)message {
    
    self = [super init];
    if(self) {
        
        _videoTimelineModel         = videoTimelineModel;
        _videoContentURL            = videoContentURL;
        _videoContentThumbnailURL   = videoContentThumbnailURL;
        [self createShareViewWithVideoTimelineModel:message];
    }
    
    return self;
}

#pragma mark - Create share view
- (void)createShareViewWithVideoTimelineModel:(NSString *)message {
    
    _shareView = [[AFBlipShareViewControllerView alloc] initWithFrame:self.view.bounds videoTimelineModel:_videoTimelineModel message:message];
    [self.view addSubview:_shareView];
}


- (NSString *)message {
    
    NSString *message = _shareView.message;
    
    if(message) {
        return message;
    }
    
    return @"";
}

#pragma mark - Share
- (void)share:(AFBlipVideoShareCompletion)completion {
    
    typeof(self) __weak weakSelf          = self;
    [self showActivityIndicator:YES];
    
    NSString *userId      = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken = [AFBlipKeychain keychain].accessToken;
    
    NSFileManager *__weak fileManager = [NSFileManager defaultManager];
    NSData *videoData;
    NSData *videoThumbnailData;
    
    //Load video data
    if([fileManager fileExistsAtPath:_videoContentURL.path]) {
        videoData = [fileManager contentsAtPath:_videoContentURL.path];
    }
    
    //Thumbnail data
    if([fileManager fileExistsAtPath:_videoContentThumbnailURL.path]) {
        videoThumbnailData = [fileManager contentsAtPath:_videoContentThumbnailURL.path];
    }
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory postVideoModelWithUserId:userId timelineId:[_videoTimelineModel.timelineIds firstObject] videoContent:videoData date:((long)[[NSDate date] timeIntervalSince1970]) accessToken:accessToken videoThumbnail:videoThumbnailData andVideoDescription:[self message] success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        //Remove temporary files
        [weakSelf removeTempVideoFile];
        
        //Remove temporary file
        [weakSelf removeTempVideoThumbnailFile];
        
        if (completion) {
            completion();
        }
        
        [self.delegate shareViewControllerDidShare:weakSelf];
        
    } failure:^(NSError *error) {
        [weakSelf showActivityIndicator:NO];
        if (completion) {
            completion();
        }
    }];
}

- (void)removeTempVideoFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:_videoContentURL.absoluteString]) {
        
        NSError *error;
        BOOL hasError = [fileManager removeItemAtPath:_videoContentURL.absoluteString error:&error];
        if(hasError) {
            NSLog(@"error : %@", error.localizedDescription);
        }
    }
}

- (void)removeTempVideoThumbnailFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:_videoContentThumbnailURL.absoluteString]) {
        
        NSError *error;
        BOOL hasError = [fileManager removeItemAtPath:_videoContentThumbnailURL.absoluteString error:&error];
        if(hasError) {
            NSLog(@"error : %@", error.localizedDescription);
        }
    }
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activityIndicator.center           = self.view.center;
        
        //Frame
        CGRect frame             = _activityIndicator.frame;
        frame.origin.y           = kAFBlipShareViewController_ActivityIndicatorTopPadding;
        _activityIndicator.frame = frame;
        
        [self.view addSubview:_activityIndicator];
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
    self.delegate = nil;
}

@end
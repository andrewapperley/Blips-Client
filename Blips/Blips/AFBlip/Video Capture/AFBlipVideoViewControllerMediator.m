//
//  AFBlipVideoViewControllerMediator.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipAlertView.h"
#import "AFBlipCaptureViewController.h"
#import "AFBlipFilterViewController.h"
#import "AFBlipKeychain.h"
#import "AFBlipShareViewController.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModel.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipVideoTimelineModel.h"
#import "AFBlipVideoViewController.h"
#import "AFBlipVideoViewControllerMediator.h"
#import "AFFAlertViewButtonModel.h"

#pragma mark - Constants
const CGFloat kAFBlipVideoViewControllerMediator_OpenAnimationDuration  = 0.45f;
const CGFloat kAFBlipVideoViewControllerMediator_AnimationSpringDamping = 0.8f;
const CGFloat kAFBlipVideoViewControllerMediator_AnimationVelocity      = 0.5f;

@interface AFBlipVideoViewControllerMediator () <AFBlipCaptureViewControllerDelegate, AFBlipFilterViewControllerDelegate, AFBlipShareViewControllerDelegate, AFBlipVideoViewControllerDelegate, AFFAlertViewDelegate> {
    
    AFBlipActivityIndicator                     *_activityIndicator;

    AFBlipVideoViewControllerMediatorState      _state;
    AFBlipVideoTimelineModel                    *_videoTimelineModel;
    AFBlipVideoViewControllerBaseViewController *_currentViewController;
    
    NSURL                                       *_currentFilterVideoFilePath;
    NSURL                                       *_currentVideoFilePath;
    NSURL                                       *_currentVideoThumbnailFilePath;
    CGSize                                      _currentVideoSize;
    NSString                                    *_shareVideoMessage;
    AFBlipVideoModel                            *_viewVideoModel;
}

@end

@implementation AFBlipVideoViewControllerMediator

#pragma mark - Init
- (instancetype)initWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel initialState:(AFBlipVideoViewControllerMediatorState)initialState viewVideoModel:(AFBlipVideoModel *)viewVideoModel {
    
    self = [super initWithToolbarWithTitle:nil leftButton:nil rightButton:nil];
    if(self) {
        
        _shareVideoMessage  = nil;
        _viewVideoModel     = viewVideoModel;
        _videoTimelineModel = videoTimelineModel;
        _state              = AFBlipVideoViewControllerMediatorState_None;
        [self changeToState:initialState];
    }
    return self;
}

#pragma mark - State handling
- (void)changeToState:(AFBlipVideoViewControllerMediatorState)toState {
    
    //Create the new view controller
    AFBlipVideoViewControllerBaseViewController __block *fromViewController = _currentViewController;
    AFBlipVideoViewControllerBaseViewController __block *toViewController;
    
    switch(toState) {
            
        case AFBlipVideoViewControllerMediatorState_Capture: {
            AFBlipVideoPlayerState videoState;
            if(_state == AFBlipVideoViewControllerMediatorState_Filter) {
                videoState = AFBlipVideoPlayerState_Play;
            } else {
                videoState = AFBlipVideoPlayerState_Idle;
            }
            toViewController = [[AFBlipCaptureViewController alloc] initWithState:videoState];
            [(AFBlipCaptureViewController *)toViewController setDelegate:self];
            break;
        }
        case AFBlipVideoViewControllerMediatorState_Filter:
            toViewController = [[AFBlipFilterViewController alloc] initWithDelegate:self videoDimensions:_currentVideoSize];
            [(AFBlipFilterViewController *)toViewController setDelegate:self];
            break;
        case AFBlipVideoViewControllerMediatorState_Share:
            toViewController = [[AFBlipShareViewController alloc] initWithVideoTimelineModel:_videoTimelineModel videoContentURL:_currentFilterVideoFilePath videoContentThumbnailURL:_currentVideoThumbnailFilePath message:_shareVideoMessage];
            [(AFBlipShareViewController *)toViewController setDelegate:self];
            break;
        case AFBlipVideoViewControllerMediatorState_ViewVideo: {
            toViewController = [[AFBlipVideoViewController alloc] initWithDelegate:self];
            typeof(self) __weak wself = self;
            toViewController.loaded = ^(void) {
                [wself setRightBarButtonEnabled:YES];
            };
            break;
        }
        default:
            break;
    }
    
    //Animate
    if(fromViewController) {
        
        //Check for share message
        if(_state == AFBlipVideoViewControllerMediatorState_Share) {
            AFBlipShareViewController *shareViewController = (AFBlipShareViewController *)fromViewController;
            _shareVideoMessage = shareViewController.message;
        }
        
        AFBlipVideoViewControllerMediatorMovementDirection movementDirection = movementDirectionFromState(_state, toState);
        
        CGRect __block newFromFrame   = fromViewController.view.frame;
        CGRect __block newToFrame     = CGRectMake(0, kAFBlipEditProfileToolbarHeight, CGRectGetWidth(toViewController.view.frame), CGRectGetHeight(toViewController.view.frame) - kAFBlipEditProfileToolbarHeight);
        CGRect __block initialToFrame = newToFrame;

        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        
        switch(movementDirection) {
            case AFBlipVideoViewControllerMediatorMovementDirection_LeftToCenter:
                newFromFrame.origin.x   = viewWidth;
                initialToFrame.origin.x = - viewWidth / 2;
                break;
            case AFBlipVideoViewControllerMediatorMovementDirection_RightToCenter:
            default:
                newFromFrame.origin.x   = - viewWidth;
                initialToFrame.origin.x = viewWidth / 2;
                break;
        }
        
        toViewController.view.alpha = 0.0f;
        toViewController.view.frame = initialToFrame;
        [self.view addSubview:toViewController.view];
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
        
        [UIView animateWithDuration:kAFBlipVideoViewControllerMediator_OpenAnimationDuration delay:0.0f usingSpringWithDamping:kAFBlipVideoViewControllerMediator_AnimationSpringDamping initialSpringVelocity:kAFBlipVideoViewControllerMediator_AnimationVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
            
            //From view controller
            fromViewController.view.alpha = 0.0f;
            fromViewController.view.frame = newFromFrame;
            
            //To view controller
            toViewController.view.alpha   = 1.0f;
            toViewController.view.frame   = newToFrame;
            
        } completion:^(BOOL finished) {
            
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
        }];
        
    //Don't need to animate from nil
    } else {
        
        CGRect initialToFrame       = CGRectMake(0, kAFBlipEditProfileToolbarHeight, CGRectGetWidth(toViewController.view.frame), CGRectGetHeight(toViewController.view.frame) - kAFBlipEditProfileToolbarHeight);
        toViewController.view.frame = initialToFrame;
        
        [self.view addSubview:toViewController.view];
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
    }
    
    _currentViewController = toViewController;

    //Update header
    NSString *leftTitle     = [self navBarLeftTitleForState:toState];
    NSString *rightTitle    = [self navBarRightTitleForState:toState];
    NSString *title         = [self navBarTitleForState:toState];

    [self updateLabels:leftTitle rightLabel:rightTitle title:title];
    
    //Enable next and back buttons
    //Left button
    BOOL leftButtonEnabled;
    if([_currentViewController viewControllerCanProceedToPreviousSection]) {
        leftButtonEnabled = YES;
    } else {
        leftButtonEnabled = [self navBarButtonLeftEnabledForDefaultState:toState];
    }
    
    [self setLeftBarButtonEnabled:leftButtonEnabled];
    
    //Right button
    BOOL rightButtonEnabled;
    if([_currentViewController viewControllerCanProceedToNextSection]) {
        rightButtonEnabled = YES;
    } else {
        rightButtonEnabled = [self navBarRightButtonEnabledForDefaultState:toState];
    }
    
    [self setRightBarButtonEnabled:rightButtonEnabled];
    
    _state                 = toState;
}

#pragma mark - Navigation bar actions
- (void)leftButtonAction {
    
    if(![_currentViewController viewControllerCanProceedToPreviousSection]) {
        return;
    }
    
    switch(_state) {
        case AFBlipVideoViewControllerMediatorState_Filter:
            [self changeToState:AFBlipVideoViewControllerMediatorState_Capture];
            break;
        case AFBlipVideoViewControllerMediatorState_Share:
            [self changeToState:AFBlipVideoViewControllerMediatorState_Filter];
            break;
        case AFBlipVideoViewControllerMediatorState_Capture:
        case AFBlipVideoViewControllerMediatorState_None:
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
        default:
            [self dismissView];
            break;
    }
}

- (void)rightButtonAction {
    
    if(![_currentViewController viewControllerCanProceedToNextSection]) {
        return;
    }
    
    switch(_state) {
        case AFBlipVideoViewControllerMediatorState_Capture:
            [self changeToState:AFBlipVideoViewControllerMediatorState_Filter];
            break;
        case AFBlipVideoViewControllerMediatorState_Filter: {
            __weak typeof(self) weakSelf = self;
            [self setRightBarButtonEnabled:NO];
            [self saveFilteredVideoFile:(AFBlipFilterViewController *)_currentViewController filteredVideoURL:[(AFBlipFilterViewController *)_currentViewController filterVideoURLFilePath] completion:^{
                [weakSelf setRightBarButtonEnabled:YES];
                [weakSelf changeToState:AFBlipVideoViewControllerMediatorState_Share];
            }];
            }
            break;
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
            [self setRightBarButtonEnabled:NO];
            [self changeToState:AFBlipVideoViewControllerMediatorState_Capture];
            break;
        case AFBlipVideoViewControllerMediatorState_Share: {
            __weak typeof(self) weakSelf = self;
            [self setRightBarButtonEnabled:NO];
            [(AFBlipShareViewController *)_currentViewController share:^{
                [weakSelf setRightBarButtonEnabled:YES];
            }];
            break;
        }
        case AFBlipVideoViewControllerMediatorState_None:
        default:
            break;
    }
}

#pragma mark - Delegate methods
#pragma mark - AFBlipCaptureViewControllerDelegate
- (void)captureView:(AFBlipCaptureViewController *)captureView didFinishVideoCaptureWithVideoFilePath:(NSURL *)filePath videoThumbnailFilePath:(NSURL *)videoThumbnailFilePath {
    
    _currentVideoFilePath          = filePath;
    _currentVideoThumbnailFilePath = videoThumbnailFilePath;
    [self setRightBarButtonEnabled:YES];
}

- (void)captureViewDidPressReset:(AFBlipCaptureViewController *)captureView {
    
    [self removeCurrentTemporaryFiles];
    _currentVideoFilePath          = nil;
    _currentVideoThumbnailFilePath = nil;
    [self setRightBarButtonEnabled:NO];
}

- (void)captureViewDidUpdateVideoDimensions:(CGSize)videoSize captureView:(AFBlipCaptureViewController *)captureView {
    _currentVideoSize = videoSize;
}

#pragma mark - AFBlipFilterViewControllerDelegate
- (void)saveFilteredVideoFile:(AFBlipFilterViewController *)filterViewController filteredVideoURL:(NSURL *)filteredURL completion:(AFBlipFilterSaveVideoCompletion)completion {
    _currentFilterVideoFilePath = filteredURL;
    [filterViewController saveFilteredVideoFile:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - AFBlipShareViewControllerDelegate
- (void)shareViewControllerDidShare:(AFBlipShareViewController *)shareViewController {
    
    _currentVideoFilePath          = nil;
    _currentVideoThumbnailFilePath = nil;
    
    typeof(self) __weak weakSelf   = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [_delegate videoViewControllerMediatorRequiresTimelineReload:weakSelf];
    }];
}

#pragma mark - AFBlipVideoViewControllerDelegate
- (void)videoViewControllerDidFavouriteVideo:(AFBlipVideoViewController *)videoViewController videoModel:(AFBlipVideoModel *)videoModel {
    
    if(!videoModel) {
        return;
    }
    
    [videoModel setFavourited:!videoModel.favourited];
    [_delegate videoViewControllerMediatorRequiresCellReloadForModel:videoModel mediator:self];
}

- (void)videoViewControllerDidFlag:(AFBlipVideoViewController *)videoViewController videoModel:(AFBlipVideoModel *)videoModel {
    
    if(!videoModel) {
        return;
    }
    
    [videoModel setFlagged:!videoModel.flagged];
    [_delegate videoViewControllerMediatorRequiresCellReloadForModel:videoModel mediator:self];
}

- (void)videoViewControllerDidPressDelete:(AFBlipVideoViewController *)videoViewController {
    
    NSString *title   = NSLocalizedString(@"AFBlipTimelineDeleteVideoAlertViewTitle", nil);
    NSString *message = NSLocalizedString(@"AFBlipTimelineDeleteVideoAlertViewMessage", nil);
    NSString *no      = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertNo", nil);
    NSString *yes     = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertYes", nil);
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithStyle:AFFAlertViewStyle_Default title:title message:message buttonTitles:@[no,yes]];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - Video deletion alert view
#pragma mark - AFFAlertViewDelegate
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    
    //Yes
    if(buttonModel.index == 1) {
        
        [self showActivityIndicator:YES];
        
        NSString *userId                = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
        NSString *accessToken           = [AFBlipKeychain keychain].accessToken;
        AFBlipVideoModel *videoModel    = _viewVideoModel;
        
        typeof(self) __weak weakSelf = self;
        AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
        [factory removeVideoWithUserId:userId accessToken:accessToken videoId:videoModel.videoId videoPath:videoModel.videoURL success:^(AFBlipBaseNetworkModel *networkCallback) {
            
            [weakSelf showActivityIndicator:NO];

            [_delegate videoViewControllerMediatorRequiresTimelineDelete:self videoModel:videoModel];
            [weakSelf dismissView];
            
        } failure:^(NSError *error) {
            
            [weakSelf showActivityIndicator:NO];
        }];
    }
}

- (AFBlipVideoModel *)videoViewControllerVideoModel:(AFBlipVideoViewController *)videoViewController {
    
    return _viewVideoModel;
}

- (AFBlipVideoTimelineModel *)videoViewControllerTimelineVideoModel:(AFBlipVideoViewController *)videoViewController {
    
    return _videoTimelineModel;
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.view.center;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    } else if(show) {
        [_activityIndicator startAnimating];
    }
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Tool bar buttons
- (void)setRightBarButtonEnabled:(BOOL)enabled {
 
    [(UIBarButtonItem *)[self.toolBar.items lastObject] setEnabled:enabled];
}

- (void)setLeftBarButtonEnabled:(BOOL)enabled {
    
    [(UIBarButtonItem *)[self.toolBar.items firstObject] setEnabled:enabled];
}

#pragma mark - Video files removal
- (void)removeCurrentTemporaryFiles {

    //Video
    if(_currentVideoFilePath) {
        unlink([_currentVideoFilePath.path UTF8String]);
    }
    
    //Thumbnail
    if(_currentVideoThumbnailFilePath) {
        unlink([_currentVideoThumbnailFilePath.path UTF8String]);
    }
}

#pragma mark - Utilities
- (NSString *)navBarLeftTitleForState:(AFBlipVideoViewControllerMediatorState)state {
    
    NSString *title;
    
    switch(state) {
        case AFBlipVideoViewControllerMediatorState_Filter:
            title = NSLocalizedString(@"AFBlipVideoViewCaptureTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_Share:
            title = NSLocalizedString(@"AFBlipVideoViewFilterTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
        case AFBlipVideoViewControllerMediatorState_Capture:
        case AFBlipVideoViewControllerMediatorState_None:
            title = NSLocalizedString(@"AFBlipVideoViewCancelButtonTitle", nil);
            break;
        default:
            break;
    }
    
    return title;
}

- (NSString *)navBarRightTitleForState:(AFBlipVideoViewControllerMediatorState)state {
    
    NSString *title;
    
    switch(state) {
        case AFBlipVideoViewControllerMediatorState_Capture:
        case AFBlipVideoViewControllerMediatorState_Filter:
            title = NSLocalizedString(@"AFBlipVideoViewNextButtonTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_Share:
            title = NSLocalizedString(@"AFBlipVideoViewShareButtonTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
            
            if(_videoTimelineModel.type == AFBlipVideoTimelineModelType_Recent) {
                title = NSLocalizedString(@"AFBlipVideoViewReBlipButtonTitle", nil);
            }
            break;
        case AFBlipVideoViewControllerMediatorState_None:
        default:
            break;
    }
    
    return title;
}

- (NSString *)navBarTitleForState:(AFBlipVideoViewControllerMediatorState)state {
    
    NSString *title;
    
    switch(state) {
        case AFBlipVideoViewControllerMediatorState_Capture:
            title = NSLocalizedString(@"AFBlipVideoViewCaptureNavTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_Filter:
            title = NSLocalizedString(@"AFBlipVideoViewFilterNavTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_Share:
            title = NSLocalizedString(@"AFBlipVideoViewShareNavTitle", nil);
            break;
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
            title = [_viewVideoModel userName];
            break;
        case AFBlipVideoViewControllerMediatorState_None:
        default:
            break;
    }
    
    return title;
}

- (BOOL)navBarRightButtonEnabledForDefaultState:(AFBlipVideoViewControllerMediatorState)state {
    
    BOOL enabled = YES;
    
    switch(state) {
        case AFBlipVideoViewControllerMediatorState_Capture:
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
            enabled = NO;
            break;
        case AFBlipVideoViewControllerMediatorState_Filter:
        case AFBlipVideoViewControllerMediatorState_Share:
        case AFBlipVideoViewControllerMediatorState_None:
        default:
            break;
    }
    
    return enabled;
}

- (BOOL)navBarButtonLeftEnabledForDefaultState:(AFBlipVideoViewControllerMediatorState)state {
    
    BOOL enabled = YES;
    
    switch(state) {
        case AFBlipVideoViewControllerMediatorState_Capture:
        case AFBlipVideoViewControllerMediatorState_Filter:
        case AFBlipVideoViewControllerMediatorState_Share:
        case AFBlipVideoViewControllerMediatorState_ViewVideo:
        case AFBlipVideoViewControllerMediatorState_None:
        default:
            break;
    }
    
    return enabled;
}

- (void)dismissView {
    
    [self removeCurrentTemporaryFiles];
    
    [super dismissView];
}

#pragma mark - Dealloc
- (void)dealloc {
    [self removeCurrentTemporaryFiles];
    _delegate = nil;
}

@end
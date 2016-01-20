//
//  AFBlipVideoViewControllerView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTimelineCanvasCellFavouriteButton.h"
#import "AFBlipVideoPlayer.h"
#import "AFBlipVideoViewControllerView.h"
#import "AFDynamicFontMediator.h"
#import "AFBlipAlertView.h"
#import "AFFAlertViewButtonModel.h"

#pragma mark - Constants
const CGFloat kAFBlipVideoViewControllerView_FavouriteButtonSize    = 44.0f;
const CGFloat kAFBlipVideoViewControllerView_FavouriteButtonPadding = 5.0f;
const CGFloat kAFBlipVideoViewControllerView_PaddingLeftMessage     = 12.0f;
const CGFloat kAFBlipVideoViewControllerView_PaddingTopMessage      = 12.0f;

@interface AFBlipVideoViewControllerView () <AFBlipVideoPlayerDelegate, AFDynamicFontMediatorDelegate, AFFAlertViewDelegate> {
    
    AFBlipVideoPlayer                       *_videoPlayer;
    AFBlipTimelineCanvasCellFavouriteButton *_favouritedIcon;
    UIButton                                *_deleteIcon;
    UIButton                                *_flaggedIcon;
    UILabel                                 *_messageLabel;
    AFDynamicFontMediator                   *_dynamicFont;
    BOOL                                    _isVideoFlagged;
}

@end

@implementation AFBlipVideoViewControllerView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame quality:(AFBlipVideoCaptureQuality)quality delegate:(id<AFBlipVideoViewControllerViewDelegate>)delegate userVideo:(BOOL)isUserVideo {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _delegate = delegate;
        [self createVideoPlayer:quality];
        [self createMessage];
        [self createFavouriteButton];
        
        if(isUserVideo) {
            [self createDeleteButton];
        } else {
            [self createFlaggedButton];
        }
        [self createDynamicFont];
    }
    return self;
}

- (void)createVideoPlayer:(AFBlipVideoCaptureQuality)quality {
    
    CGSize defaultSize    = defaultVideoPlayerSize();
    CGFloat width         = defaultSize.width;
    CGFloat height        = defaultSize.height;
    CGFloat padding       = (CGRectGetWidth(self.bounds) - width) / 2;
    CGRect frame          = CGRectMake(padding, padding, width, height);
    
    _videoPlayer          = [[AFBlipVideoPlayer alloc] initWithFrame:frame quality:defaultVideoQuality() state:AFBlipVideoPlayerState_Play];
    _videoPlayer.delegate = self;
    [self addSubview:_videoPlayer];
}

- (void)createMessage {

    CGRect frame                = CGRectMake(kAFBlipVideoViewControllerView_PaddingLeftMessage, CGRectGetMaxY(_videoPlayer.frame) + kAFBlipVideoViewControllerView_PaddingTopMessage, 0, 0);
    _messageLabel               = [[UILabel alloc] initWithFrame:frame];
    _messageLabel.textColor     = [UIColor whiteColor];
    _messageLabel.numberOfLines = 0;
    _messageLabel.text          = [_delegate videoViewVideoMessage:self];
    [self addSubview:_messageLabel];
}

- (void)createFavouriteButton {
    
    CGSize size                 = CGSizeMake(kAFBlipVideoViewControllerView_FavouriteButtonSize, kAFBlipVideoViewControllerView_FavouriteButtonSize);
    CGFloat posX                = CGRectGetMaxX(_videoPlayer.frame) - size.width;
    CGFloat posY                = CGRectGetMaxY(_videoPlayer.frame) +kAFBlipVideoViewControllerView_FavouriteButtonPadding;

    _favouritedIcon             = [[AFBlipTimelineCanvasCellFavouriteButton alloc] initWithFrame:CGRectMake(posX, posY, size.width, size.height)];
    [_favouritedIcon addTarget:self action:@selector(onFavouriteIconPress) forControlEvents:UIControlEventTouchUpInside];
    _favouritedIcon.contentMode = UIViewContentModeCenter;
    [self addSubview:_favouritedIcon];
}

- (void)onFavouriteIconPress {
    
    BOOL favourited = !_favouritedIcon.favourited;
    [_favouritedIcon setFavourited:favourited animated:YES];
    
    [_delegate videoView:self didPressFavourite:favourited];
}

- (void)setVideoFavourited:(BOOL)favourited {
    
    [_favouritedIcon setFavourited:favourited animated:YES];
}

- (void)createDeleteButton {
    
    UIImage *deleteImageUp   = [[self class] deleteImageUp];
    UIImage *deleteImageDown = [[self class] deleteImageDown];
    
    CGSize size                = deleteImageUp.size;
    CGFloat posX               = CGRectGetMaxX(_videoPlayer.frame) - size.width + 10;
    CGFloat posY               = CGRectGetMaxY(_favouritedIcon.frame) +kAFBlipVideoViewControllerView_FavouriteButtonPadding;
    
    _deleteIcon               = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, size.width, size.height)];
    [_deleteIcon addTarget:self action:@selector(onDeleteIconPress) forControlEvents:UIControlEventTouchUpInside];
    [_deleteIcon setImage:deleteImageUp forState:UIControlStateNormal];
    [_deleteIcon setImage:deleteImageDown forState:UIControlStateHighlighted];
    _deleteIcon.contentMode   = UIViewContentModeCenter;
    [self addSubview:_deleteIcon];
}

- (void)onDeleteIconPress {
    
    [_delegate videoViewDidPressDelete:self];
}

- (void)createFlaggedButton {

    UIImage *flagImageEnabled  = [[self class] flagImageEnabled];

    CGSize size                = flagImageEnabled.size;
    CGFloat posX               = CGRectGetMaxX(_videoPlayer.frame) - size.width + 8;
    CGFloat posY               = CGRectGetMaxY(_favouritedIcon.frame) +kAFBlipVideoViewControllerView_FavouriteButtonPadding;

    _flaggedIcon               = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, size.width, size.height)];
    [_flaggedIcon addTarget:self action:@selector(onFlaggedIconPress) forControlEvents:UIControlEventTouchUpInside];
    _flaggedIcon.contentMode   = UIViewContentModeCenter;
    [self addSubview:_flaggedIcon];
}

- (void)onFlaggedIconPress {
    
    BOOL flagged = !_isVideoFlagged;
    
    if (flagged) {
        AFBlipAlertView *alert = [[AFBlipAlertView alloc] initWithTitle:NSLocalizedString(@"AFBlipVideoViewFlagAlertTitle", nil) message:NSLocalizedString(@"AFBlipVideoViewFlagAlertMessage", nil) buttonTitles:@[NSLocalizedString(@"AFBlipVideoViewFlagAlertNo", nil), NSLocalizedString(@"AFBlipVideoViewFlagAlertYes", nil)]];
        alert.delegate = self;
        [alert show];
    } else {
        [self setVideoFlagged:flagged];
        [_delegate videoView:self didPressFlag:flagged];
    }
}

- (void)setVideoFlagged:(BOOL)flagged {

    _isVideoFlagged = flagged;
    
    UIImage *normalImage     = flagged ? [[self class] flagImageEnabled] : [[self class] flagImageDisabled];
    UIImage *highlightImage  = flagged ? [[self class] flagImageDisabled] : [[self class] flagImageEnabled];
    
    [_flaggedIcon setImage:normalImage forState:UIControlStateNormal];
    [_flaggedIcon setImage:highlightImage forState:UIControlStateHighlighted];
}

- (void)createDynamicFont {
    
    _dynamicFont = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFFAlertViewDelegate
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    if (buttonModel.index == 1) {
        [self setVideoFlagged:YES];
        [_delegate videoView:self didPressFlag:YES];
    }
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _messageLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.bounds) - kAFBlipVideoViewControllerView_PaddingLeftMessage - kAFBlipVideoViewControllerView_FavouriteButtonSize - kAFBlipVideoViewControllerView_FavouriteButtonPadding, CGFLOAT_MAX);
    CGRect messageLabelFrame = [_messageLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _messageLabel.font} context:nil];
    
    CGRect frame        = _messageLabel.frame;
    frame.size.width    = CGRectGetWidth(messageLabelFrame);
    frame.size.height   = CGRectGetHeight(messageLabelFrame);
    _messageLabel.frame = frame;
}

#pragma mark - Playback
- (void)start {
    
    [_videoPlayer start:AFBlipVideoPlayerState_Play];
}

- (void)stop {
  
    [_videoPlayer stop];
}

- (void)showActivityIndicator:(BOOL)show {
    
    [_videoPlayer showActivityIndicator:show];
}

#pragma mark - AFBlipVideoPlayerDelegate
- (void)videoPlayerDidFinishCapturingVideo:(AFBlipVideoPlayer *)videoPlayer {
    
    [_delegate videoViewDidFinishPlayingVideo:self];
}

- (NSURL *)videoPlayerOutputFilePath:(AFBlipVideoPlayer *)videoPlayer {
    
    return [_delegate videoViewVideoURL:self];
}

- (void)videoPlayerVideoSize:(CGSize)videoSize videoPlayer:(AFBlipVideoPlayer *)videoPlayer {
    
}

+ (UIImage *)deleteImageUp {
    
    UIImage *deleteImageUp = [UIImage imageNamed:@"BlipsRemoveFriendIcon"];
    
    return deleteImageUp;
}

+ (UIImage *)deleteImageDown {
    
    UIImage *deleteImageDown  = [UIImage imageNamed:@"BlipsRemoveFriendIconDown"];

    return deleteImageDown;
}

+ (UIImage *)flagImageEnabled {
    
    UIImage *flagImageEnabled  = [UIImage imageNamed:@"AFBlipFlagEnabled"];
    
    return flagImageEnabled;
}

+ (UIImage *)flagImageDisabled {
    
    UIImage *flagImageDisabled = [UIImage imageNamed:@"AFBlipFlagDisabled"];
    
    return flagImageDisabled;
}

#pragma mark - Dealloc
- (void)dealloc {
    [_videoPlayer stop];
    _videoPlayer.delegate = nil;
    _delegate = nil;
}

@end
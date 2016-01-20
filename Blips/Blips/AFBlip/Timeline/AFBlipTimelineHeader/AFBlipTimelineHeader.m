//
//  AFBlipTimelineHeader.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTimelineHeader.h"
#import "AFBlipTimelineHeaderRefreshIndicator.h"
#import "AFBlipUserModel.h"
#import "AFBlipVideoTimelineModel.h"
#import "AFDynamicFontMediator.h"
#import "UIColor+AFBlipColor.h"
#import "UIImageView+AFBlipImageView.h"

#pragma mark - Constants
//Min header height
const CGFloat kAFBlipTimelineHeader_HeightMin                     = 44.0f;

//Title
const CGFloat kAFBlipTimelineHeader_TitlePaddingHorizontal        = 15.0f;
const CGFloat kAFBlipTimelineHeader_TitlePaddingVertical          = 11.0f;
const CGFloat kAFBlipTimelineHeader_TitleFontSizeMultiplier       = 3.0f;

//Description
const CGFloat kAFBlipTimelineHeader_DescriptionPadding            = 10.0f;

//Profile image
/** Percentage based on screen height. */
const CGFloat kAFBlipTimelineHeader_ProfileImageHeightPercentage  = 0.14f;
const CGFloat kAFBlipTimelineHeader_ProfileImageHorizontalPadding = 18.0f;
const CGFloat kAFBlipTimelineHeader_ProfileImageBorderWidth       = 2.0f;
const CGFloat kAFBlipTimelineHeader_ProfileImagePaddingVertical   = 13.0f;

//Border
const CGFloat kAFBlipTimelineHeader_BottomBorderWidth             = 1.0f;

//Video button
const CGFloat kAFBlipTimelineHeader_VideoButtonPaddingRight       = 4.0f;

//Refresh indicator height
const CGFloat kAFBlipTimelineHeader_RefreshIndicatorHeight        = 100.0f;

@interface AFBlipTimelineHeader () <AFDynamicFontMediatorDelegate> {
    
    //Refresh indicator
    AFBlipTimelineHeaderRefreshIndicator *_refreshIndicator;
    
    //Font
    AFDynamicFontMediator   *_dynamicFont;
    
    //Frame properties
    CGFloat                 _height;
    CGFloat                 _maxHeight;
    
    //Background
    UIImageView             *_backgroundImageView;
    
    //Bottom border
    UIView                  *_bottomBorder;
    
    //Title
    UILabel                 *_title;

    //Video button
    UIButton                *_videoButton;
    
    //Delete button
    UIButton                *_deleteButton;
    
    //Placeholder arrow
    UIImageView             *_placeholderArrow;
    
    //Placeholder text
    UILabel                 *_placeholderText;
}

@end

@implementation AFBlipTimelineHeader

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _maxHeight = CGRectGetHeight(frame);
        _height    = _maxHeight;
        [self createBackground];
        [self createRefreshIndicator];
        [self createTitle];
        [self createDeleteIcon];
        [self createBottomBorder];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Background
- (void)createBackground {
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipTimelineHeaderBackground"]];
    [self addSubview:_backgroundImageView];
    self.clipsToBounds   = YES;
}

- (void)createRefreshIndicator {
    
    CGRect frame                       = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kAFBlipTimelineHeader_RefreshIndicatorHeight);
    _refreshIndicator                  = [[AFBlipTimelineHeaderRefreshIndicator alloc] initWithFrame:frame];
    _refreshIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_refreshIndicator];
}

#pragma mark - Video button
- (void)createVideoIcon {
    
    //Button
    _videoButton                 = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *buttonImage         = [UIImage imageNamed:@"BlipsVideoIconNew"];
    UIImage *buttonImageDown     = [UIImage imageNamed:@"BlipsVideoIconNewDown"];
    [_videoButton setImage:buttonImage forState:UIControlStateNormal];
    [_videoButton setImage:buttonImageDown forState:UIControlStateHighlighted];
    [_videoButton addTarget:self action:@selector(onVideoIcon) forControlEvents:UIControlEventTouchUpInside];
    [_videoButton sizeToFit];
    
    //Frame
    CGRect videoButtonFrame   = _videoButton.frame;
    videoButtonFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(videoButtonFrame) - kAFBlipTimelineHeader_VideoButtonPaddingRight;
    _videoButton.frame         = CGRectIntegral(videoButtonFrame);
    _videoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_videoButton];
}

- (void)onVideoIcon {
    
    [_delegate timelineHeaderDidSelectNewVideo:self];
}

#pragma mark - Delete button
- (void)createDeleteIcon {
    
    //Button
    _deleteButton                  = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *buttonImage           = [UIImage imageNamed:@"BlipsRemoveFriendIcon"];
    UIImage *buttonImageDown       = [UIImage imageNamed:@"BlipsRemoveFriendIconDown"];
    [_deleteButton setImage:buttonImage forState:UIControlStateNormal];
    [_deleteButton setImage:buttonImageDown forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(onDeleteIcon) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton sizeToFit];

    //Frame
    CGRect deleteButtonFrame       = _deleteButton.frame;
    deleteButtonFrame.origin.x     = CGRectGetWidth(self.bounds) - CGRectGetWidth(deleteButtonFrame) - kAFBlipTimelineHeader_VideoButtonPaddingRight;
    _deleteButton.frame            = CGRectIntegral(deleteButtonFrame);
    _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_deleteButton];
}

- (void)onDeleteIcon {
    
    [_delegate timelineHeaderDidSelectDelete:self];
}

#pragma mark - Create title
- (void)createTitle {
    
    _title                  = [[UILabel alloc] initWithFrame:CGRectMake(kAFBlipTimelineHeader_TitlePaddingHorizontal, kAFBlipTimelineHeader_TitlePaddingVertical, 0, 0)];
    _title.backgroundColor  = [UIColor clearColor];
    _title.textColor        = [UIColor afBlipNavigationBarElementColor];
    [self addSubview:_title];
}

#pragma mark - Bottom border
- (void)createBottomBorder {
    
    CGFloat height                 = kAFBlipTimelineHeader_BottomBorderWidth;
    _bottomBorder                  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height)];
    _bottomBorder.backgroundColor  = [UIColor whiteColor];
    _bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_bottomBorder];
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - Create placeholder arrow
- (void)createPlaceholderArrow {
    
    _placeholderArrow             = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_placeholderArrow];
}

#pragma mark - Create placeholder text
- (void)createPlaceholderText {
    
    _placeholderText                  = [[UILabel alloc] init];
    _placeholderText.font             = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
    _placeholderText.backgroundColor  = [UIColor clearColor];
    _placeholderText.textColor        = [UIColor afBlipNavigationBarElementColor];
    _placeholderText.textAlignment    = NSTextAlignmentCenter;
    _placeholderText.numberOfLines    = 0;
    [self addSubview:_placeholderText];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    //Placeholder
    _title.font           = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
    _placeholderText.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];

    [self setNeedsLayout];
}

#pragma mark - Set user connection model
- (void)setTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    //Display placeholder
    BOOL displayPlaceholder  = !(timelineModel.videos.count > 0);
    self.clipsToBounds   = !displayPlaceholder;

    //Video button visual
    BOOL videoButtonIsHidden = NO;
    
    //Title text
    NSString *titleText;
    
    //Timeline image background
    switch(timelineModel.type) {
        case AFBlipVideoTimelineModelType_Favourites:
            videoButtonIsHidden = YES;
            titleText           = NSLocalizedString(@"AFBlipConnectionsFavouriteBlips", nil);
            break;
        case AFBlipVideoTimelineModelType_All_Recent:
            videoButtonIsHidden = YES;
            titleText           = NSLocalizedString(@"AFBlipConnectionsRecentBlips", nil);
            break;
        case AFBlipVideoTimelineModelType_Recent:
        case AFBlipVideoTimelineModelType_None:
        default:
            titleText                    = timelineModel.timelineTitle;
            
            if(!_videoButton) {
                [self createVideoIcon];
            }
            
            break;
    }
    
    //Display placeholder
    [self displayPlaceholderText:displayPlaceholder displayVideoButton:!videoButtonIsHidden type:timelineModel.type];

    //Title
    _title.text         = titleText;
    [_title sizeToFit];
}

#pragma mark - Placeholder text
- (void)displayPlaceholderText:(BOOL)displayPlaceholderText displayVideoButton:(BOOL)displayVideoButton type:(AFBlipVideoTimelineModelType)type {
    
    //Video button
    if(_videoButton) {
        _videoButton.hidden   = !displayVideoButton;
    }
    
    //Delete button
    BOOL showDeleteButton = (type == AFBlipVideoTimelineModelType_Recent);
    _deleteButton.hidden  = !showDeleteButton;
    
    //Title
    _title.hidden             = displayPlaceholderText;

    //Placeholder arrow
    if(displayPlaceholderText && !_placeholderArrow) {
        [self createPlaceholderArrow];
    }
    
    _placeholderArrow.hidden  = !displayPlaceholderText;
    
    if(_placeholderArrow && !_placeholderArrow.hidden) {

        UIImage *placeholderImage;

        //No timeline found
        if(!displayVideoButton) {
            placeholderImage = [UIImage imageNamed:@"timeline_header_image"];
            
        //No videos found in timeline
        } else {
            placeholderImage = [UIImage imageNamed:@"timeline_header_image_no_videos"];
        }
        
        _placeholderArrow.image = placeholderImage;
        [_placeholderArrow sizeToFit];
    }
    
    //Placeholder text
    if(displayPlaceholderText && !_placeholderText) {
        [self createPlaceholderText];
    }
    _placeholderText.hidden   = !displayPlaceholderText;
    
    if(_placeholderText && !_placeholderText.hidden) {

        NSString *placeholderText;
        
        switch(type) {
            case AFBlipVideoTimelineModelType_Favourites:
                placeholderText   = NSLocalizedString(@"AFBlipTimelineEmptyNoVideosFoundFavourites", nil);
                break;
            case AFBlipVideoTimelineModelType_All_Recent:
                placeholderText   = NSLocalizedString(@"AFBlipTimelineEmptyNoVideosFoundAllRecent", nil);
                break;
            case AFBlipVideoTimelineModelType_Recent:
            case AFBlipVideoTimelineModelType_None:
            default:
                placeholderText   = NSLocalizedString(@"AFBlipTimelineEmptyNoVideosFoundRecent", nil);
                break;
        }
        
        _placeholderText.text = placeholderText;
        
        CGFloat placeholderTextWidth         = CGRectGetWidth(self.bounds) - (kAFBlipTimelineHeader_TitlePaddingHorizontal * 2);
        CGFloat placeholderTextHeight        = CGFLOAT_MAX;
        CGRect placeholderTextBoundingRect   = [placeholderText boundingRectWithSize:CGSizeMake(placeholderTextWidth, placeholderTextHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _placeholderText.font} context:nil];
        placeholderTextBoundingRect.origin.x = kAFBlipTimelineHeader_TitlePaddingHorizontal;
        placeholderTextBoundingRect.origin.y = CGRectGetMaxY(_placeholderArrow.frame) - kAFBlipTimelineHeader_TitlePaddingHorizontal;
        _placeholderText.frame               = placeholderTextBoundingRect;
    }
}

#pragma mark - Set header y position
- (void)setHeaderInternalPosY:(CGFloat)internalPosY {
    
    _height = MAX(kAFBlipTimelineHeader_HeightMin, _maxHeight - internalPosY);
    [self setNeedsLayout];
}

#pragma mark - Max header height
- (CGFloat)maxHeaderHeight {
    
    return _maxHeight;
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Set height
    CGRect frame                          = self.frame;
    frame.size.height                     = _height;
    self.frame                            = CGRectIntegral(frame);
    
    //Position percentage
    const CGFloat alphaPercentage = 1.0f - pow((_height / _maxHeight), 3.0f);
    
    //Background image
    _backgroundImageView.alpha = alphaPercentage;
    _bottomBorder.alpha        = alphaPercentage;
    
    //Title
    static CGFloat titleFontOffsetMin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        titleFontOffsetMin = 2.0f;
    });
    
    CGFloat titleFontOffset       = MAX(((_height / _maxHeight) * kAFBlipTimelineHeader_TitleFontSizeMultiplier), titleFontOffsetMin);
    _title.font                   = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:titleFontOffset];
    [_title sizeToFit];
    
    //Placeholder text and image
    BOOL backgroundImageViewHidden = _placeholderText && !_placeholderText.hidden && !_placeholderArrow.hidden;
    _backgroundImageView.hidden    = backgroundImageViewHidden;
    _bottomBorder.hidden           = backgroundImageViewHidden;
    
    if(_placeholderText && !_placeholderText.hidden && !_placeholderArrow.hidden) {

        //Text
        CGFloat placeholderTextWidth         = CGRectGetWidth(self.bounds) - (kAFBlipTimelineHeader_TitlePaddingHorizontal * 2);
        CGFloat placeholderTextHeight        = CGFLOAT_MAX;
        CGRect placeholderTextBoundingRect   = [_placeholderText.text boundingRectWithSize:CGSizeMake(placeholderTextWidth, placeholderTextHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _placeholderText.font} context:nil];
        placeholderTextBoundingRect.origin.x = kAFBlipTimelineHeader_TitlePaddingHorizontal;
        placeholderTextBoundingRect.origin.y = CGRectGetMaxY(_placeholderArrow.frame) - kAFBlipTimelineHeader_TitlePaddingHorizontal;
        _placeholderText.frame               = placeholderTextBoundingRect;
    }
    
    //Delete icon
    CGRect deleteButtonFrame       = _deleteButton.frame;
    deleteButtonFrame.origin.y     = _videoButton.hidden ?: CGRectGetMaxY(_videoButton.frame);
    _deleteButton.frame            = CGRectIntegral(deleteButtonFrame);
    
    //Refresh indicator
    if(self.userInteractionEnabled) {
        _refreshIndicator.alpha = - alphaPercentage;
    }
    
    if(self.userInteractionEnabled && _height >= _maxHeight + kAFBlipTimelineHeader_RefreshIndicatorHeight) {
        
        CGRect refreshIndicatorFrame      = _refreshIndicator.frame;
        refreshIndicatorFrame.size.height = _height - _maxHeight;
        _refreshIndicator.frame           = refreshIndicatorFrame;
        
        [_delegate timelineHeaderDidSelectRefresh:self];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self) {
        return nil;
    }
    
    return hitView;
}

- (void)setRefreshing:(BOOL)isRefreshing {
    
    self.userInteractionEnabled = !isRefreshing;
    
    if(!self.userInteractionEnabled) {
        [UIView animateWithDuration:0.5f animations:^{
            _refreshIndicator.alpha = 0;
        }];
    }
}
#pragma mark - Dealloc
- (void)dealloc {
    _delegate = nil;
}

@end
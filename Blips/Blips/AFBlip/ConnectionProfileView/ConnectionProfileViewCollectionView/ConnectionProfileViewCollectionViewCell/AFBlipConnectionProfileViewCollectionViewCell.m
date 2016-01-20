//
//  AFBlipConnectionProfileViewCollectionViewCell.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipConnectionProfileViewCollectionViewCell.h"
#import "AFBlipDateFormatter.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFBlipVideoTimelineModel.h"
#import "UIImageView+AFBlipImageView.h"

#pragma mark - Constants
//Title
const CGFloat kAFBlipConnectionProfileViewCollectionViewCell_TitlePosY                = 10.0f;

//Timeline image
const CGFloat kAFBlipConnectionProfileViewCollectionViewCell_TimelineImagePosY        = 44.0f;
const CGFloat kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageWidth       = 84.0f;
const CGFloat kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageBorderWidth = 2.0f;

//Video icon
const CGFloat kAFBlipConnectionProfileViewCollectionViewCell_LabelPadding             = 5.0f;

@interface AFBlipConnectionProfileViewCollectionViewCell () {
    
    UILabel     *_titleLabel;
    UILabel     *_dateLabel;
    UILabel     *_videoIconLabel;
    UIImageView *_iconImageView;
    UIImageView *_videoIconImageView;
    
    AFBlipAWSS3AbstractFactory *_imageFactory;
}

@end

@implementation AFBlipConnectionProfileViewCollectionViewCell

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        [self createBackground];
        [self createBorder];
        [self createImageFactory];
        [self createTitleLabel];
        [self createImageView];
        [self createVideoIcon];
        [self createDateLabel];
    }
    return self;
}

#pragma mark - Create background
- (void)createBackground {
    
    //Selected background
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha];
    self.selectedBackgroundView = selectedBackground;
}

#pragma mark - Create border
- (void)createBorder {
    
    self.contentView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha].CGColor;
    self.contentView.layer.borderWidth = kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth;
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth, CGRectGetHeight(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth);
}

#pragma mark - Create image factory
- (void)createImageFactory {
    
    _imageFactory = [[AFBlipAWSS3AbstractFactory alloc] init];
}

#pragma mark - Create image view
- (void)createImageView {
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(afRound((self.bounds.size.width - kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageWidth) * 0.5f), kAFBlipConnectionProfileViewCollectionViewCell_TimelineImagePosY, kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageWidth, kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageWidth)];
    _iconImageView.contentMode                  = UIViewContentModeCenter;
    _iconImageView.backgroundColor              = [UIColor clearColor];
    
    //Border and corner radius
    _iconImageView.layer.borderWidth            = kAFBlipConnectionProfileViewCollectionViewCell_TimelineImageBorderWidth;
    _iconImageView.layer.borderColor            = [UIColor whiteColor].CGColor;
    _iconImageView.layer.allowsEdgeAntialiasing = YES;
    _iconImageView.layer.rasterizationScale     = [UIScreen mainScreen].scale;
    _iconImageView.layer.shouldRasterize        = YES;
    _iconImageView.layer.cornerRadius           = afRound(CGRectGetWidth(_iconImageView.frame) * 0.5f);
    _iconImageView.layer.masksToBounds          = YES;
    _iconImageView.layer.drawsAsynchronously    = YES;
    [self.contentView addSubview:_iconImageView];
}

#pragma mark - Create title label
- (void)createTitleLabel {
    
    _titleLabel                  = [[UILabel alloc] init];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.backgroundColor  = [UIColor clearColor];
    _titleLabel.textColor        = [UIColor whiteColor];
    _titleLabel.textAlignment    = NSTextAlignmentCenter;
    _titleLabel.font             = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - Create video icon
- (void)createVideoIcon {
    
    //Icon
#warning TODO : Video icon
    UIImage *videoIcon              = [UIImage imageNamed:@"AFBlipSettingsSettingsIcon"];
    _videoIconImageView             = [[UIImageView alloc] initWithImage:videoIcon];
    [self addSubview:_videoIconImageView];

    CGRect videoIconFrame           = _videoIconImageView.frame;
    videoIconFrame.origin.x         = kAFBlipConnectionProfileViewCollectionViewCell_LabelPadding;
    videoIconFrame.origin.y         = CGRectGetHeight(self.bounds) - CGRectGetHeight(videoIconFrame) - kAFBlipConnectionProfileViewCollectionViewCell_LabelPadding;
    _videoIconImageView.frame       = videoIconFrame;

    //Label
    videoIconFrame.origin.x         = CGRectGetMaxX(videoIconFrame);
    _videoIconLabel                 = [[UILabel alloc] initWithFrame:videoIconFrame];
    _videoIconLabel.backgroundColor = [UIColor clearColor];
    _videoIconLabel.textColor       = [UIColor whiteColor];
    _videoIconLabel.font            = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    [self addSubview:_videoIconLabel];
}

#pragma mark - Create date label
- (void)createDateLabel {
    
    CGRect frame               = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
    _dateLabel                 = [[UILabel alloc] initWithFrame:frame];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor       = [UIColor whiteColor];
    _dateLabel.textAlignment   = NSTextAlignmentRight;
    _dateLabel.font            = _videoIconLabel.font;
    [self addSubview:_dateLabel];
}

#pragma mark - Update
- (void)updateWithTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {

    if(!timelineModel) {
        [self setIsNewTimelineIndicator:YES];
        return;
    }
    
    //Icon image view
    typeof(_iconImageView) __weak weakIconImageView   = _iconImageView;
    
    [_imageFactory objectForKey:timelineModel.timelineCoverImageURLString completion:^(NSData *data) {
        [weakIconImageView setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];
    
    //Title
    _titleLabel.text                = timelineModel.timelineTitle;
    [_titleLabel sizeToFit];
    
    CGFloat titleFrameWidthMax      = CGRectGetWidth(self.bounds) - (CGRectGetMinY(_titleLabel.frame) * 2);
    CGFloat titleFrameHeightMax     = kAFBlipConnectionProfileViewCollectionViewCell_TimelineImagePosY -  CGRectGetMinY(_titleLabel.frame);
    CGSize titleFrameSize           = CGSizeMake(titleFrameWidthMax, titleFrameHeightMax);
    NSDictionary *titleAttributes   = @{NSFontAttributeName : _titleLabel.font};
    CGRect titleFrame               = [_titleLabel.text boundingRectWithSize:titleFrameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
    titleFrame.origin.y             = kAFBlipConnectionProfileViewCollectionViewCell_TitlePosY;
    titleFrame.origin.x             = (CGRectGetWidth(self.bounds) - CGRectGetWidth(titleFrame)) / 2;
    _titleLabel.frame               = titleFrame;

    //Video icon count
    _videoIconImageView.hidden      = NO;
    _videoIconLabel.text            = [NSString stringWithFormat:@"%lu", (unsigned long)timelineModel.videos.count];
    [_videoIconLabel sizeToFit];

    //Date label
    _dateLabel.hidden               = NO;

    AFBlipDateFormatter *dateFormat = [AFBlipDateFormatter defaultDateFormatterMonthDayYearFormat];
    NSString *dateString            = [dateFormat stringFromDate:timelineModel.startDate];
    _dateLabel.text                 = dateString;
    [_dateLabel sizeToFit];

    CGRect dateLabelFrame           = _dateLabel.frame;
    dateLabelFrame.origin.x         = CGRectGetWidth(self.bounds) - CGRectGetWidth(dateLabelFrame) - kAFBlipConnectionProfileViewCollectionViewCell_LabelPadding;
    dateLabelFrame.origin.y         = CGRectGetHeight(self.bounds) - CGRectGetHeight(dateLabelFrame) - kAFBlipConnectionProfileViewCollectionViewCell_LabelPadding;
    _dateLabel.frame                = dateLabelFrame;
}

- (void)setIsNewTimelineIndicator:(BOOL)isNewTimelineIndicator {
    
    //Title
    _titleLabel.hidden    = isNewTimelineIndicator;
    
    //Icon image view
    CGColorRef iconImageViewColor      = (isNewTimelineIndicator) ? [UIColor clearColor].CGColor : [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderColor = iconImageViewColor;

    CGRect iconImageViewFrame        = _iconImageView.frame;
    iconImageViewFrame.origin.x      = (CGRectGetWidth(self.bounds) - CGRectGetWidth(iconImageViewFrame)) * 0.5f;

    if(isNewTimelineIndicator) {
        
#warning TODO : '+' icon
        UIImage *newTimelineIndicatorImageView = [UIImage imageNamed:@"AFBlipSettingsFAQIcon"];
        _iconImageView.image                   = newTimelineIndicatorImageView;
        
        iconImageViewFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(iconImageViewFrame)) * 0.5f;
    } else {
        iconImageViewFrame.origin.y = kAFBlipConnectionProfileViewCollectionViewCell_TimelineImagePosY;
    }
    
    _iconImageView.frame       = iconImageViewFrame;

    //Video count icon
    _videoIconImageView.hidden = isNewTimelineIndicator;

    //Date label
    _dateLabel.hidden          = isNewTimelineIndicator;
}

#pragma mark - Prepare for reuse
- (void)prepareForReuse {
    
    [_imageFactory cancelAllOperations];
    _iconImageView.image       = nil;
    _titleLabel.text           = nil;
    _iconImageView.image       = nil;
    _videoIconImageView.hidden = YES;
    _videoIconLabel.text       = nil;
    _dateLabel.text            = nil;
}

@end
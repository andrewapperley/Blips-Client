//
//  AFBlipTimelineCanvasCell.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFAngleUtility.h"
#import "AFBlipBaseNetworkStatics.h"
#import "AFBlipDateFormatter.h"
#import "AFBlipTimelineCanvasCell.h"
#import "AFBlipTimelineCanvasCellFavouriteButton.h"
#import "AFBlipVideoModel.h"
#import "AFBlipAWSS3AbstractFactory.h"
#import "AFDynamicFontMediator.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "UIButton+AFBlipButton.h"
#import "UIImage+ImageEffects.h"

#pragma mark - Constants

//Fade in animation
const CGFloat kAFBlipTimelineCanvasCell_FadeInAnimationDuration           = 0.2f;

//Cell
const CGFloat kAFBlipTimelineCanvasCell_CellHeight                        = 130.0f;

//Small portrait
const CGFloat kAFBlipTimelineCanvasCell_SmallPortraitWidthHeight          = 52.0f;
const CGFloat kAFBlipTimelineCanvasCell_SmallPortraitBorderWidth          = 2.0f;
const CGFloat kAFBlipTimelineCanvasCell_SmallPortraitTopOffset            = 6.0f;

//Portrait
const CGFloat kAFBlipTimelineCanvasCell_PortraitBorderWidth               = kAFBlipTimelineCanvasCell_SmallPortraitBorderWidth;
const CGFloat kAFBlipTimelineCanvasCell_PortraitMinWidthHeight            = 83.0f;//100 at max scale
const CGFloat kAFBlipTimelineCanvasCell_PortraitMaxScale                  = 1.2f;
const CGFloat kAFBlipTimelineCanvasCell_PortraitScalePower                = 1.8f;

//Favourite icon
const CGFloat kAFBlipTimelineCanvasCell_FavouriteIconRotationMax          = 180.0f;
const CGFloat kAFBlipTimelineCanvasCell_FavouriteIconPosXOffsetMultiplier = 6;
const CGFloat kAFBlipTimelineCanvasCell_FavouriteIconPosYOffsetMultiplier = 4;

@interface AFBlipTimelineCanvasCell () <AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator                   *_dynamicFont;
    
    UIButton                                *_smallPortraitImageView;
    UIButton                                *_portraitImageView;
    UILabel                                 *_usernameLabel;
    UILabel                                 *_dateLabel;
    AFBlipTimelineCanvasCellFavouriteButton *_favouritedIcon;
    
    AFHTTPRequestOperation                  *_smallImageRequestOperation;
    AFHTTPRequestOperation                  *_largeImageRequestOperation;
    NSOperationQueue                        *_canvasCellOperation;
    
    CGFloat                                 _parallaxPosition;
}

@end

@implementation AFBlipTimelineCanvasCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self createCellOperationQueue];
        [self createSmallPortraitImageView];
        [self createPortraitImageView];
        [self createUsernameLabel];
        [self createDateLabel];
        [self createFavouriteIcon];
        [self createDynamicFont];
        
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize    = YES;
        self.clipsToBounds            = NO;
    }
    return self;
}

- (void)createCellOperationQueue {
    
    _canvasCellOperation                             = [[NSOperationQueue alloc] init];
    _canvasCellOperation.maxConcurrentOperationCount = 1;
}

- (void)createSmallPortraitImageView {
    
    //Small portrait image
    _smallPortraitImageView                              = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kAFBlipTimelineCanvasCell_SmallPortraitWidthHeight, kAFBlipTimelineCanvasCell_SmallPortraitWidthHeight)];
    [_smallPortraitImageView addTarget:self action:@selector(onProfilePress) forControlEvents:UIControlEventTouchUpInside];
    _smallPortraitImageView.backgroundColor              = [UIColor clearColor];
    _smallPortraitImageView.alpha                        = 0.5f;
    
    //Border and corner radius
    _smallPortraitImageView.layer.borderWidth            = kAFBlipTimelineCanvasCell_SmallPortraitBorderWidth;
    _smallPortraitImageView.layer.borderColor            = [UIColor whiteColor].CGColor;
    _smallPortraitImageView.layer.allowsEdgeAntialiasing = YES;
    _smallPortraitImageView.layer.rasterizationScale     = [UIScreen mainScreen].scale;
    _smallPortraitImageView.layer.shouldRasterize        = YES;
    _smallPortraitImageView.layer.cornerRadius           = afRound(CGRectGetWidth(_smallPortraitImageView.frame) * 0.5f);
    _smallPortraitImageView.layer.masksToBounds          = YES;
    _smallPortraitImageView.layer.drawsAsynchronously    = YES;
    
    [self.contentView addSubview:_smallPortraitImageView];
}

- (void)createPortraitImageView {
    
    //Portrait image
    _portraitImageView                              = [[UIButton alloc] initWithFrame:CGRectMake(afRound((self.bounds.size.width - kAFBlipTimelineCanvasCell_PortraitMinWidthHeight) * 0.5f), afRound((self.bounds.size.height - kAFBlipTimelineCanvasCell_PortraitMinWidthHeight) * 0.5f), kAFBlipTimelineCanvasCell_PortraitMinWidthHeight, kAFBlipTimelineCanvasCell_PortraitMinWidthHeight)];
    [_portraitImageView addTarget:self action:@selector(onVideoPress) forControlEvents:UIControlEventTouchUpInside];
    _portraitImageView.contentMode                  = UIViewContentModeCenter;
    _portraitImageView.backgroundColor              = [UIColor clearColor];
    _portraitImageView.alpha                        = 0.5f;

    //Border and corner radius
    _portraitImageView.layer.borderWidth            = kAFBlipTimelineCanvasCell_PortraitBorderWidth;
    _portraitImageView.layer.borderColor            = [UIColor whiteColor].CGColor;
    _portraitImageView.layer.allowsEdgeAntialiasing = YES;
    _portraitImageView.layer.rasterizationScale     = [UIScreen mainScreen].scale;
    _portraitImageView.layer.shouldRasterize        = YES;
    _portraitImageView.layer.cornerRadius           = afRound(CGRectGetWidth(_portraitImageView.frame) * 0.5f);
    _portraitImageView.layer.masksToBounds          = YES;
    _portraitImageView.layer.drawsAsynchronously    = YES;

    [self.contentView addSubview:_portraitImageView];
}

- (void)createUsernameLabel {

    CGFloat padding                       = 2.0f;
    CGFloat extraLabelWidth               = 25.0f;

    _usernameLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_smallPortraitImageView.frame) - extraLabelWidth, CGRectGetMaxY(_smallPortraitImageView.frame) + padding, CGRectGetWidth(_smallPortraitImageView.bounds) + (extraLabelWidth * 2), 45)];
    _usernameLabel.numberOfLines          = 2;
    _usernameLabel.userInteractionEnabled = NO;
    _usernameLabel.backgroundColor        = [UIColor clearColor];
    _usernameLabel.textColor              = [UIColor whiteColor];
    _usernameLabel.textAlignment          = NSTextAlignmentCenter;

    [self.contentView addSubview:_usernameLabel];
}

- (void)createDateLabel {
    
    CGFloat padding                   = 10.0f;

    _dateLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) - padding, CGRectGetHeight(self.bounds))];
    _dateLabel.autoresizingMask       = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    _dateLabel.numberOfLines          = 2;
    _dateLabel.userInteractionEnabled = NO;
    _dateLabel.backgroundColor        = [UIColor clearColor];
    _dateLabel.textColor              = [UIColor whiteColor];
    _dateLabel.textAlignment          = NSTextAlignmentRight;

    [self.contentView addSubview:_dateLabel];
}

- (void)createFavouriteIcon {
    
    CGSize size                 = [AFBlipTimelineCanvasCellFavouriteButton preferredSize];
    _favouritedIcon             = [[AFBlipTimelineCanvasCellFavouriteButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_favouritedIcon addTarget:self action:@selector(onFavouriteIconPress) forControlEvents:UIControlEventTouchUpInside];
    _favouritedIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_favouritedIcon];
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _usernameLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _dateLabel.font     = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-1];
    [self setNeedsLayout];
}

#pragma mark - Delegate methods
- (void)onVideoPress {
    
    [_delegate timelineCanvasCellDidPressVideo:self];
}

- (void)onProfilePress {
    
    [_delegate timelineCanvasCellDidPressProfile:self];
}

- (void)onFavouriteIconPress {
    
    BOOL favourited = !_favouritedIcon.favourited;

    [_favouritedIcon setFavourited:favourited animated:YES];

    if(favourited) {
        [_delegate timelineCanvasCellDidFavouriteVideo:self];
    } else {
        [_delegate timelineCanvasCellDidUnfavouriteVideo:self];
    }
}

#pragma mark - Data
- (void)setVideoModel:(AFBlipVideoModel *)videoModel {
    
    typeof(self) __weak weakSelf                                      = self;
    typeof(_smallPortraitImageView) __weak weakSmallPortraitImageView = _smallPortraitImageView;
    typeof(_portraitImageView) __weak weakPortraitImageView           = _portraitImageView;
    typeof(_dateLabel) __weak weakDateLabel                           = _dateLabel;
    typeof(_usernameLabel) __weak weakUsernameLabel                   = _usernameLabel;
    typeof(_favouritedIcon) __weak weakFavouritedIcon                 = _favouritedIcon;
    AFBlipAWSS3AbstractFactory __weak *weakImageFactory               = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];

    [_canvasCellOperation addOperationWithBlock:^{
        
        _smallImageRequestOperation = createImage(videoModel.userThumbnailURLString, weakSmallPortraitImageView, weakImageFactory, weakSelf);
        _largeImageRequestOperation = createImage(videoModel.thumbnailURLString, weakPortraitImageView, weakImageFactory, weakSelf);
        createDate(videoModel.date, weakDateLabel);
        createUsername(videoModel.userName, weakUsernameLabel);
        createFavouritedIcon(videoModel.favourited, weakFavouritedIcon);
    }];
}

static AFHTTPRequestOperation * createImage(NSString *URLString, UIButton *button, AFBlipAWSS3AbstractFactory *imageFactory, AFBlipTimelineCanvasCell *cell) {
    
    if(!URLString) {
        return nil;
    }
    
    return [imageFactory objectForKey:URLString completion:^(NSData *data) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            [button setImage:image forState:UIControlStateNormal animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [button setImage:applyTintBlendEffect(overlayColor(), image) forState:UIControlStateHighlighted];
            });
            [button setContentMode:UIViewContentModeScaleAspectFit];
        }
    } failure:nil];
}

static UIColor *overlayColor(void) {
    
    return [UIColor colorWithWhite:1 alpha:0.15f];
}

static void createDate(long date, UILabel *dateLabel) {
    
    if(!date) {
        return;
    }
    
    //Date strings
    static NSString *fullDateStringLinebreak;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fullDateStringLinebreak = @"\n";
    });
    
    AFBlipDateFormatter *dateFormat = [AFBlipDateFormatter defaultDateFormatterMonthDayYearFormat];
    NSDate *topDate = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]]];
    NSMutableString *fullDateString = [[dateFormat stringFromDate:topDate] mutableCopy];
    [fullDateString appendString:fullDateStringLinebreak];
    
    AFBlipDateFormatter *timeFormat = [AFBlipDateFormatter defaultDateFormatterHourMinutesFormat];
    NSDate *bottomDate = [timeFormat dateFromString:[timeFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]]];
    NSString *timeString = [timeFormat stringFromDate:bottomDate];
    if(timeString) {
        [fullDateString appendString:timeString];
    }


    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        dateLabel.text = fullDateString;
    }];
}

static void createUsername(NSString *username, UILabel *usernameLabel) {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        usernameLabel.text = username;
    }];
}

static void createFavouritedIcon(BOOL favourited, AFBlipTimelineCanvasCellFavouriteButton *favouritedButton) {

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [favouritedButton setFavourited:favourited animated:NO];
    }];
}

#pragma mark - Position
- (void)setParallaxPosition:(CGFloat)position {
    
    _parallaxPosition = position;
}

#pragma mark - Adjust cell subview components
- (void)adjustPortraitWithAlphaPercentage:(CGFloat)alphaPercentage positionPercentage:(CGFloat)positionPercentage {
    
    //Position percentage
    positionPercentage           = powf(positionPercentage, kAFBlipTimelineCanvasCell_PortraitScalePower);

    //Portrait scale
    _portraitImageView.transform = CGAffineTransformMakeScale(positionPercentage, positionPercentage);

    //Portrait alpha
    _portraitImageView.alpha     = alphaPercentage;
}

- (void)adjustSmallPortrait:(CGFloat)offsetY alphaPercentage:(CGFloat)alphaPercentage {
    
    static CGFloat centerPositionY;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        centerPositionY = afRound((kAFBlipTimelineCanvasCell_CellHeight - kAFBlipTimelineCanvasCell_SmallPortraitWidthHeight) * 0.5f) - kAFBlipTimelineCanvasCell_SmallPortraitTopOffset;
        
    });
    
    //Small portait frame
    CGFloat leftPositionOffset     = - powf(20.0f, 1.8 - alphaPercentage);

    CGRect smallPortraitFrame      = _smallPortraitImageView.frame;
    smallPortraitFrame.origin.x    = leftPositionOffset + 35;
    smallPortraitFrame.origin.y    = centerPositionY + offsetY * 1.5f;
    _smallPortraitImageView.frame  = smallPortraitFrame;

    //Alpha
    _smallPortraitImageView.alpha = alphaPercentage;
}

- (void)adjustSmallPortraitLabel:(CGFloat)offsetY alphaPercentage:(CGFloat)alphaPercentage {
    
    //Username label
    static CGFloat userNamePadding;
    static CGFloat extraLabelWidth;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userNamePadding = 2.0f;
        extraLabelWidth = 22.0f;
    });

    CGFloat width        = CGRectGetWidth(_smallPortraitImageView.bounds) + (extraLabelWidth * 2);
    CGSize maxSize       = CGSizeMake(width, CGFLOAT_MAX);
    CGRect frame         = [_usernameLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _usernameLabel.font} context:nil];
    frame.size.width     = width;
    frame.origin.x       = CGRectGetMinX(_smallPortraitImageView.frame) - extraLabelWidth;
    frame.origin.y       = CGRectGetMaxY(_smallPortraitImageView.frame) + userNamePadding;

    _usernameLabel.frame = frame;

    //Alpha
    _usernameLabel.alpha = alphaPercentage;
}

- (void)adjustDateLabel:(CGFloat)offsetY alphaPercentage:(CGFloat)alphaPercentage {
    
    //Date frame
    CGRect dateLabelFrame   = _dateLabel.frame;
    dateLabelFrame.origin.y = afRound(((kAFBlipTimelineCanvasCell_CellHeight - CGRectGetHeight(dateLabelFrame)) * 0.5f) + offsetY * 1.5f);
    _dateLabel.frame        = dateLabelFrame;

    //Date alpha
    _dateLabel.alpha        = alphaPercentage;
}

- (void)adjustFavouritedIconWithAlphaPercentage:(CGFloat)alphaPercentage positionPercentage:(CGFloat)positionPercentage {

    //Icon percentage
    positionPercentage               = powf(positionPercentage, kAFBlipTimelineCanvasCell_PortraitScalePower);

    //Icon scale
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(positionPercentage, positionPercentage);

    //Icon rotation
    CGFloat degrees                  = (kAFBlipTimelineCanvasCell_FavouriteIconRotationMax * alphaPercentage) + kAFBlipTimelineCanvasCell_FavouriteIconRotationMax;
    CGFloat radians                  = degreesToRadians(degrees);
    _favouritedIcon.transform        = CGAffineTransformRotate(scaleTransform, radians);

    //Icon alpha
    _favouritedIcon.alpha            = alphaPercentage;

    //Frame
    CGRect frame                     = _favouritedIcon.frame;
    CGFloat portraitMaxX             = CGRectGetMaxX(_portraitImageView.frame);
    CGFloat portraitMinY             = CGRectGetMinY(_portraitImageView.frame);
    _favouritedIcon.center           = CGPointMake(portraitMaxX + (CGRectGetWidth(frame) / kAFBlipTimelineCanvasCell_FavouriteIconPosXOffsetMultiplier), portraitMinY + (CGRectGetHeight(frame) / kAFBlipTimelineCanvasCell_FavouriteIconPosYOffsetMultiplier));
}

#pragma mark - Reuse
- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_smallImageRequestOperation cancel];
    [_largeImageRequestOperation cancel];
    [_canvasCellOperation cancelAllOperations];
    [_portraitImageView.layer removeAllAnimations];
    [_smallPortraitImageView.layer removeAllAnimations];
    [_favouritedIcon.layer removeAllAnimations];

    _portraitImageView.imageView.image      = nil;
    _portraitImageView.alpha                = 0.0f;
    _smallPortraitImageView.imageView.image = nil;
    _smallPortraitImageView.alpha           = 0.0f;
    _dateLabel.text                         = nil;
    _usernameLabel.text                     = nil;
    [_favouritedIcon setFavourited:NO animated:NO];
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    static CGFloat minOffsetY;
    static CGFloat minPosition;
    static CGFloat offsetPercentage;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGRect bounds       = self.bounds;
        CGFloat padding     = (CGRectGetWidth(bounds) - kAFBlipTimelineCanvasCell_CellHeight) * 0.5f;

        minOffsetY          = -padding;
        CGFloat maxOffsetY  = padding;

        minPosition         = -2.0f;
        CGFloat maxPosition = 2.0f;
        offsetPercentage    = (maxOffsetY - minOffsetY) / (maxPosition - minPosition);
    });
    
    //Vertical offset
    CGFloat offsetY           = offsetPercentage * (_parallaxPosition - minPosition) + minOffsetY;

    //Position percentage
    CGFloat positionPercentage = kAFBlipTimelineCanvasCell_PortraitMaxScale - (abs(offsetY) / kAFBlipTimelineCanvasCell_CellHeight);
    CGFloat alphaPercentage    = (positionPercentage * 2) - kAFBlipTimelineCanvasCell_PortraitMaxScale - 0.2f;

    [self adjustPortraitWithAlphaPercentage:alphaPercentage positionPercentage:positionPercentage];
    [self adjustSmallPortrait:offsetY alphaPercentage:alphaPercentage];
    [self adjustSmallPortraitLabel:offsetY alphaPercentage:alphaPercentage];
    [self adjustDateLabel:offsetY alphaPercentage:alphaPercentage];
    [self adjustFavouritedIconWithAlphaPercentage:alphaPercentage positionPercentage:positionPercentage];
}



#pragma mark - Cell height
+ (CGFloat)cellHeight {
    
    return kAFBlipTimelineCanvasCell_CellHeight;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [_smallImageRequestOperation cancel];
    [_largeImageRequestOperation cancel];
    [_canvasCellOperation cancelAllOperations];
    _delegate = nil;
}

@end

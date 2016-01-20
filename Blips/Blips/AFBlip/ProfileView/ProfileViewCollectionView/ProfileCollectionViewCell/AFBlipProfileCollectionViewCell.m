//
//  AFBlipProfileCollectionViewCell.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-09.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipProfileCollectionViewCell.h"
#import "AFBlipProfileViewControllerStatics.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFDynamicFontMediator.h"

const CGFloat kAFBlipProfileCollectionViewCell_TitlePosY             = 52.0f;
const CGFloat kAFBlipProfileCollectionViewCell_IconPosY              = 34.0f;

@interface AFBlipProfileCollectionViewCell () <AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator   *_dynamicFont;
    UILabel                 *_titleLabel;
    UIImageView             *_iconImageView;
}

@end

@implementation AFBlipProfileCollectionViewCell

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        [self createBackground];
        [self createBorder];
        [self createTitleLabel];
        [self createImageView];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Create border
- (void)createBorder {
    
    self.contentView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha].CGColor;
    self.contentView.layer.borderWidth = kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth;
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth, CGRectGetHeight(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth);
}

#pragma mark - Create background
- (void)createBackground {
    
    //Selected background
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha];
    self.selectedBackgroundView = selectedBackground;
}

#pragma mark - Create image view
- (void)createImageView {
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kAFBlipProfileCollectionViewCell_IconPosY, 0, 0)];
    [self applyMotionEffectsToView:_iconImageView];
    [self.contentView addSubview:_iconImageView];
}

#pragma mark - Create title label
- (void)createTitleLabel {
    
    _titleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipProfileCollectionViewCell_TitlePosY, CGRectGetWidth(self.bounds), 60)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.backgroundColor  = [UIColor clearColor];
    _titleLabel.textColor        = [UIColor whiteColor];
    _titleLabel.textAlignment    = NSTextAlignmentCenter;
    [self applyMotionEffectsToView:_titleLabel];
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - Motion effects
- (void)applyMotionEffectsToView:(UIView *)view {
    
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - kAFBlipProfileViewControllerStaticsCollectionViewCell_MotionEffectsX);
    motionEffectHorizontal.maximumRelativeValue         = @( kAFBlipProfileViewControllerStaticsCollectionViewCell_MotionEffectsX);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - kAFBlipProfileViewControllerStaticsCollectionViewCell_MotionEffectsY);
    motionEffectVertical.maximumRelativeValue           = @( kAFBlipProfileViewControllerStaticsCollectionViewCell_MotionEffectsY);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    [view addMotionEffect:motionEffectGroup];
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _titleLabel.font             = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-2.0f];
}

#pragma mark - Updates
- (void)updateImage:(UIImage *)image title:(NSString *)title {

    //Title
    _titleLabel.text        = title;

    //Icon image view
    _iconImageView.image    = image;
    [_iconImageView sizeToFit];

    CGRect iconImageFrame   = _iconImageView.frame;
    iconImageFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(iconImageFrame)) * 0.5f;
    iconImageFrame.origin.y = kAFBlipProfileCollectionViewCell_IconPosY;
    _iconImageView.frame    = iconImageFrame;
}

#pragma mark - Prepare for reuse
- (void)prepareForReuse {
    [super prepareForReuse];

    _titleLabel.text     = nil;
    _iconImageView.image = nil;
}

@end
//
//  AFBlipConnectionsPersonalCollectionViewCell.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-24.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionsPersonalCollectionViewCell.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFDynamicFontMediator.h"

@interface AFBlipConnectionsPersonalCollectionViewCell() <AFDynamicFontMediatorDelegate> {
    UIImageView* _sectionImageView;
    UILabel* _sectionNameLabel;
    AFDynamicFontMediator   *_dynamicFont;
}

@end

@implementation AFBlipConnectionsPersonalCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _sectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAFBlipConnectionPersonalProfileXOffset, kAFBlipConnectionPersonalProfileYOffset, kAFBlipConnectionPersonalProfileWidth, kAFBlipConnectionPersonalProfileWidth)];
        
        _sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sectionImageView.frame) - 10.0f, self.frame.size.width, 60.0f)];
        _sectionNameLabel.textAlignment = NSTextAlignmentCenter;
        _sectionNameLabel.textColor = [UIColor whiteColor];
        _sectionNameLabel.numberOfLines = 2;
        _sectionNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self applyMotionEffectsToView:_sectionImageView];
        [self applyMotionEffectsToView:_sectionNameLabel];
        
        [self.contentView addSubview:_sectionImageView];
        [self.contentView addSubview:_sectionNameLabel];
        
        [self createBorder];
        [self createBackground];
        [self createDynamicFont];
    }
    return self;
}

- (void)createPersonalCellWithModel:(AFBlipConnectionsPersonalModel *)model {
    
    [_sectionImageView setImage:model.sectionImage];
    _sectionNameLabel.text = model.sectionName;
    
}

- (void)createBorder {
    
    self.contentView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha].CGColor;
    self.contentView.layer.borderWidth = kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth;
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth, CGRectGetHeight(self.frame) + kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth);
}

- (void)createBackground {
    
    //Selected background
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha];
    self.selectedBackgroundView = selectedBackground;
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
    
    _sectionNameLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipConnectionUserProfileNameSizeOffset];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _sectionImageView.image = nil;
    _sectionNameLabel.text  = nil;

}

@end
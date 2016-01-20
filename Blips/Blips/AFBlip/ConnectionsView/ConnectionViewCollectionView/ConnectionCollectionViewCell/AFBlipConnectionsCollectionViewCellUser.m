//
//  AFBlipConnectionsCollectionViewCellUser.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipConnectionsCollectionViewCellUser.h"
#import "AFBlipUserModel.h"
#import "AFBlipConnectionModel.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipNotificationBadge.h"
#import "AFDynamicFontMediator.h"
#import "UIImageView+AFBlipImageView.h"
#import "AFBlipMainViewControllerStatics.h"

#import <AFHTTPRequestOperation.h>

static const NSInteger kAFBlipsDisplayNameWidthMargin                          = 5;
static const CGFloat AFBlipConnectionsCollectionViewCellUser_badgePaddingTop   = - 5.0f;
static const CGFloat AFBlipConnectionsCollectionViewCellUser_badgePaddingRight = - 14.0f;

@interface AFBlipConnectionsCollectionViewCellUser() <AFDynamicFontMediatorDelegate> {
    UIImageView* _profileImageView;
    UILabel* _displayNameLabel;
    
    AFHTTPRequestOperation *_imageRequestOperation;
    
    AFBlipNotificationBadge* _notification;
    AFDynamicFontMediator   *_dynamicFont;
}

@end

@implementation AFBlipConnectionsCollectionViewCellUser

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createCommonElements];
        [self createDynamicFont];
    }
    return self;
}

- (void)createUserWithConnectionModel:(AFBlipConnectionModel *)model {
    
    typeof(_profileImageView) __weak weakProfileImageView = _profileImageView;
    _imageRequestOperation = [[AFBlipAWSS3AbstractFactory sharedAWS3Factory] objectForKey:model.connectionFriend.userImageUrl completion:^(NSData *data) {
        [weakProfileImageView setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];
    
    _displayNameLabel.text = model.connectionFriend.displayName;

}

- (void)createUserWithSearchModel:(AFBlipUserModel *)model {
    
    typeof(_profileImageView) __weak weakProfileImageView = _profileImageView;
    _imageRequestOperation = [[AFBlipAWSS3AbstractFactory sharedAWS3Factory] objectForKey:model.userImageUrl completion:^(NSData *data) {
        [weakProfileImageView setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];
    
    _displayNameLabel.text = model.displayName;
}

- (void)createCommonElements {
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAFBlipConnectionUserProfileXOffset, kAFBlipConnectionUserProfileYOffset, kAFBlipConnectionUserProfileWidth, kAFBlipConnectionUserProfileWidth)];
    _profileImageView.backgroundColor = [UIColor clearColor];
    _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    _profileImageView.clipsToBounds = YES;
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width * 0.5;
    _profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _profileImageView.layer.borderWidth = 2.0f;
    
    _displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAFBlipsDisplayNameWidthMargin, CGRectGetMaxY(_profileImageView.frame) - 8.0f, self.frame.size.width - kAFBlipsDisplayNameWidthMargin*2, 60)];
    _displayNameLabel.textAlignment = NSTextAlignmentCenter;
    _displayNameLabel.textColor = [UIColor whiteColor];
    _displayNameLabel.numberOfLines = 2;
    _displayNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize notificationBadgeSize = [AFBlipNotificationBadge preferredSize];
    _notification = [[AFBlipNotificationBadge alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_profileImageView.frame) + AFBlipConnectionsCollectionViewCellUser_badgePaddingRight, CGRectGetMinY(_profileImageView.frame) + AFBlipConnectionsCollectionViewCellUser_badgePaddingTop, notificationBadgeSize.width, notificationBadgeSize.height)];
    
    [self applyMotionEffectsToView:_profileImageView];
    [self applyMotionEffectsToView:_displayNameLabel];
    [self applyMotionEffectsToView:_notification];
    [self addSubview:_profileImageView];
    [self addSubview:_displayNameLabel];
    [self addSubview:_notification];
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
    
    _displayNameLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipConnectionUserProfileNameSizeOffset];
}

- (void)updateUserWithNotifications:(NSInteger)notificationCount badgeType:(AFBlipNotificationBadgeType)badgeType {
    
    [_notification updateBadgeCount:notificationCount badgeType:badgeType animated:YES];
}

- (BOOL)hasNotifications {
    
    return _notification.badgeCount > 0;
}

- (void)prepareForReuse {
    
    [_imageRequestOperation cancel];
    _displayNameLabel.text = nil;
    _profileImageView.image = nil;
    [_notification updateBadgeCount:0 badgeType:AFBlipNotificationBadgeType_Default animated:NO];
}

@end

//
//  AFBlipConnectionsCollectionViewCell.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionsCollectionViewCell.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFBlipUserModel.h"

const NSTimeInterval kAFBlipConnectionsCollectionViewCell_cellAnimationDurationIn = 0.2f;

@implementation AFBlipConnectionsCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _user = [[AFBlipConnectionsCollectionViewCellUser alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.contentView addSubview:_user];
        [self createCellObjects];
    }
    return self;
}

- (void)createConnection:(AFBlipConnectionModel *)user {
    
    [_user createUserWithConnectionModel:user];
    [self animateInCell];
}

- (void)createSearchResult:(AFBlipUserModel *)user {
    
    [_user createUserWithSearchModel:user];
    [self animateInCell];
}

- (void)animateInCell {
    
    typeof(_user) __weak weakUser              = _user;

    //Scale
    CGFloat scale                            = 1.025f;
    __block CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    
    //Animation
    CGFloat animationDuration                = kAFBlipConnectionsCollectionViewCell_cellAnimationDurationIn / 2;
    
    [UIView animateWithDuration:animationDuration animations:^{
        weakUser.transform        = scaleTransform;
    } completion:^(BOOL finished) {
        
        scaleTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        [UIView animateWithDuration:animationDuration animations:^{
            weakUser.transform        = scaleTransform;
        } completion:nil];
    }];
}

- (void)updateUsersNotifications:(NSInteger)notificationCount badgeType:(AFBlipNotificationBadgeType)badgeType {
    [_user updateUserWithNotifications:notificationCount badgeType:badgeType];
}

- (void)createCellObjects {
    [self createBorder];
    [self createBackground];
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

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_user prepareForReuse];
}

@end
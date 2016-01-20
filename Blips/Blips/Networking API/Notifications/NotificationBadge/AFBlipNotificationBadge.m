//
//  AFBlipNotificationBadge.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipNotificationBadge.h"

const CGFloat kAFBlipNotificationBadge_borderWidth              = 2.0f;
const NSTimeInterval kAFBlipNotificationBadge_animationDuration = 0.2f;

@interface AFBlipNotificationBadge () {
    
    UILabel      *_labelCount;
    UIImageView  *_background;
}

@end

@implementation AFBlipNotificationBadge

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.userInteractionEnabled = NO;
        self.clipsToBounds          = NO;
        [self createBackground];
        [self createLabelCount];
        [self updateBadgeCount:0 badgeType:AFBlipNotificationBadgeType_Default animated:NO];
    }
    return self;
}

- (void)createBackground {
    
    _background                          = [[UIImageView alloc] initWithFrame:self.bounds];
    _background.autoresizingMask         = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_background];
}

- (void)createLabelCount {
    
    _labelCount                 = [[UILabel alloc] initWithFrame:self.bounds];
    _labelCount.font            = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    _labelCount.textColor       = [UIColor whiteColor];
    _labelCount.backgroundColor = [UIColor clearColor];
    _labelCount.textAlignment   = NSTextAlignmentCenter;
    [_background addSubview:_labelCount];
}

#pragma mark - Badge count
- (void)updateBadgeCount:(NSUInteger)badgeCount badgeType:(AFBlipNotificationBadgeType)badgeType animated:(BOOL)animated {
    
    _badgeCount = badgeCount;
    
    [self updateBackground:badgeType];
    [self updateLabelAlpha:badgeType];
    [self animateCount:animated];
}

- (void)updateBackground:(AFBlipNotificationBadgeType)badgeType {
    
    UIImage *backgroundImage = [AFBlipNotificationBadge backgroundImageForBadgeType:badgeType];
    _background.image        = backgroundImage;
}

- (void)updateLabelAlpha:(AFBlipNotificationBadgeType)badgeType {
    
    CGFloat alpha = [AFBlipNotificationBadge labelAlphaForBadgeType:badgeType];
    _labelCount.alpha = alpha;
}

- (void)animateCount:(BOOL)animated {

    //Alpha
    NSUInteger __block alpha                        = (_badgeCount > 0) ? 1 : 0;
    
    //Check for no animation
    if(!animated) {
        _background.alpha = alpha;
        return;
    }
    
    typeof(_background) __weak weakBackground              = _background;
    
    //Icon scale
    CGFloat scale                            = 1.15f;
    __block CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    
    //Animation
    CGFloat animationDuration                = kAFBlipNotificationBadge_animationDuration / 2;
    
    if(alpha == 1) {
        _background.alpha = alpha;
    }
    
    _labelCount.text = [NSString stringWithFormat:@"%ld", (unsigned long)_badgeCount];
    
    [UIView animateWithDuration:animationDuration animations:^{
        weakBackground.transform        = scaleTransform;
    } completion:^(BOOL finished) {
        
        scaleTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        [UIView animateWithDuration:animationDuration animations:^{
            weakBackground.transform        = scaleTransform;
            
            if(alpha == 0) {
                weakBackground.alpha = alpha;
            }
        } completion:nil];
    }];
}

#pragma mark - Utilities
+ (UIImage *)backgroundImageForBadgeType:(AFBlipNotificationBadgeType)badgeType {
    
    UIImage *image;
    switch(badgeType) {
        case AFBlipNotificationBadgeType_Mirrored:
            image = [UIImage imageNamed:@"notifications_icon"];
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:UIImageOrientationUpMirrored];
            break;
        case AFBlipNotificationBadgeType_Default:
        case AFBlipNotificationBadgeType_Connection:
            image = [UIImage imageNamed:@"notifications_icon"];
            break;
        case AFBlipNotificationBadgeType_FriendRequest:
        case AFBlipNotificationBadgeType_NewlyAddedFriend:
        default:
            image = [UIImage imageNamed:@"notifications_icon_friend"];
            break;
    }
    
    return image;
}

+ (CGFloat)labelAlphaForBadgeType:(AFBlipNotificationBadgeType)badgeType {
    
    CGFloat alpha = 1.0f;
    switch(badgeType) {
        case AFBlipNotificationBadgeType_FriendRequest:
        case AFBlipNotificationBadgeType_NewlyAddedFriend:
            alpha = 0.0f;
            break;
        default:
            alpha = 1.0f;
            break;
    }
    
    return alpha;
}

#pragma mark - Preferred size
+ (CGSize)preferredSize {
    
    return CGSizeMake(25.0f, 25.0f);
}

@end

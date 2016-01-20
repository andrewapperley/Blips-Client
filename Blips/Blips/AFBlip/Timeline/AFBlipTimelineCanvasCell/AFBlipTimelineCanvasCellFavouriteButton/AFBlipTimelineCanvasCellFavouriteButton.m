//
//  AFBlipTimelineCanvasCellFavouriteButton.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-21.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTimelineCanvasCellFavouriteButton.h"
#import "UIImage+ImageWithColor.h"
#import "UIImage+ResizeImage.h"

#pragma mark - Constants
const NSTimeInterval kAFBlipTimelineCanvasCellFavouriteButton_animationDurationIn  = 0.3f;
const NSTimeInterval kAFBlipTimelineCanvasCellFavouriteButton_animationDurationOut = 0.3f;

@interface AFBlipTimelineCanvasCellFavouriteButton () {
    
    UIImageView *_backgroundImageView;
    UIImage     *_unfavouritedImage;
    UIImage     *_favouritedImage;
}

@end

@implementation AFBlipTimelineCanvasCellFavouriteButton

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        _favourited = YES;
        self.clipsToBounds = NO;
        [self createBackgroundImage];
        [self createImages];
        [self setFavourited:NO animated:NO];
    }
    return self;
}

#pragma mark - Background
- (void)createBackgroundImage {
    
    _backgroundImageView                  = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.contentMode      = UIViewContentModeCenter;
    [self addSubview:_backgroundImageView];
}

#pragma mark - Images
- (void)createImages {
        
    CGSize size = [self preferredImageSize];
    _unfavouritedImage              = [[UIImage imageNamed:@"AFBlipFavouriteBlipsIcon"] resizeImage:size];
    _favouritedImage                = [[[UIImage imageNamed:@"AFBlipFavouriteBlipsIcon"] imageWithColor:[UIColor afBlipOrangeSecondaryColor]] resizeImage:size];
}

#pragma mark - Set favourited
- (void)setFavourited:(BOOL)favourited animated:(BOOL)animated {
    
    if(_favourited == favourited) {
        return;
    }
    
    _favourited = favourited;
    if(_favourited) {
        [self animateIconToFavouritedStateAnimated:animated];
    } else {
        [self animateIconToUnfavouritedStateAnimated:animated];
    }
}

- (void)animateIconToFavouritedStateAnimated:(BOOL)animated {
    
    _backgroundImageView.image = _favouritedImage;
    
    if(animated) {
        [self animateWithDuration:kAFBlipTimelineCanvasCellFavouriteButton_animationDurationIn];
    }
}

- (void)animateIconToUnfavouritedStateAnimated:(BOOL)animated {
    
    _backgroundImageView.image = _unfavouritedImage;
    
    if(animated) {
        [self animateWithDuration:kAFBlipTimelineCanvasCellFavouriteButton_animationDurationOut];
    }
}

- (void)animateWithDuration:(NSTimeInterval)duration {
    
    //Icon scale
   CGFloat scale                            = 1.35f;
   __block CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);

    //Animation
   CGFloat animationDuration                = duration / 2;

    [UIView animateWithDuration:animationDuration animations:^{
        _backgroundImageView.transform        = scaleTransform;
    } completion:^(BOOL finished) {
        
        scaleTransform = CGAffineTransformMakeScale(1.0f, 1.0f);

        [UIView animateWithDuration:animationDuration animations:^{
            _backgroundImageView.transform        = scaleTransform;
        } completion:nil];
    }];
}

#pragma mark - Preferred size
+ (CGSize)preferredSize {
    
    return CGSizeMake(35.0f, 35.0f);
}

- (CGSize)preferredImageSize {
    
    CGFloat padding = 5.0f;
    return CGSizeMake(CGRectGetWidth(self.bounds) - padding, CGRectGetHeight(self.bounds) - padding);
}

@end
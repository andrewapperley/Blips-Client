//
//  AFBlipActivityIndicator.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-28.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"

#pragma mark - Constants
const NSTimeInterval kAFBlipActivityIndicator_durationShowIn      = 0.2f;
const NSTimeInterval kAFBlipActivityIndicator_durationShowOut     = 0.125f;
const NSTimeInterval kAFBlipActivityIndicator_durationPerRotation = 0.035f;
NSString *const kAFBlipActivityIndicator_animationKey             = @"AFBlipActivityIndicatorAnimationKey";

@interface AFBlipActivityIndicator () {
    
    BOOL    _isAnimating;
}

@end

@implementation AFBlipActivityIndicator

#pragma mark - Init
- (instancetype)initWithStyle:(AFBlipActivityIndicatorType)type {
    
    CGSize size  = [AFBlipActivityIndicator indicatorSizeForType:type];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self         = [super initWithFrame:frame];
    if(self) {
        
        _isAnimating     = NO;
        self.alpha       = 0.0f;
        UIImage *image   = [UIImage imageNamed:@"AFBlipActivityIndicator"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self.layer setContents:(id)image.CGImage];
    }
    return self;
}

#pragma mark - Animations
- (void)startAnimating {
    
    if(_isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    
    //Show in animation
    CATransform3D currentTransform = CATransform3DMakeScale(1.25f, 1.25f, 1.0f);
    self.layer.transform           = currentTransform;
    self.alpha                     = 0.0f;
    
    __weak typeof(self) weakSelf  = self;
    
    //Animate
    [UIView animateWithDuration:kAFBlipActivityIndicator_durationShowIn delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        weakSelf.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
        weakSelf.alpha           = 1.0f;
    } completion:nil];
    
    //Spin
    CABasicAnimation *animation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.cumulative          = YES;
    animation.fillMode            = kCAFillModeForwards;
    animation.toValue             = @(M_1_PI);
    animation.repeatCount         = NSUIntegerMax;
    animation.duration            = kAFBlipActivityIndicator_durationPerRotation;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:animation forKey:kAFBlipActivityIndicator_animationKey];
}

- (void)stopAnimating {
    
    if(!_isAnimating) {
        return;
    }
    
    _isAnimating = NO;

    //Show out animation
    __weak typeof(self) weakSelf  = self;
    
    //Animate
    [UIView animateWithDuration:kAFBlipActivityIndicator_durationShowOut delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        weakSelf.layer.transform = CATransform3DMakeScale(0.85f, 0.85f, 1.0f);
        weakSelf.alpha           = 0.0f;
    } completion:^(BOOL finished) {
        
        if(!_isAnimating) {
            [weakSelf.layer removeAllAnimations];
        }
    }];
}

#pragma mark - Utilities
+ (CGSize)indicatorSizeForType:(AFBlipActivityIndicatorType)type {
    
    CGSize size;
    
    switch(type) {
        case AFBlipActivityIndicatorType_Small:
            size = CGSizeMake(35.0f, 35.0f);
            break;
        case AFBlipActivityIndicatorType_Large:
        default:
            size = CGSizeMake(44.0f, 44.0f);
            break;
    }
    return size;
}

@end
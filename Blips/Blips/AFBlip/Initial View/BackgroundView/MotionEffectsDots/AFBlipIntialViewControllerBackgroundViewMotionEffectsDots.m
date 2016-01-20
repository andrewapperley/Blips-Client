//
//  AFBlipIntialViewControllerBackgroundViewMotionEffectsDots.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipIntialViewControllerBackgroundViewMotionEffectsDots.h"

const CGFloat kAFBlipIntialViewControllerBackgroundViewMotionEffectsDots_MotionEffectsAmountMin = 10.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundViewMotionEffectsDots_MotionEffectsAmountMax = 100.0f;

@interface AFBlipIntialViewControllerBackgroundViewMotionEffectsDots () {
    
    CGPoint _motionEffectsAmount;
}

@end

@implementation AFBlipIntialViewControllerBackgroundViewMotionEffectsDots

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _enableMotionEffects = YES;
        [self createBackground];
    }
    return self;
}

#pragma mark - Create background
- (void)createBackground {
    
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    
    //Effects
    CGFloat randomAmount = arc4random_uniform(kAFBlipIntialViewControllerBackgroundViewMotionEffectsDots_MotionEffectsAmountMax) + kAFBlipIntialViewControllerBackgroundViewMotionEffectsDots_MotionEffectsAmountMin;
    _motionEffectsAmount = CGPointMake(randomAmount, randomAmount);
    UIMotionEffectGroup *motionEffectGroup = [self createMotionEffectGroupWithMotionAmount:_motionEffectsAmount];
    
    [self addMotionEffect:motionEffectGroup];
}

- (UIMotionEffectGroup *)createMotionEffectGroupWithMotionAmount:(CGPoint)moitionAmount {
    
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - moitionAmount.x);
    motionEffectHorizontal.maximumRelativeValue         = @( moitionAmount.x);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - moitionAmount.y);
    motionEffectVertical.maximumRelativeValue           = @( moitionAmount.y);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    return motionEffectGroup;
}

#pragma mark - Motion effects enabling
- (void)setEnableMotionEffects:(BOOL)enableMotionEffects {
    
    if(_enableMotionEffects == enableMotionEffects) {
        return;
    }
    
    _enableMotionEffects = enableMotionEffects;
    
    CGPoint motionEffectsAmount;
    if(_enableMotionEffects) {
        motionEffectsAmount = _motionEffectsAmount;
    } else {
        motionEffectsAmount = CGPointZero;
    }
    
    NSArray *motionEffects = [self motionEffects];
    CGFloat minValue;
    CGFloat maxValue;
    for(UIMotionEffectGroup *motionEffectGroup in motionEffects) {
        
        if(![motionEffectGroup isKindOfClass:[UIMotionEffectGroup class]]) {
            continue;
        }
        
        for(UIInterpolatingMotionEffect *motionEffect in motionEffectGroup.motionEffects) {
            
            //X
            if(motionEffect.type == UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis) {
                
                    minValue = - motionEffectsAmount.x;
                    maxValue = motionEffectsAmount.x;
                //Y
                } else {
                    minValue = - motionEffectsAmount.y;
                    maxValue = motionEffectsAmount.y;
                }
                
                motionEffect.minimumRelativeValue           = @(minValue);
                motionEffect.maximumRelativeValue           = @(maxValue);
        }
    }
}

@end
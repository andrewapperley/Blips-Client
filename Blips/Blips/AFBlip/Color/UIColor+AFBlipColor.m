//
//  UIColor+AFBlipColor.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "UIColor+AFBlipColor.h"

@implementation UIColor (UIColor_AFBlipColor)

+ (UIColor *)afBlipTransparentBlackColor {
    return [UIColor colorWithWhite:0 alpha:0.4f];
}

+ (UIColor *)afBlipNavigationBarColor {
    
    return [UIColor colorWithWhite:0.0f alpha:0.2f];
}

+ (UIColor *)afBlipModalBackgroundColor {
    
    return [UIColor colorWithRed:0.386 green:0.38 blue:0.49 alpha:0.95];
}

+ (UIColor *)afBlipNavigationBarElementColor {
    
    return [UIColor whiteColor];
}

+ (UIColor *)afBlipModalHeaderBackgroundColor {
    
    return [UIColor colorWithRed:0.29 green:0.294 blue:0.404 alpha:0.95];
}

+ (UIColor *)afBlipDarkGreyTextColor {
    
    return [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1.0f];
}

+ (UIColor *)afBlipToggleSwitchColor {
    
    return [UIColor colorWithRed:0.27 green:0.294 blue:0.478 alpha:1];
}

+ (UIColor *)afBlipOrangeSecondaryColor {
    
    return [UIColor colorWithRed:0.997 green:0.793 blue:0.228 alpha:1.000];
}

+ (UIColor *)afBlipVideoProgressBarColor {
    
    return [[self class] afBlipOrangeSecondaryColor];
}

+ (UIColor *)afBlipPurpleTextColor {
    
    return [UIColor colorWithRed:0.290 green:0.106 blue:0.592 alpha:1.000];
}

+ (UIColor *)afBlipDangerButtonColor:(CGFloat)alpha {
    
    return [UIColor colorWithRed:0.91f green:0.26f blue:0.21f alpha:alpha];
}

+ (UIColor *)afBlipBuyButtonColor:(CGFloat)alpha {
    
    return [UIColor colorWithRed:0.29f green:0.90f blue:0.21f alpha:alpha];
}

+ (UIColor *)afBlipRecordButtonNonRecordingStateColor {
    
    return [UIColor colorWithWhite:1.0f alpha:0.8f];
}

+ (UIColor *)afBlipRecordButtonRecordingStateColor {
    
    return [UIColor colorWithRed:0.91f green:0.26f blue:0.21f alpha:0.9f];
}

@end
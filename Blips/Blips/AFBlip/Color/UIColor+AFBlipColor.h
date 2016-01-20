//
//  UIColor+AFBlipColor.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (UIColor_AFBlipColor)

/** Returns the transparent black color. */
+ (UIColor *)afBlipTransparentBlackColor;
/** Returns the navigation bar color. */
+ (UIColor *)afBlipNavigationBarColor;
/** Returns the modal background color. */
+ (UIColor *)afBlipModalBackgroundColor;
/** Returns the modal header background color. */
+ (UIColor *)afBlipModalHeaderBackgroundColor;
/** Returns the navigation bar element color. */
+ (UIColor *)afBlipNavigationBarElementColor;
/** Returns the dark grey text color. */
+ (UIColor *)afBlipDarkGreyTextColor;
/** Returns the toggle switch purple color. */
+ (UIColor *)afBlipToggleSwitchColor;
/** Returns the orange secondary app color. */
+ (UIColor *)afBlipOrangeSecondaryColor;
/** Returns the video progress bar color. */
+ (UIColor *)afBlipVideoProgressBarColor;
/** Returns the purple text color. */
+ (UIColor *)afBlipPurpleTextColor;
/** Returns the danger button color. */
+ (UIColor *)afBlipDangerButtonColor:(CGFloat)alpha;
/** Returns the purchase button color. */
+ (UIColor *)afBlipBuyButtonColor:(CGFloat)alpha;
/** Returns the record button non-recording state color. */
+ (UIColor *)afBlipRecordButtonNonRecordingStateColor;
/** Returns the record button recording state color. */
+ (UIColor *)afBlipRecordButtonRecordingStateColor;

@end

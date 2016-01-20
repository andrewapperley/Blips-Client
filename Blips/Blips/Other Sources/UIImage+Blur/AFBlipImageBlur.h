//
//  AFBlipImageBlur.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

@interface UIImage (AFBlipImageBlur)

- (UIImage *)applyAFBlipPanelBlur;
- (UIImage *)applyAFBlipBackgroundBlur;
+ (UIImage *)imageScreenshotFromView:(UIView *)view size:(CGSize)size offset:(CGSize)offset newHeight:(NSInteger)newHeight;
+ (UIImage *)imageScreenshotFromView:(UIView *)view size:(CGSize)size;
@end
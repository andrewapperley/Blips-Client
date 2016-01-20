//
//  AFBlipImageBlur.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipImageBlur.h"

@implementation UIImage (AFBlipImageBlur)

- (UIImage *)applyAFBlipPanelBlur {
    
    NSAssert([self isKindOfClass:[UIImage class]], @"Image must be class type of UIImage");
    
    return [self applyBlurWithRadius:5 tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] saturationDeltaFactor:0.7 maskImage:nil];
}

- (UIImage *)applyAFBlipBackgroundBlur {
    
    NSAssert([self isKindOfClass:[UIImage class]], @"Image must be class type of UIImage");
    
    return [self applyBlurWithRadius:15 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
}

+ (UIImage *)imageScreenshotFromView:(UIView *)view size:(CGSize)size offset:(CGSize)offset newHeight:(NSInteger)newHeight {
    
    UIImage* tempImage = [UIImage imageScreenshotFromView:view size:size];
    
    CGImageRef cgImage = tempImage.CGImage;
    CGFloat width = CGImageGetWidth(cgImage);
    CGFloat height = CGImageGetHeight(cgImage);
    CGRect rect = CGRectMake(offset.width, height - offset.height, width, newHeight);
    
    CGImageRef cgSubImage = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:cgSubImage];
    tempImage = subImage;
    CGImageRelease(cgSubImage);
    
    return tempImage;
}

+ (UIImage *)imageScreenshotFromView:(UIView *)view size:(CGSize)size {
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    
    [view drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height) afterScreenUpdates:NO];
    UIImage* tempImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return tempImage;
}

@end
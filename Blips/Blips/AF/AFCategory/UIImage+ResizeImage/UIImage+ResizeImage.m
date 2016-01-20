//
//  UIImage+ResizeImage.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage(ResizeImage)

- (UIImage *)resizeImage:(CGSize)size {
    return [UIImage resizeImage:self size:size];
}

+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size {

    UIImage *currentImage = image;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    CGRect newRect        = CGRectZero;
    newRect.size.width    = size.width;
    newRect.size.height   = size.height;

    [currentImage drawInRect:newRect];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(resizedImage == nil) {
        NSLog(@"\nWARNING : Could not scale image.");
    }
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
//
//  UIImage+ResizeImage.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(ResizeImage)

/** Resizes an image. */
- (UIImage *)resizeImage:(CGSize)size;

/** Resizes an image. */
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;

@end
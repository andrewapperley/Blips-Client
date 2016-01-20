//
//  UIImage+ImageWithColor.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-10.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageWithColor:(UIColor *)color;

@end

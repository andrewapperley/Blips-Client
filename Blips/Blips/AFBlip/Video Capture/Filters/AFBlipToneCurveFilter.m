//
//  AFBlipToneCurveFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipToneCurveFilter.h"

@implementation AFBlipToneCurveFilter

- (id)init {
    if (self = [super init]) {
        [self setBlueControlPoints:@[[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.75)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)]]];
    }
    return self;
}

@end
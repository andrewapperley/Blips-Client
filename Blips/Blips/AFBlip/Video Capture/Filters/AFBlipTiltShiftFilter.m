//
//  AFBlipTiltShiftFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTiltShiftFilter.h"

@implementation AFBlipTiltShiftFilter

- (id)init {
    if (self = [super init]) {
        [self setFocusFallOffRate:0.4];
        [self setTopFocusLevel:0.4];
    }
    return self;
}

@end
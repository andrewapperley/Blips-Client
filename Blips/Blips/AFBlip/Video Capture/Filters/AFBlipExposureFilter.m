//
//  AFBlipExposureFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipExposureFilter.h"

@implementation AFBlipExposureFilter

- (id)init {
    if (self = [super init]) {
        self.exposure = 0.99f;
    }
    return self;
}

@end
//
//  AFBlipSaturationFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipSaturationFilter.h"

@implementation AFBlipSaturationFilter

- (id)init {
    if (self = [super init]) {
        self.saturation = 0.5f;
    }
    return self;
}

@end
//
//  AFBlipXForceFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-20.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipXForceFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageHueFilter.h"

@implementation AFBlipXForceFilter


- (id)init {
    if (self = [super init]) {
        self.contrast = 1.3f;
    }
    return self;
}

- (NSArray *)chainFilters {
    
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = -0.1f;
    
    GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];
    sepia.intensity = 0.3f;
    
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 1.5f;
    
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = -20.0f;
    
    return @[brightness, sepia, saturation, hue];
}


@end
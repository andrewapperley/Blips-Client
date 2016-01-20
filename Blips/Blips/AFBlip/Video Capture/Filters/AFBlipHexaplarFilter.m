//
//  AFBlipHexaplarFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipHexaplarFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageHueFilter.h"

@implementation AFBlipHexaplarFilter

- (id)init {
    if (self = [super init]) {
        self.intensity = 0.4f;
    }
    return self;
}

- (NSArray *)chainFilters {
    
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 1.6f;
    
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 1.1f;
    
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = -0.1f;
    
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = -10.0f;
    
    return @[saturation, contrast, brightness, hue];
}


@end
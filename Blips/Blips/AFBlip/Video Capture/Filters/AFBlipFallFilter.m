//
//  AFBlipFallFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-20.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFallFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageHueFilter.h"

@implementation AFBlipFallFilter

- (id)init {
    if (self = [super init]) {
        self.intensity = 0.4f;
    }
    return self;
}

- (NSArray *)chainFilters {
    
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 1.5f;
    
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = -30.0f;
    
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 0.67f;
    
    return @[saturation, hue, contrast];
}

@end
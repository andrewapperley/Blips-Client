//
//  AFBlipRecitFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipRecitFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageSepiaFilter.h"

@implementation AFBlipRecitFilter

- (id)init {
    if (self = [super init]) {
        self.saturation = 0.02f;
    }
    return self;
}

- (NSArray *)chainFilters {
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 0.85;
    
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = 0.2;
    
    GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];
    sepia.intensity = 0.02f;
    
    return @[contrast, brightness, sepia];
}

@end
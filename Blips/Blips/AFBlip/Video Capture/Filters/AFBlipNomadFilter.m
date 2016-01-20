//
//  AFBlipNomad.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-27.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipNomadFilter.h"
#import "GPUImageVignetteFilter.h"
#import "GPUImageContrastFilter.h"

@implementation AFBlipNomadFilter

- (id)init {
    if (self = [super init]) {
        self.saturation = 0.5f;
    }
    return self;
}

- (NSArray *)chainFilters {
    
    GPUImageVignetteFilter* _vignette = [[GPUImageVignetteFilter alloc] init];
    [_vignette setVignetteEnd:0.7f];
    [_vignette setVignetteColor:(GPUVector3){0.1,0.1,0.1}];
    return @[_vignette];
}

@end
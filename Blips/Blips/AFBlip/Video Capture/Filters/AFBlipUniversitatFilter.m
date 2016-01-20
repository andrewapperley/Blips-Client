//
//  AFBlipUniversitatFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipUniversitatFilter.h"
#import "GPUImageVignetteFilter.h"
#import "GPUImageMonochromeFilter.h"

@interface AFBlipUniversitatFilter () {

}

@end

@implementation AFBlipUniversitatFilter

- (id)init {
    if (self = [super init]) {
        self.contrast = 1.0f;
    }
    return self;
}

- (NSArray *)chainFilters {
    GPUImageMonochromeFilter* _mono = [[GPUImageMonochromeFilter alloc] init];
    [_mono setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 0.6f}];
    [_mono setIntensity:0.3f];
    GPUImageVignetteFilter* _vignette = [[GPUImageVignetteFilter alloc] init];
    return @[_mono, _vignette];
}

@end
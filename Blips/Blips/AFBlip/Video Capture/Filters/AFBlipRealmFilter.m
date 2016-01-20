//
//  AFBlipRealmFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-28.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipRealmFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageVignetteFilter.h"

@interface AFBlipRealmFilter () {
    GPUImagePicture* _lookupImageSource;
}

@end

@implementation AFBlipRealmFilter

- (id)init {
    if (self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lookup_realm.png"]];
        
        typeof(self) __weak wself = self;
        
        [_lookupImageSource addTarget:wself atTextureLocation:1];
        
        [_lookupImageSource processImage];
    }
    return self;
}

- (NSArray *)chainFilters {
    GPUImageVignetteFilter* _vignette = [[GPUImageVignetteFilter alloc] init];
    return @[_vignette];
}

- (void)dealloc {
    [self cleanupFilter];
}

- (void)cleanupFilter {
    [_lookupImageSource removeAllTargets];
    _lookupImageSource = nil;
}

@end
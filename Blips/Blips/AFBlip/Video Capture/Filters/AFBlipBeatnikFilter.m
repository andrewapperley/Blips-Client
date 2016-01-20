//
//  AFBlipBeatnikFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-28.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBeatnikFilter.h"
#import "GPUImagePicture.h"

@interface AFBlipBeatnikFilter () {
    GPUImagePicture* _lookupImageSource;
}

@end

@implementation AFBlipBeatnikFilter

- (id)init {
    if (self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lookup_beatnik.png"]];
        
        typeof(self) __weak wself = self;
        
        [_lookupImageSource addTarget:wself atTextureLocation:1];
        
        [_lookupImageSource processImage];
    }
    return self;
}

- (void)cleanupFilter {
    [_lookupImageSource removeAllTargets];
}

- (void)dealloc {
    [self cleanupFilter];
}

@end
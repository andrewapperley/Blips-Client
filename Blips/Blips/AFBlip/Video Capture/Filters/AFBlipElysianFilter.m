//
//  AFBlipElysianFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-27.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipElysianFilter.h"
#import "GPUImagePicture.h"

@interface AFBlipElysianFilter () {
    GPUImagePicture* _lookupImageSource;
}

@end

@implementation AFBlipElysianFilter

- (id)init {
    if (self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lookup_miss_etikate.png"]];
        
        typeof(self) __weak wself = self;
        
        [_lookupImageSource addTarget:wself atTextureLocation:1];
        
        [_lookupImageSource processImage];
    }
    return self;
}


- (void)cleanupFilter {
    [_lookupImageSource removeAllTargets];
    _lookupImageSource = nil;
}

- (void)dealloc {
    [self cleanupFilter];
}

@end
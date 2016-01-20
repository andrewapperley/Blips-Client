//
//  AFBlipApperleyFilter.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-28.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipApperleyFilter.h"
#import "GPUImagePicture.h"

@interface AFBlipApperleyFilter () {
    GPUImagePicture* _lookupImageSource;
}

@end

@implementation AFBlipApperleyFilter

- (id)init {
    if (self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lookup_apperley.png"]];
        
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
//
//  AFBlipVideoViewControllerBaseViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerBaseViewController.h"

@implementation AFBlipVideoViewControllerBaseViewController

- (BOOL)viewControllerCanProceedToNextSection {
    
    return YES;
}

- (BOOL)viewControllerCanProceedToPreviousSection {
    
    return YES;
}

- (void)dealloc {
    if (_loaded) {
        _loaded = NULL;
    }
}

@end
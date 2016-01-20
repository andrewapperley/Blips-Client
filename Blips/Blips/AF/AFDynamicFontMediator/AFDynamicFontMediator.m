//
//  AFDynamicFontMediator.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-21.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFDynamicFontMediator.h"

@implementation AFDynamicFontMediator

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        [self createNotiftication];
    }
    return self;
}

- (void)createNotiftication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)onNotification {
    
    [_delegate dynamicFontMediatorDidChangeFontSize:self];
}

- (void)updateFontSize {
    
    [self onNotification];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
}

@end
//
//  AFRotatingMenuControllerModel.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuControllerModel.h"

@implementation AFBlipPopoutMenuControllerModel

- (instancetype)initWithIcons:(NSArray *)icons titles:(NSArray *)titles selectors:(NSArray *)selectors properties:(NSArray *)properties {
    if (self = [super init]) {
        _icons      = icons;
        _titles     = titles;
        _selectors  = selectors;
        _properties = properties;
    }
    return self;
}

@end
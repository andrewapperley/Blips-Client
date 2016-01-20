//
//  AFRotatingMenuItem.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuMenuItem.h"

@implementation AFBlipPopoutMenuMenuItem

- (instancetype)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)icon selector:(SEL)selector property:(id)property {
    if (self = [super init]) {
        _menuItemTitle      = title;
        _menuItemIcon       = icon;
        _menuItemSelector   = selector;
        _menuItemProperty   = property;
    }
    return self;
}

@end
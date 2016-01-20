//
//  AFRotatingMenuItem.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipPopoutMenuMenuItem : NSObject

@property(nonatomic, strong)NSString* menuItemTitle;
@property(nonatomic, strong)UIImage* menuItemIcon;
@property(nonatomic)SEL menuItemSelector;
@property(nonatomic, strong)id menuItemProperty;

- (instancetype)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)icon selector:(SEL)selector property:(id)property;

@end
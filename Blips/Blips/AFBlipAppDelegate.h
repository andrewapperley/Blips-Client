//
//  AFBlipAppDelegate.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipNavigationMediatorViewController;

@interface AFBlipAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AFBlipNavigationMediatorViewController *navigationController;

@end
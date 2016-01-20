//
//  AFBlipIntialViewController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFBlipIntialViewController;

@protocol AFBlipIntialViewControllerDelegate <NSObject>

@required
- (void)initialViewControllerDidLogin:(AFBlipIntialViewController *)initialViewController;

@end

@interface AFBlipIntialViewController : UIViewController

@property (nonatomic, weak) id<AFBlipIntialViewControllerDelegate> delegate;

@end
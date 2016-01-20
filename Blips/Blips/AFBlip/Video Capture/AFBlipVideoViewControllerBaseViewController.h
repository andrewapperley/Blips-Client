//
//  AFBlipVideoViewControllerBaseViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AFBlipVideoViewControllerLoaded)(void);

@interface AFBlipVideoViewControllerBaseViewController : UIViewController

/** Returns a BOOL if the view controller will allow the user to proceed to the next section. */
- (BOOL)viewControllerCanProceedToNextSection;

/** Returns a BOOL if the view controller will allow the user to proceed to the previous section. */
- (BOOL)viewControllerCanProceedToPreviousSection;

@property(nonatomic, weak)id delegate;
@property(nonatomic, copy)AFBlipVideoViewControllerLoaded loaded;
@end
//
//  AFBlipProfileViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFViewController.h"

@class AFBlipProfileViewController;

@protocol AFBlipProfileViewControllerDelegate <NSObject>

@required
- (void)profileViewControllerDidSelectLogout:(AFBlipProfileViewController *)profileViewController;
- (void)profileViewControllerDidDeactivate:(AFBlipProfileViewController *)profileViewController;
- (void)profileViewControllerDidSelectEditProfile:(AFBlipProfileViewController *)profileViewController;

@end

@interface AFBlipProfileViewController : AFViewController

@property (nonatomic, weak) id<AFBlipProfileViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isOpen;

- (instancetype)initWithViewFrame:(CGRect)frame;

@end
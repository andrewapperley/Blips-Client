//
//  AFBlipConnectionsViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-17.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipConnectionsCollectionView.h"

@class AFBlipConnectionsViewController, AFBlipConnectionModel;

@protocol AFBlipConnectionsViewControllerDelegate <NSObject>

@required
- (void)didSelectLimitedProfileForUser:(AFBlipUserModel *)user toAdd:(BOOL)toAdd fromController:(__weak AFBlipConnectionsViewController *)controller;
- (void)didSelectConnectionsFriendRequest:(AFBlipConnectionModel *)connection fromController:(__weak AFBlipConnectionsViewController *)controller;
- (void)didSelectConnectionsProfileForConnection:(AFBlipConnectionModel *)connection fromController:(__weak AFBlipConnectionsViewController *)controller;
- (void)didSelectPersonalTimelineForSection:(kAFBlipConnectionsPersonalSection)section fromController:(__weak AFBlipConnectionsViewController *)controller;

@end

@interface AFBlipConnectionsViewController : UIViewController <AFBlipConnectionsCollectionViewControllerDelegate>

@property (nonatomic, weak) id<AFBlipConnectionsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isOpen;

- (instancetype)initWithViewFrame:(CGRect)frame;
- (void)reloadData;

@end
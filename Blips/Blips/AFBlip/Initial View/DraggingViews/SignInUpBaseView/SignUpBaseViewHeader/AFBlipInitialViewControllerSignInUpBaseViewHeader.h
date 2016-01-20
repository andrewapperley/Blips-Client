//
//  AFBlipInitialViewControllerSignInUpBaseViewHeader.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipInitialViewControllerSignInUpBaseViewHeader;

@protocol AFBlipInitialViewControllerSignInUpBaseViewHeaderDelegate <NSObject>

@optional
- (void)initialViewControllerSignInUpBaseViewHeaderDidPressHeader:(AFBlipInitialViewControllerSignInUpBaseViewHeader *)header;

@end

@interface AFBlipInitialViewControllerSignInUpBaseViewHeader : UIButton

@property (nonatomic, weak) id<AFBlipInitialViewControllerSignInUpBaseViewHeaderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

/** Highlights the header icon. */
- (void)highlightIcon:(BOOL)highlightIcon;

@end

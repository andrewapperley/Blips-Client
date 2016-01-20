//
//  AFBlipInitialViewControllerBackgroundView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipInitialViewControllerBackgroundView;

@protocol AFBlipInitialViewControllerBackgroundViewDelegate <NSObject>

@required
- (void)initialViewControllerBackgroundViewDidPressSignIn:(AFBlipInitialViewControllerBackgroundView *)initialViewControllerBackgroundView;
- (void)initialViewControllerBackgroundViewDidPressSignUp:(AFBlipInitialViewControllerBackgroundView *)initialViewControllerBackgroundView;

@end

@interface AFBlipInitialViewControllerBackgroundView : UIView

@property (nonatomic, weak) id<AFBlipInitialViewControllerBackgroundViewDelegate> delegate;
@property (nonatomic, assign) BOOL enabledMotionEffects;

@end

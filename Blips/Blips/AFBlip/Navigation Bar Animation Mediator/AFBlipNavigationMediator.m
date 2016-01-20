//
//  AFBlipNavigationMediator.n
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipNavigationMediator.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipProfileViewControllerStatics.h"

#pragma mark - Animation constants
const CGFloat kAFBlipNavigationMediator_OpenAnimationDuration            = 0.45f;
const CGFloat kAFBlipNavigationMediator_CloseAnimationDuration           = 0.4f;
const CGFloat kAFBlipNavigationMediator_AnimationSpringDamping           = 0.8f;
const CGFloat kAFBlipNavigationMediator_AnimationSpringDampingToTimeline = 1.0f;
const CGFloat kAFBlipNavigationMediator_AnimationVelocity                = 0.5f;

const CGFloat kAFBlipNavigationMediator_TimelineHiddenAlpha              = 0.25f;

@interface AFBlipNavigationMediator () {
    
    UIView                 *_blurOverlayBlockerView;
}

@end

@implementation AFBlipNavigationMediator

#pragma mark - Settings
#pragma mark - Timeline to settings
- (void)navigateToSettingsViewController:(UIViewController *)settingsViewController fromTimelineViewController:(UIViewController *)timelineViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion {
    
    settingsViewController.view.alpha = 0;
    [_delegate.view insertSubview:settingsViewController.view atIndex:0];
    [_delegate addChildViewController:settingsViewController];
    [settingsViewController didMoveToParentViewController:_delegate];

    //Animation duration
    CGFloat animationDuration = kAFBlipNavigationMediator_OpenAnimationDuration;

    //Settings frame
    __block CGRect settingsFrame               = settingsViewController.view.frame;
    settingsFrame.origin.x                     = kAFBlipProfileViewControllerStatics_ProfileViewOpenPosX;
    
    //Navigation bar frame
    __block CGRect navigationBarFrame          = navigationBar.layer.frame;
    navigationBarFrame.origin.x                = CGRectGetWidth(settingsFrame);
    
    //Timeline frame
    __block CGRect timelineViewControllerFrame = timelineViewController.view.frame;
    timelineViewControllerFrame.origin.x       = CGRectGetWidth(settingsFrame);

    //Blocker
    __weak typeof(_blurOverlayBlockerView) weakBlurredView = [self blurOverlayforView:timelineViewController.view];
    weakBlurredView.alpha                       = 0;

    [self animateNavigationBar:navigationBar duration:animationDuration fromAlpha:1.0f toAlpha:kAFBlipNavigationMediator_TimelineHiddenAlpha];

    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:kAFBlipNavigationMediator_AnimationSpringDamping initialSpringVelocity:kAFBlipNavigationMediator_AnimationVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        
        settingsViewController.view.alpha   = 1;
        weakBlurredView.alpha               = 1;
        timelineViewController.view.alpha   = kAFBlipNavigationMediator_TimelineHiddenAlpha;

        timelineViewController.view.frame   = timelineViewControllerFrame;
        settingsViewController.view.frame   = settingsFrame;
        navigationBar.layer.affineTransform = CGAffineTransformMakeTranslation(CGRectGetMinX(navigationBarFrame), 0);
        
    } completion:^(BOOL finished) {
        
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - Settings to timeline
- (void)navigateToTimelineViewController:(UIViewController *)timelineViewController fromSettingsViewController:(UIViewController *)settingsViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion {
    
    //Remove blur
    CGFloat animationDuration = kAFBlipNavigationMediator_CloseAnimationDuration;
    
    //Navigation bar frame
    __block CGRect navigationBarFrame          = navigationBar.layer.frame;
    navigationBarFrame.origin.x                = 0;
    
    //Settings frame
    __block CGRect settingsFrame               = settingsViewController.view.frame;
    settingsFrame.origin.x                     = kAFBlipProfileViewControllerStatics_ProfileViewClosedPosX;
    
    //Timeline frame
    __block CGRect timelineViewControllerFrame = timelineViewController.view.frame;
    timelineViewControllerFrame.origin.x       = 0;
    
    //Blocker
    __weak typeof(_blurOverlayBlockerView) weakBlurredView = [self blurOverlayforView:timelineViewController.view];
    
    [self animateNavigationBar:navigationBar duration:animationDuration fromAlpha:kAFBlipNavigationMediator_TimelineHiddenAlpha toAlpha:1.0];

    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:kAFBlipNavigationMediator_AnimationSpringDampingToTimeline initialSpringVelocity:kAFBlipNavigationMediator_AnimationVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        
        settingsViewController.view.alpha   = 0;
        weakBlurredView.alpha               = 0;
        timelineViewController.view.alpha   = 1;

        timelineViewController.view.frame   = timelineViewControllerFrame;
        settingsViewController.view.frame   = settingsFrame;
        navigationBar.layer.affineTransform  = CGAffineTransformMakeTranslation(CGRectGetMinX(navigationBarFrame), 0);
    
    } completion:^(BOOL finished) {
        
        [settingsViewController.view removeFromSuperview];
        [settingsViewController removeFromParentViewController];
        [weakBlurredView removeFromSuperview];
        
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - Connections
#pragma mark - Timeline to connections
- (void)navigateToConnectionsViewController:(UIViewController *)connectionsViewController fromTimelineViewController:(UIViewController *)timelineViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion {
    
    connectionsViewController.view.alpha = 0;
    [_delegate.view insertSubview:connectionsViewController.view atIndex:0];
    [_delegate addChildViewController:connectionsViewController];
    [connectionsViewController didMoveToParentViewController:_delegate];
    
    //Animation duration
    CGFloat animationDuration = kAFBlipNavigationMediator_OpenAnimationDuration;

    //Connections frame
    __block CGRect connectionsVFrame           = connectionsViewController.view.frame;
    connectionsVFrame.origin.x                 = CGRectGetMaxX(timelineViewController.view.frame) + kAFBlipConnectionsViewControllerStatics_ConnectionsViewOpenPosX;
    
    //Navigation bar frame
    __block CGRect navigationBarFrame          = navigationBar.layer.frame;
    navigationBarFrame.origin.x                = - CGRectGetWidth(connectionsVFrame);
    
    //Timeline frame
    __block CGRect timelineViewControllerFrame = timelineViewController.view.frame;
    timelineViewControllerFrame.origin.x       = - CGRectGetWidth(connectionsVFrame);

    //Blocker
    __weak typeof(_blurOverlayBlockerView) weakBlurredView = [self blurOverlayforView:timelineViewController.view];
    weakBlurredView.alpha                      = 0;
    
    [self animateNavigationBar:navigationBar duration:animationDuration fromAlpha:1.0f toAlpha:kAFBlipNavigationMediator_TimelineHiddenAlpha];

    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:kAFBlipNavigationMediator_AnimationSpringDamping initialSpringVelocity:kAFBlipNavigationMediator_AnimationVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        
        connectionsViewController.view.alpha = 1;
        weakBlurredView.alpha                = 1;
        timelineViewController.view.alpha    = kAFBlipNavigationMediator_TimelineHiddenAlpha;

        timelineViewController.view.frame    = timelineViewControllerFrame;
        connectionsViewController.view.frame = connectionsVFrame;
        navigationBar.layer.affineTransform  = CGAffineTransformMakeTranslation(CGRectGetMinX(navigationBarFrame), 0);
        
    } completion:^(BOOL finished) {
        
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - Connections to timeline
- (void)navigateToTimelineViewController:(UIViewController *)timelineViewController fromConnectionsViewController:(UIViewController *)connectionsViewController navigationBar:(UINavigationBar *)navigationBar completion:(AFBlipNavigationMediatorAnimationCompletion)completion {
    
    //Remove blur
    CGFloat animationDuration = kAFBlipNavigationMediator_CloseAnimationDuration;
    
    //Navigation bar frame
    __block CGRect navigationBarFrame          = navigationBar.layer.frame;
    navigationBarFrame.origin.x                = 0;
    
    //Settings frame
    __block CGRect connectionsVFrame           = connectionsViewController.view.frame;
    connectionsVFrame.origin.x                 = CGRectGetWidth(timelineViewController.view.frame) +  kAFBlipConnectionsViewControllerStatics_ConnectionsViewClosedPosX;
    
    //Timeline frame
    __block CGRect timelineViewControllerFrame = timelineViewController.view.frame;
    timelineViewControllerFrame.origin.x       = 0;
    
    //Blocker
    __weak typeof(_blurOverlayBlockerView) weakBlurredView = [self blurOverlayforView:timelineViewController.view];
    
    [self animateNavigationBar:navigationBar duration:animationDuration fromAlpha:kAFBlipNavigationMediator_TimelineHiddenAlpha toAlpha:1.0f];

    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:kAFBlipNavigationMediator_AnimationSpringDampingToTimeline initialSpringVelocity:kAFBlipNavigationMediator_AnimationVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        
        connectionsViewController.view.alpha = 0;
        weakBlurredView.alpha                = 0;
        timelineViewController.view.alpha    = 1;
        
        timelineViewController.view.frame    = timelineViewControllerFrame;
        connectionsViewController.view.frame = connectionsVFrame;
        navigationBar.layer.affineTransform  = CGAffineTransformMakeTranslation(CGRectGetMinX(navigationBarFrame), 0);
        
    } completion:^(BOOL finished) {

        [connectionsViewController.view removeFromSuperview];
        [connectionsViewController removeFromParentViewController];
        [weakBlurredView removeFromSuperview];
        
        if(completion) {
            completion();
        }
    }];
}

- (void)animateNavigationBar:(UINavigationBar *)navigationBar duration:(NSTimeInterval)duration fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue         = @(fromAlpha);
    alphaAnimation.toValue           = @(toAlpha);
    alphaAnimation.fillMode          = kCAFillModeForwards;
    alphaAnimation.duration          = duration * 0.5f;
    alphaAnimation.removedOnCompletion = NO;
    [navigationBar.layer addAnimation:alphaAnimation forKey:nil];
}

- (UIView *)blurOverlayforView:(UIView *)tapGestureView {
 
    //Create overlay
    if(!_blurOverlayBlockerView) {
        _blurOverlayBlockerView                  = [[UIView alloc] initWithFrame:tapGestureView.bounds];
        _blurOverlayBlockerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _blurOverlayBlockerView.backgroundColor  = [UIColor colorWithWhite:1.0f alpha:0.8f];
        
        //Create tap gesture
        UITapGestureRecognizer *tapGesture       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)];
        [_blurOverlayBlockerView addGestureRecognizer:tapGesture];
    } else {
        _blurOverlayBlockerView.frame = tapGestureView.bounds;
    }
    
    [tapGestureView addSubview:_blurOverlayBlockerView];
    
    return _blurOverlayBlockerView;
}

- (void)onTapGesture {
    
    [_delegate navigationMediatorDidTapBlockedViewFromMediator:self];
}

#pragma mark - Dealloc
- (void)dealloc {
    _delegate = nil;
}

@end
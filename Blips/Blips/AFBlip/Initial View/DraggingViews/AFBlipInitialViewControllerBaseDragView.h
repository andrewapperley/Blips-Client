//
//  AFBlipInitialViewControllerBaseDragView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpBaseView.h"

@class AFBlipInitialViewControllerBaseDragView;

@protocol AFBlipInitialViewControllerBaseDragViewDelegate <AFBlipInitialViewControllerSignInUpBaseViewDelegate>

@optional
- (void)initialViewControllerBaseDragViewDidTapBlocker:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView;

- (void)initialViewControllerBaseDragViewWillShow:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView;
- (void)initialViewControllerBaseDragViewDidShow:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView;

- (void)initialViewControllerBaseDragViewWillHide:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView;
- (void)initialViewControllerBaseDragViewDidHide:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView;

@end

@interface AFBlipInitialViewControllerBaseDragView : UIView

@property (nonatomic, weak) id<AFBlipInitialViewControllerBaseDragViewDelegate> delegate;
@property (nonatomic, strong, readonly) AFBlipInitialViewControllerSignInUpBaseView *draggableView;

- (instancetype)initWithFrame:(CGRect)frame draggableView:(AFBlipInitialViewControllerSignInUpBaseView *)draggableView blockerImage:(UIImage *)blockerImage;

- (void)show;
- (void)hide;

@end
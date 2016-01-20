//
//  AFBlipInitialViewControllerBaseDragView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerBaseDragView.h"
#import "AFBlipInitialViewControllerSignInUpBaseView.h"

#pragma mark - Constants
const CGFloat kAFBlipInitialViewControllerBaseDragView_AnimationDurationShowPerHundredPixels = 0.18f;
const CGFloat kAFBlipInitialViewControllerBaseDragView_AnimationDurationHidePerHundredPixels = 0.15f;
const CGFloat kAFBlipInitialViewControllerBaseDragView_AnimationBouncePadding                = 10.0f;

const CGFloat kAFBlipInitialViewControllerBaseDragView_PercentageMultiplier                  = 0.095f;

const CGFloat kAFBlipInitialViewControllerBaseDragView_SubmitButtonPadding                   = 15.0f;

const CGFloat kAFBlipInitialViewControllerBaseDragView_MaxBlockerAlphaOffset                 = 0.05f;

@interface AFBlipInitialViewControllerBaseDragView () <AFBlipInitialViewControllerSignInUpBaseViewDelegate> {
    
    UIView *_blockerView;
}

@end

@implementation AFBlipInitialViewControllerBaseDragView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame draggableView:(AFBlipInitialViewControllerSignInUpBaseView *)draggableView blockerImage:(UIImage *)blockerImage {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self createBlockerView:blockerImage];
        [self createDragableView:draggableView];
        [self createKeyboardNotifications];
    }
    return self;
}

#pragma mark - Create blocker
- (void)createBlockerView:(UIImage *)blockerImage {
    
    //Blocker view
    _blockerView                       = [[UIView alloc] initWithFrame:self.bounds];
    _blockerView.autoresizingMask      = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _blockerView.alpha                 = 0.0f;
    _blockerView.backgroundColor       = [UIColor colorWithPatternImage:blockerImage];
    [self addSubview:_blockerView];

    //Tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)];
    [_blockerView addGestureRecognizer:tapGesture];
}

- (void)onTapGesture {
    
    if([_delegate respondsToSelector:@selector(initialViewControllerBaseDragViewDidTapBlocker:)]) {
        [_delegate initialViewControllerBaseDragViewDidTapBlocker:self];
    }
}

#pragma mark - Create dragable view
- (void)createDragableView:(AFBlipInitialViewControllerSignInUpBaseView *)draggableView {

    _draggableView                     = draggableView;

    //Drag view
    CGRect frame                       = _draggableView.frame;
    frame.origin.y                     = CGRectGetHeight(self.bounds);
    _draggableView.frame               = frame;
    [self addSubview:_draggableView];

    //Pan gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    panGesture.minimumNumberOfTouches  = 1;
    panGesture.maximumNumberOfTouches  = 1;
    panGesture.cancelsTouchesInView    = NO;
    [_draggableView addGestureRecognizer:panGesture];
}

- (void)onPan:(UIPanGestureRecognizer *)panGesture {
    
    UIView *superView        = _blockerView;
    CGPoint translationPoint = [panGesture translationInView:superView];
    
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        
        //Frame
        _draggableView.frame = [self frameFromTranslationPoint:translationPoint draggableView:_draggableView];
        
        //Alpha
        _blockerView.alpha   = [self alphaFromDraggableView:_draggableView];
        
        //Reset translation point
        [panGesture setTranslation:CGPointZero inView:superView];
        
    } else if(panGesture.state == UIGestureRecognizerStateEnded) {
        
        //Frames
        CGFloat posY    = CGRectGetMinY(_draggableView.frame);
        CGFloat centerY = CGRectGetHeight(self.bounds) - (CGRectGetHeight(_draggableView.frame) * 0.5f);
        
        //Close
        if(posY > centerY) {
            
            [self hide];
        //Open
        } else {
            [self show];
        }
    }
}

- (CGRect)frameFromTranslationPoint:(CGPoint)translationPoint draggableView:(UIView *)draggableView {
    
    CGRect frame        = draggableView.frame;
    CGFloat maxY        = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame);
    CGFloat minY        = CGRectGetHeight(self.bounds);
    CGFloat newY        = frame.origin.y + translationPoint.y;
    frame.origin.y      = MAX(newY, maxY);
    frame.origin.y      = MIN(frame.origin.y, minY);
    draggableView.frame = frame;
    
    return frame;
}

- (CGFloat)alphaFromDraggableView:(UIView *)draggableView {
    
    CGFloat currentY = CGRectGetHeight(self.bounds) - CGRectGetMinY(draggableView.frame);
    CGFloat height   = CGRectGetHeight(draggableView.frame);
    CGFloat percent  = currentY / height;
    
    return (powf(percent, kAFBlipInitialViewControllerBaseDragView_PercentageMultiplier)) - kAFBlipInitialViewControllerBaseDragView_MaxBlockerAlphaOffset;
}

#pragma mark - Show
- (void)show {
    
    //Duratin
    CGFloat animationDuration = (CGRectGetHeight(_draggableView.frame) / 100) * kAFBlipInitialViewControllerBaseDragView_AnimationDurationShowPerHundredPixels;
    
    //Frame
    CGRect frame        = _draggableView.frame;
    frame.origin.y      = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame) + kAFBlipInitialViewControllerBaseDragView_AnimationBouncePadding;
    
    if([_delegate respondsToSelector:@selector(initialViewControllerBaseDragViewWillShow:)]) {
        [_delegate initialViewControllerBaseDragViewWillShow:self];
    }
    
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.775f initialSpringVelocity:0.1f options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
    
        _blockerView.alpha   = 1.0f - kAFBlipInitialViewControllerBaseDragView_MaxBlockerAlphaOffset;
        _draggableView.frame = frame;

    } completion:^(BOOL finished) {
        
        if([_delegate respondsToSelector:@selector(initialViewControllerBaseDragViewDidShow:)]) {
            [_delegate initialViewControllerBaseDragViewDidShow:self];
        }
    }];
}

#pragma mark - Hide
- (void)hide {
    
    //Duratin
    CGFloat animationDuration = (CGRectGetHeight(_draggableView.frame) / 100) * kAFBlipInitialViewControllerBaseDragView_AnimationDurationHidePerHundredPixels;
    
    //Frame
    CGRect frame        = _draggableView.frame;
    frame.origin.y      = CGRectGetHeight(self.bounds);
    
    if([_delegate respondsToSelector:@selector(initialViewControllerBaseDragViewWillHide:)]) {
        [_delegate initialViewControllerBaseDragViewWillHide:self];
    }
    
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.775f initialSpringVelocity:0.1f options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _blockerView.alpha   = 0.0f;
        _draggableView.frame = frame;

    } completion:^(BOOL finished) {
        
        if([_delegate respondsToSelector:@selector(initialViewControllerBaseDragViewDidHide:)]) {
            [_delegate initialViewControllerBaseDragViewDidHide:self];
        }
    }];
}

#pragma mark - Keyboard
- (void)createKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)onKeyboardShow:(NSNotification *)notification {
    
    //Disable gesture recognizers
    for(UIPanGestureRecognizer *panGesture in _draggableView.gestureRecognizers) {
        
        if([panGesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            panGesture.enabled = NO;
        }
    }
    
    //Keyboard animations
    NSDictionary *notifictionDictionary = notification.userInfo;
    CGFloat keyboardHeight              = CGRectGetHeight([notifictionDictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    CGFloat animationDuration           = [notifictionDictionary[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger animationCurve           = [notifictionDictionary[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    CGFloat submitButtonHeight          = CGRectGetHeight(_draggableView.submitButton.frame) + kAFBlipInitialViewControllerBaseDragView_SubmitButtonPadding;
    
    //View animations
    CGRect frame                  = _draggableView.frame;
    frame.origin.y               -= keyboardHeight - submitButtonHeight;
    
    [UIView animateWithDuration:animationDuration delay:0.0f options:animationCurve animations:^{
        
        _draggableView.frame      = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification {
    
    //Disable gesture recognizers
    for(UIPanGestureRecognizer *panGesture in _draggableView.gestureRecognizers) {
        
        if([panGesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            panGesture.enabled = YES;
        }
    }
    
    //Keyboard animations
    NSDictionary *notifictionDictionary = notification.userInfo;
    CGFloat keyboardHeight              = CGRectGetHeight([notifictionDictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    CGFloat animationDuration           = [notifictionDictionary[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger animationCurve           = [notifictionDictionary[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    CGFloat submitButtonHeight          = CGRectGetHeight(_draggableView.submitButton.frame) + kAFBlipInitialViewControllerBaseDragView_SubmitButtonPadding;

    //View animations
    CGRect frame                  = _draggableView.frame;
    frame.origin.y               += keyboardHeight - submitButtonHeight;
    
    [UIView animateWithDuration:animationDuration delay:0.0f options:animationCurve animations:^{
        
        _draggableView.frame      = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Delegate override
- (void)setDelegate:(id<AFBlipInitialViewControllerBaseDragViewDelegate>)delegate {
    
    _delegate               = delegate;
    _draggableView.delegate = _delegate;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
}

@end
//
//  AFBlipInitialViewControllerSignInUpBaseView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpBaseView.h"
#import "AFBlipInitialViewUserModel.h"

#pragma mark - Constants
//Content padding
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_HorizontalPadding         = 25.0f;

//Header
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_HeaderHeight              = 30.0f;

//Background color
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_DragViewWhiteAlpha        = 0.5f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_DragViewWhiteAmount       = 0.3f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_DragViewHeaderWhiteAmount = 0.15f;

//Submit button
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonPaddingX      = 25.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonHeight        = 44.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonWhiteAlpha    = 0.1f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonBorderWidth   = 1.0f;

@interface AFBlipInitialViewControllerSignInUpBaseView () <AFBlipInitialViewControllerSignInUpBaseViewHeaderDelegate> {
    
    BOOL                                                _isTouchingDown;
}

@end

@implementation AFBlipInitialViewControllerSignInUpBaseView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _isTouchingDown = NO;

        [self createContentView];
        [self createHeader];
        [self createBackgroundView];
        [self createSubmitButton];
    }
    return self;
}

#pragma mark - Content view
- (void)createContentView {
    
    _contentView                  = [[UIView alloc] initWithFrame:CGRectMake(kAFBlipInitialViewControllerSignInUpBaseView_HorizontalPadding, kAFBlipInitialViewControllerSignInUpBaseView_HeaderHeight, CGRectGetWidth(self.bounds) - (kAFBlipInitialViewControllerSignInUpBaseView_HorizontalPadding * 2), CGRectGetHeight(self.bounds) - kAFBlipInitialViewControllerSignInUpBaseView_HeaderHeight)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_contentView];
}

#pragma mark - Header 
- (void)createHeader {
    
    _header                  = [[AFBlipInitialViewControllerSignInUpBaseViewHeader alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kAFBlipInitialViewControllerSignInUpBaseView_HeaderHeight)];
    _header.backgroundColor  = [UIColor colorWithWhite:kAFBlipInitialViewControllerSignInUpBaseView_DragViewHeaderWhiteAmount alpha:kAFBlipInitialViewControllerSignInUpBaseView_DragViewWhiteAlpha];
    _header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _header.delegate         = self;
    [self addSubview:_header];
}

#pragma mark - Background view
- (void)createBackgroundView {
    
    //Content view background
    _backgroundView                 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_contentView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(_contentView.frame))];
    _backgroundView.backgroundColor  = [UIColor colorWithWhite:kAFBlipInitialViewControllerSignInUpBaseView_DragViewWhiteAmount alpha:kAFBlipInitialViewControllerSignInUpBaseView_DragViewWhiteAlpha];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self insertSubview:_backgroundView atIndex:0];
}

#pragma mark - Submit button
- (void)createSubmitButton {
    
    //Button
    _submitButton                        = [[UIButton alloc] initWithFrame:CGRectMake(kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonPaddingX, CGRectGetHeight(self.bounds) - kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonHeight - kAFBlipInitialViewControllerSignInUpBaseView_HorizontalPadding, CGRectGetWidth(self.bounds) - (kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonPaddingX * 2), kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonHeight)];
    _submitButton.autoresizingMask       = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _submitButton.enabled = NO;
    
    //Title
    NSString *text = NSLocalizedString(@"AFBlipSignupFormSubmitButton", nil);
    [_submitButton setTitle:text forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    //Actions
    //Normal
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchCancel];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragExit];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragOutside];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchUpOutside];
    
    //Highlight
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragInside];
    
    //Select
    [_submitButton addTarget:self action:@selector(onSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Border
    _submitButton.layer.cornerRadius = CGRectGetHeight(_submitButton.frame) * 0.5f;
    _submitButton.layer.borderWidth  = kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonBorderWidth;
    _submitButton.layer.borderColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonWhiteAlpha].CGColor;
    [self addSubview:_submitButton];
}

- (void)onSubmitButtonNormal:(UIButton *)button {
    
    button.backgroundColor = [UIColor clearColor];
}

- (void)onSubmitButtonHighlight:(UIButton *)button {
    
    button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseView_SubmitButtonWhiteAlpha];
}

- (void)onSubmitButton:(UIButton *)button {
    
    [self onSubmitButtonNormal:button];
    
    [_delegate initialViewControllerSignInUpBaseView:self didSelectSubmitButtonWithData:_model];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    [_header highlightIcon:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [_header highlightIcon:NO];
}

#pragma mark - AFBlipInitialViewControllerSignInUpBaseViewHeaderDelegate
- (void)initialViewControllerSignInUpBaseViewHeaderDidPressHeader:(AFBlipInitialViewControllerSignInUpBaseViewHeader *)header {
    
    if([_delegate respondsToSelector:@selector(initialViewControllerSignInUpBaseViewDidPressHeaderForView:)]) {
        [_delegate initialViewControllerSignInUpBaseViewDidPressHeaderForView:self];
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
//
//  AFBlipInitialViewControllerSignInUpBaseViewHeader.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpBaseViewHeader.h"

#pragma mark - Constants
const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWidth           = 1.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlpha      = 0.2f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlphaTouch = 0.85f;

const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconWidth             = 38.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconLineWidth         = 8.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconLineBorderEdge    = 5.0f;

@interface AFBlipInitialViewControllerSignInUpBaseViewHeader () {
 
    CAShapeLayer *_icon;
}

@end

@implementation AFBlipInitialViewControllerSignInUpBaseViewHeader

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {

        [self createTouchEvents];
        [self createBorders];
        [self createHeaderIcon];
        [self highlightIcon:NO];
    }
    return self;
}

#pragma mark - Create touch events
- (void)createTouchEvents{
    
    //Touch action
    [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    //Highlight
    [self addTarget:self action:@selector(onTouchUpDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(onTouchUpDown) forControlEvents:UIControlEventTouchDownRepeat];
    [self addTarget:self action:@selector(onTouchUpDown) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(onTouchUpDown) forControlEvents:UIControlEventTouchDragInside];
    
    //Unhighlight
    [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchDragOutside];
}

- (void)onTouchUpInside {
    
    if([_delegate respondsToSelector:@selector(initialViewControllerSignInUpBaseViewHeaderDidPressHeader:)]) {
        [_delegate initialViewControllerSignInUpBaseViewHeaderDidPressHeader:self];
    }
}

- (void)onTouchUpDown {
    
    [self highlightIcon:YES];
}

- (void)onTouchUp {
    
    [self highlightIcon:NO];
}

#pragma mark - Border
- (void)createBorders {
    
    UIView *topBorder          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds),kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWidth)];
    topBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topBorder.backgroundColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlpha];
    [self addSubview:topBorder];
    
    UIView *bottmoBorder          = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWidth, CGRectGetWidth(self.bounds),kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWidth)];
    bottmoBorder.autoresizingMask = topBorder.autoresizingMask;
    bottmoBorder.backgroundColor  = topBorder.backgroundColor;
    [self addSubview:bottmoBorder];
}

#pragma mark - Header icon
- (void)createHeaderIcon {
    
    //Icon
    _icon = [CAShapeLayer layer];
    _icon.lineCap = @"round";
    _icon.fillColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlpha].CGColor;
    _icon.lineWidth = kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconLineWidth;
    [self.layer addSublayer:_icon];
    
    //Frame
    CGFloat width = kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconWidth;
    CGFloat height = kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconLineWidth;
    CGRect frame = CGRectMake((CGRectGetWidth(self.bounds) - width) * 0.5f, (CGRectGetHeight(self.bounds) - height) * 0.5f, width, height);
    
    //Create path
    CGPathRef path = CGPathCreateWithRoundedRect(frame, kAFBlipInitialViewControllerSignInUpBaseViewHeader_IconLineBorderEdge, CGRectGetHeight(frame) * 0.5f, NULL);
    _icon.path = path;
    CGPathRelease(path);
}

- (void)highlightIcon:(BOOL)highlightIcon {
    
    
    if(highlightIcon) {
        _icon.fillColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlphaTouch].CGColor;
    } else {
        _icon.fillColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipInitialViewControllerSignInUpBaseViewHeader_BorderWhiteAlpha].CGColor;
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
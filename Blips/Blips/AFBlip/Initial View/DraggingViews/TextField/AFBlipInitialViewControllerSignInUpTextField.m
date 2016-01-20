//
//  AFBlipInitialViewControllerSignInUpTextField.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-20.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpTextField.h"

#pragma mark - Constants
//Properties
const CGFloat kAFBlipInitialViewControllerSignInUpTextField_RoundedCornerSize                   = 5.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpTextField_TextPadding                         = 7.0f;
const CGFloat kAFBlipInitialViewControllerSignInUpTextField_TextColorBlackPercentage            = 0.75f;
const CGFloat kAFBlipInitialViewControllerSignInUpTextField_PlaceholderTextColorBlackPercentage = 0.25f;

//Checkmark
const CGFloat kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding                    = 12.0f;

const NSInteger kAFBlipInitial_MaxTextLength                                                    = 255;

@implementation AFBlipInitialViewControllerSignInUpTextField

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame roundedCorners:(UIRectCorner)roundedCorners {
    
    self = [super initWithFrame:frame];
    if(self) {
        self.keyboardAppearance = UIKeyboardAppearanceDark;
        [self createBackground];
        [self createRoundedCorners:roundedCorners];
        [self createTextPadding];
        [self createTextUI];
        [self setEnableCheckmark:NO];
    }
    return self;
}

#pragma mark - Background
- (void)createBackground {
    
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    self.tintColor       = [UIColor colorWithWhite:0.0f alpha:kAFBlipInitialViewControllerSignInUpTextField_TextColorBlackPercentage];
}

- (void)createRoundedCorners:(UIRectCorner)roundedCorners {
    
    CAShapeLayer *maskLayer   = [CAShapeLayer layer];
    maskLayer.frame           = self.bounds;

    CGSize cornerSize         = CGSizeMake(kAFBlipInitialViewControllerSignInUpTextField_RoundedCornerSize, kAFBlipInitialViewControllerSignInUpTextField_RoundedCornerSize);
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:maskLayer.bounds byRoundingCorners:roundedCorners cornerRadii:cornerSize];
    maskLayer.fillColor       = [self.backgroundColor CGColor];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path            = [roundedPath CGPath];

    self.layer.mask           = maskLayer;
}

#pragma mark - Text padding
- (void)createTextPadding {
    
    //Left
    UIView *leftPaddingView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAFBlipInitialViewControllerSignInUpTextField_TextPadding, CGRectGetHeight(self.bounds))];
    self.leftView                      = leftPaddingView;
    self.leftViewMode                  = UITextFieldViewModeAlways;

    //Right
    UIView *rightPaddingView           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAFBlipInitialViewControllerSignInUpTextField_TextPadding, CGRectGetHeight(self.bounds))];
    self.rightView                     = rightPaddingView;
    self.rightViewMode                 = UITextFieldViewModeAlways;
}

#pragma mark - Text properties
- (void)createTextUI {
    
    self.textColor = [UIColor colorWithWhite:0.0f alpha:kAFBlipInitialViewControllerSignInUpTextField_TextColorBlackPercentage];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    UIColor *color = [UIColor colorWithWhite:0.0f alpha:kAFBlipInitialViewControllerSignInUpTextField_PlaceholderTextColorBlackPercentage];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : color}];
}

#pragma mark - Checkmark
- (void)setEnableCheckmark:(BOOL)enableCheckmark {
 
    _enableCheckmark = enableCheckmark;
    
    if(!_checkmark) {
        
        CGFloat checkmarkHeight             = CGRectGetHeight(self.bounds) - (kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding * 2);

        _checkmark                          = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - checkmarkHeight - kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, checkmarkHeight, checkmarkHeight)];
        _checkmark.autoresizingMask         = UIViewAutoresizingFlexibleLeftMargin;
        _checkmark.layer.cornerRadius       = CGRectGetHeight(_checkmark.frame) * 0.5f;
        _checkmark.layer.masksToBounds      = YES;
        _checkmark.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _checkmark.layer.shouldRasterize    = YES;
        _checkmark.layer.borderWidth        = 1.0f;
        _checkmark.layer.borderColor        = [UIColor colorWithWhite:0.576 alpha:1.000].CGColor;
        self.rightView = _checkmark;
    }
    
    //Set color
    UIColor *color;
    
    if(enableCheckmark) {
        color = [UIColor colorWithRed:0.711 green:0.993 blue:0.476 alpha:1.000];
    } else {
        color = [UIColor lightGrayColor];
    }
    
    _checkmark.backgroundColor = color;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGFloat checkmarkHeight             = CGRectGetHeight(self.bounds) - (kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding * 2);
    
    return CGRectMake(CGRectGetWidth(self.bounds) - checkmarkHeight - kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, checkmarkHeight, checkmarkHeight);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, 0,
                      bounds.size.width - [self rightViewRectForBounds:self.bounds].size.width - kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding*3, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

#pragma mark - Preferred height
+ (CGFloat)preferredHeight {
    
    return 35.0f;
}

@end
//
//  AFBlipProfileControllerEditTextField.m
//  Blips
//
//  Created by Andrew Apperley on 2014-04-30.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipProfileControllerEditTextField.h"
#import "UIFont+AFBlipFont.h"
#import "UIColor+AFBlipColor.h"

const CGFloat kAFBlipEditProfileView_TextColorBlackPercentage = 0.85f;
const CGFloat kAFBlipEditProfileView_TextAnimationDuration    = 0.3f;

@implementation AFBlipProfileControllerEditTextField

- (instancetype)initWithFrame:(CGRect)frame roundedCorners:(UIRectCorner)roundedCorners
{
    if(self = [super initWithFrame:frame roundedCorners:roundedCorners]) {
        self.textColor = [UIColor afBlipDarkGreyTextColor];
        self.tintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    }
    return self;
}

- (void)setLeftTextFieldText:(NSString *)text {
    if (self.leftView) {
        return;
    }
    UILabel* leftLabel = [[UILabel alloc] initWithFrame:self.bounds];
    leftLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    leftLabel.textColor = [UIColor colorWithWhite:kAFBlipEditProfileView_TextColorBlackPercentage alpha:kAFBlipEditProfileView_TextColorBlackPercentage];
    leftLabel.text = text;
    [leftLabel sizeToFit];
    self.leftView = leftLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding, 0, self.leftView.frame.size.width,  bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding/2 + [self rightViewRectForBounds:self.bounds].size.width + [self leftViewRectForBounds:self.bounds].size.width, 0,
                      bounds.size.width - [self rightViewRectForBounds:self.bounds].size.width - [self leftViewRectForBounds:self.bounds].size.width - kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding*3, bounds.size.height);
}

- (void)setEditState:(BOOL)editState {
    _editState = editState;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    CATransform3D newTransform = CATransform3DIdentity;
    newTransform.m34 = 1.0f / ((_editState) ? 25 : -25);
    newTransform = CATransform3DTranslate(newTransform, 0, 0, 1);
    
    transformAnimation.toValue = [NSValue valueWithCATransform3D:newTransform];
    transformAnimation.duration = kAFBlipEditProfileView_TextAnimationDuration;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transformAnimation forKey:@"transform"];
    
    typeof(self) wself = self;
    
    [UIView animateWithDuration:kAFBlipEditProfileView_TextAnimationDuration animations:^{
        
        wself.backgroundColor = [UIColor colorWithWhite:1.0f alpha:(!editState) ? 0.1f : 0.9f];
        _checkmark.alpha = (!editState) ? 0.2 : 1;
        wself.userInteractionEnabled = editState;
        wself.textColor = (!editState) ? [UIColor colorWithWhite:kAFBlipEditProfileView_TextColorBlackPercentage alpha:kAFBlipEditProfileView_TextColorBlackPercentage] : [UIColor colorWithWhite:0.0f alpha:kAFBlipEditProfileView_TextColorBlackPercentage];
    }];
}

@end
//
//  AFBlipInitialViewControllerSignInUpTextField.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-20.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFBlipInitialViewControllerSignInUpTextField : UITextField {
    UIView *_checkmark;
}
extern const NSInteger kAFBlipInitial_MaxTextLength;
extern const CGFloat kAFBlipInitialViewControllerSignInUpTextField_CheckmarkPadding;

/** Enables a checkmark. Default is 'NO'. */
@property (nonatomic, assign) BOOL enableCheckmark;

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame roundedCorners:(UIRectCorner)roundedCorners;

#pragma mark - Preferred height
+ (CGFloat)preferredHeight;

@end
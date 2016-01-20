//
//  AFBlipInitialViewControllerSignInViewContentView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInViewContentView.h"
#import "AFBlipInitialViewControllerSignInUpTextField.h"
#import "AFBlipInitialViewUserModel.h"
#import "AFDynamicFontMediator.h"
#import "AFBlipAlertView.h"
#import "AFFAlertViewButtonModel.h"

typedef NS_ENUM(NSUInteger, AFBlipInitialViewControllerSignInViewContentViewTextfieldType) {
    AFBlipInitialViewControllerSignInViewContentViewTextfieldType_Username,
    AFBlipInitialViewControllerSignInViewContentViewTextfieldType_Password
};

#pragma mark - Constants
//Title
const CGFloat kAFBlipInitialViewControllerSignInViewContentView_TitlePosY               = 28.0f;

//Text field
const CGFloat kAFBlipInitialViewControllerSignInViewContentView_TextFieldPosY           = 82.0f;
const CGFloat kAFBlipInitialViewControllerSignInViewContentView_TextFieldPaddingY       = 1.0f;
const CGFloat kAFBlipInitialViewControllerSignInViewContentView_ResetPasswordPaddingY   = 0.0f;

@interface AFBlipInitialViewControllerSignInViewContentView () <UITextFieldDelegate, AFDynamicFontMediatorDelegate, AFFAlertViewDelegate> {
    
    //Font
    AFDynamicFontMediator                        *_dynamicFont;
    
    //Labels
    UILabel                                      *_title;
    AFBlipInitialViewControllerSignInUpTextField *_emailLabel;
    AFBlipInitialViewControllerSignInUpTextField *_passwordLabel;
    UIButton                                     *_resetPasswordButton;
}

@end

@implementation AFBlipInitialViewControllerSignInViewContentView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self createTitle];
        [self createEmailAndPasswordLabels];
        [self createTextChangeNotification];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Title
- (void)createTitle {

    //Title
    _title                  = [[UILabel alloc] init];
    _title.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _title.backgroundColor  = [UIColor clearColor];
    _title.textColor        = [UIColor whiteColor];
    _title.text             = NSLocalizedString(@"AFBlipInitialViewSignIn", nil);

    //Frame
    CGRect frame            = _title.frame;
    frame.origin.y          = kAFBlipInitialViewControllerSignInViewContentView_TitlePosY;
    _title.frame            = frame;
    
    [self.contentView addSubview:_title];
}

#pragma mark - Email and password
- (void)createEmailAndPasswordLabels {
    
    CGFloat labelHeight                          = [AFBlipInitialViewControllerSignInUpTextField preferredHeight];

    CGRect frame                                 = CGRectIntegral(CGRectMake(0, kAFBlipInitialViewControllerSignInViewContentView_TextFieldPosY, CGRectGetWidth(self.contentView.bounds), labelHeight));

    //Username label
    _emailLabel                                  = [[AFBlipInitialViewControllerSignInUpTextField alloc] initWithFrame:frame roundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    _emailLabel.placeholder                      = NSLocalizedString(@"AFBlipSignupFormEmail", nil);
    _emailLabel.returnKeyType                    = UIReturnKeyNext;
    _emailLabel.keyboardType                     = UIKeyboardTypeEmailAddress;
    _emailLabel.delegate                         = self;
    _emailLabel.autocapitalizationType           = UITextAutocapitalizationTypeNone;
    _emailLabel.autocorrectionType               = UITextAutocorrectionTypeNo;
    _emailLabel.enablesReturnKeyAutomatically    = YES;
    [self.contentView addSubview:_emailLabel];

    //Password label
    frame                                        = CGRectIntegral(CGRectMake(0, CGRectGetMaxY(_emailLabel.frame) + kAFBlipInitialViewControllerSignInViewContentView_TextFieldPaddingY, CGRectGetWidth(self.contentView.bounds), labelHeight));

    _passwordLabel                               = [[AFBlipInitialViewControllerSignInUpTextField alloc] initWithFrame:frame roundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    _passwordLabel.secureTextEntry               = YES;
    _passwordLabel.placeholder                   = NSLocalizedString(@"AFBlipSignupFormPassword", nil);
    _passwordLabel.returnKeyType                 = UIReturnKeyDone;
    _passwordLabel.keyboardType                  = UIKeyboardTypeDefault;
    _passwordLabel.delegate                      = self;
    _passwordLabel.autocapitalizationType        = UITextAutocapitalizationTypeNone;
    _passwordLabel.autocorrectionType            = UITextAutocorrectionTypeNo;
    _passwordLabel.enablesReturnKeyAutomatically = YES;
    [self.contentView addSubview:_passwordLabel];
    
    _resetPasswordButton                = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_passwordLabel.frame) +kAFBlipInitialViewControllerSignInViewContentView_ResetPasswordPaddingY, CGRectGetWidth(self.contentView.bounds), 50)];
    _resetPasswordButton.autoresizingMask         = UIViewAutoresizingFlexibleTopMargin;
    _resetPasswordButton.backgroundColor          = [UIColor clearColor];
    [_resetPasswordButton addTarget:self action:@selector(onResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_resetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _resetPasswordButton.titleLabel.numberOfLines = 0;
    _resetPasswordButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_resetPasswordButton setTitle:NSLocalizedString(@"AFBlipSignInResetPasswordText", nil) forState:UIControlStateNormal];
    
    [self.contentView addSubview:_resetPasswordButton];
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    //Title
    _title.font       = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:8];
    [_title sizeToFit];
    
    //Fields
    _emailLabel.font    = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _passwordLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _resetPasswordButton.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-2];
    
    //Submit button
    self.submitButton.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:2];
}

#pragma mark - Text change notification
- (void)createTextChangeNotification {
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)onTextChange:(NSNotification *)notification {
    
    AFBlipInitialViewControllerSignInUpTextField *textField = notification.object;
    
    if(!_model) {
        _model          = [[AFBlipInitialViewUserModel alloc] init];
        _model.type     = AFBlipInitialViewUserModelType_SignIn;
    }
    
    if([textField isEqual:_emailLabel]) {
        
        textField.enableCheckmark = [self validateEmailInput:_emailLabel.text];
        _model.email              = _emailLabel.text;
        
    //Password label
    } else if([textField isEqual:_passwordLabel]) {
        
        textField.enableCheckmark = _passwordLabel.text.length > 2;
        _model.password           = _passwordLabel.text;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.submitButton.enabled = (_emailLabel.text.length && [self validateEmailInput:_emailLabel.text] && _passwordLabel.text.length);

    //Username label
    if([textField isEqual:_emailLabel]) {
      
        [_passwordLabel becomeFirstResponder];
        return NO;
    }

    [_passwordLabel resignFirstResponder];
    return YES;
}

#pragma mark - Email input validation
- (BOOL)validateEmailInput:(NSString *)input {
    
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"] evaluateWithObject:input]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Reset Password
- (void)onResetPassword {
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithStyle:AFFAlertViewStyle_PlainTextInput title:NSLocalizedString(@"AFBlipSignInResetPasswordAlertTitle", nil) message:NSLocalizedString(@"AFBlipSignInResetPasswordAlertText", nil) buttonTitles:@[NSLocalizedString(@"AFBlipEditProfileCancelButtonTitle", nil), NSLocalizedString(@"AFBlipSignInResetPasswordAlertButtonReset", nil)]];
    alertView.delegate = self;
    [alertView show];
    
}

#pragma mark - AFBlipAlertViewDelegate methods
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    NSString *email = [alertView.plainTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([buttonModel index] == 1 && email.length > 0) {
        if ([self.delegate respondsToSelector:@selector(initialViewControllerSignInUpBaseView:didResetPasswordWithEmail:)]) {
            [self.delegate initialViewControllerSignInUpBaseView:self didResetPasswordWithEmail:[email lowercaseString]];
        }
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
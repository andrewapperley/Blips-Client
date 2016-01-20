//
//  AFBlipInitialViewControllerSignUpViewContentView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignUpViewContentView.h"
#import "AFBlipInitialViewControllerSignInUpTextField.h"
#import "AFBlipInitialViewUserModel.h"
#import "AFDynamicFontMediator.h"

#pragma mark - Constants
//Title
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_TitlePosY            = 18.0f;

//Profle image
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_ProfileImageWidth    = 70.0f;
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_ProfileImagePosY     = 5.0f;

//Text field
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_TextFieldPosY        = 142.0f;
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_TextFieldPaddingY    = 1.0f;

//Terms
const CGFloat kAFBlipInitialViewControllerSignUpViewContentView_TermsPaddingY        = 5.0f;

@interface AFBlipInitialViewControllerSignUpViewContentView () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, AFDynamicFontMediatorDelegate> {
    
    //Font
    AFDynamicFontMediator                       *_dynamicFont;
    
    //Profile image
    UIButton                                    *_profileImage;
    
    //Labels
    UIButton                                     *_terms;
    UILabel                                      *_titleLabel;
    AFBlipInitialViewControllerSignInUpTextField *_name;
    AFBlipInitialViewControllerSignInUpTextField *_emailLabel;
    AFBlipInitialViewControllerSignInUpTextField *_passwordLabel;
}

@end

@implementation AFBlipInitialViewControllerSignUpViewContentView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        _userHasChosenAProfileImage = NO;
        
        [self createModel];
        [self createTitle];
        [self createProfileImageSelector];
        [self createInputLabels];
        [self createTermsLabel];
        [self createTextChangeNotification];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Model
- (void)createModel {
    
    _model          = [[AFBlipInitialViewUserModel alloc] init];
    _model.type     = AFBlipInitialViewUserModelType_SignUp;
}

#pragma mark - Title
- (void)createTitle {
    
    //Title
    _titleLabel                  = [[UILabel alloc] init];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.backgroundColor  = [UIColor clearColor];
    _titleLabel.textColor        = [UIColor whiteColor];
    _titleLabel.text             = NSLocalizedString(@"AFBlipInitialViewSignUp", nil);
    
    //Frame
    CGRect frame                 = _titleLabel.frame;
    frame.origin.y               = kAFBlipInitialViewControllerSignUpViewContentView_TitlePosY;
    _titleLabel.frame            = frame;
    
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - Profile image selector
- (void)createProfileImageSelector {
    
    //Create button
    UIImage *selectorProfileImage       = [UIImage imageNamed:@"AFBlipProfileImageSelector"];
    UIImage *defaultProfileImage        = [UIImage imageNamed:@"AFBlipPlaceholderImage"];
    _model.profileImage                 = defaultProfileImage;
    
    _profileImage                       = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kAFBlipInitialViewControllerSignUpViewContentView_ProfileImageWidth, kAFBlipInitialViewControllerSignUpViewContentView_ProfileImageWidth)];
    _profileImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _profileImage.autoresizingMask      = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _profileImage.clipsToBounds         = YES;
    [_profileImage setImage:selectorProfileImage forState:UIControlStateNormal];
    [_profileImage addTarget:self action:@selector(onProfileImage) forControlEvents:UIControlEventTouchUpInside];
    
    _profileImage.layer.cornerRadius    = CGRectGetWidth(_profileImage.bounds) * 0.5f;
    _profileImage.layer.borderColor     = [UIColor whiteColor].CGColor;
    _profileImage.layer.borderWidth     = 2.0f;
    [self.contentView addSubview:_profileImage];
}

- (void)onProfileImage {
    
    UIActionSheet* profileImageChoiceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"AFBlipInitialViewImageSource", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"AFBlipInitialViewImageSourceAlbumType", nil), NSLocalizedString(@"AFBlipInitialViewImageSourceCameraType", nil), nil];
    [profileImageChoiceSheet dismissWithClickedButtonIndex:AFBlipInitialViewUserProfileImageType_Cancel animated:YES];
    [profileImageChoiceSheet showInView:self];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == AFBlipInitialViewUserProfileImageType_Cancel) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case AFBlipInitialViewUserProfileImageType_Album:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        case AFBlipInitialViewUserProfileImageType_Camera:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            break;
    }
    
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Create labels
- (void)createInputLabels {
    
    CGFloat labelHeight                   = [AFBlipInitialViewControllerSignInUpTextField preferredHeight];

    CGRect frame                          = CGRectIntegral(CGRectMake(0, kAFBlipInitialViewControllerSignUpViewContentView_TextFieldPosY, CGRectGetWidth(self.contentView.bounds), labelHeight));

    //Name label
    _name                                        = [[AFBlipInitialViewControllerSignInUpTextField alloc] initWithFrame:frame roundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    _name.placeholder                            = NSLocalizedString(@"AFBlipSignupFormDisplayName", nil);
    _name.returnKeyType                          = UIReturnKeyNext;
    _name.keyboardType                           = UIKeyboardTypeDefault;
    _name.autocorrectionType                     = UITextAutocorrectionTypeNo;
    _name.delegate                               = self;
    _name.enablesReturnKeyAutomatically          = YES;
    [self.contentView addSubview:_name];

    //Email label
    frame                                        = CGRectIntegral(CGRectMake(0, CGRectGetMaxY(_name.frame) + kAFBlipInitialViewControllerSignUpViewContentView_TextFieldPaddingY, CGRectGetWidth(self.contentView.bounds), labelHeight));

    _emailLabel                                  = [[AFBlipInitialViewControllerSignInUpTextField alloc] initWithFrame:frame roundedCorners:0];
    _emailLabel.placeholder                      = NSLocalizedString(@"AFBlipSignupFormEmail", nil);
    _emailLabel.returnKeyType                    = UIReturnKeyNext;
    _emailLabel.keyboardType                     = UIKeyboardTypeEmailAddress;
    _emailLabel.autocorrectionType               = UITextAutocorrectionTypeNo;
    _emailLabel.delegate                         = self;
    _emailLabel.enablesReturnKeyAutomatically    = YES;
    _emailLabel.autocapitalizationType           = UITextAutocapitalizationTypeNone;
    [self.contentView addSubview:_emailLabel];

    //Password label
    frame                                        = CGRectIntegral(CGRectMake(0, CGRectGetMaxY(_emailLabel.frame) + kAFBlipInitialViewControllerSignUpViewContentView_TextFieldPaddingY, CGRectGetWidth(self.contentView.bounds), labelHeight));

    _passwordLabel                               = [[AFBlipInitialViewControllerSignInUpTextField alloc] initWithFrame:frame roundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    _passwordLabel.secureTextEntry               = YES;
    _passwordLabel.placeholder                   = NSLocalizedString(@"AFBlipSignupFormPassword", nil);
    _passwordLabel.returnKeyType                 = UIReturnKeyDone;
    _passwordLabel.keyboardType                  = UIKeyboardTypeDefault;
    _passwordLabel.autocorrectionType            = UITextAutocorrectionTypeNo;
    _passwordLabel.autocapitalizationType        = UITextAutocapitalizationTypeNone;
    _passwordLabel.delegate                      = self;
    _passwordLabel.enablesReturnKeyAutomatically = YES;
    [self.contentView addSubview:_passwordLabel];
}

#pragma mark - Terms label
- (void)createTermsLabel {
    
    //Terms label
    _terms                = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_passwordLabel.frame) +kAFBlipInitialViewControllerSignUpViewContentView_TermsPaddingY, CGRectGetWidth(self.contentView.bounds), 50)];
    _terms.autoresizingMask         = UIViewAutoresizingFlexibleTopMargin;
    _terms.backgroundColor          = [UIColor clearColor];
    [_terms addTarget:self action:@selector(onTerms) forControlEvents:UIControlEventTouchUpInside];
    [_terms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _terms.titleLabel.numberOfLines = 0;
    _terms.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_terms];
    
    //Set title
    NSString *termsFullString         = NSLocalizedString(@"AFBlipSignupFormTerms", nil);
    NSString *termsColoredString      = NSLocalizedString(@"AFBlipSignupFormTermsColoredStrings", nil);

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:termsFullString];
    NSRange fullStringRange           = NSMakeRange(0, termsFullString.length);
    NSRange coloredStringRange        = [termsFullString rangeOfString:termsColoredString];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullStringRange];
    [string addAttribute:NSUnderlineStyleAttributeName value:@(1) range:coloredStringRange];
    
    [_terms setAttributedTitle:string forState:UIControlStateNormal];
}

- (void)onTerms {
    
    [self.delegate initialViewControllerSignUpViewContentViewDidPressTerms:self];
}

#pragma mark - Text change notification
- (void)createTextChangeNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)onTextChange:(NSNotification *)notification {
    
    AFBlipInitialViewControllerSignInUpTextField *textField = notification.object;
    
    NSInteger length = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    //Name label
    if([textField isEqual:_name]) {
        
        textField.enableCheckmark = _name.text.length > 2 && length < kAFBlipInitial_MaxTextLength;
        _model.name               = _name.text;
        
    //Email label
    } else if([textField isEqual:_emailLabel]) {
        
        textField.enableCheckmark = [self validateEmailInput:_emailLabel.text] && length < kAFBlipInitial_MaxTextLength;
        _model.email              = _emailLabel.text;
        
    //Password label
    } else if([textField isEqual:_passwordLabel]) {
        
        textField.enableCheckmark = _passwordLabel.text.length > 2 && length < kAFBlipInitial_MaxTextLength;
        _model.password           = _passwordLabel.text;
    }
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
    _titleLabel.font       = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:8];
    [_titleLabel sizeToFit];

    //Profile frame
    CGRect profileImageFrame            = _profileImage.frame;
    profileImageFrame.origin.x          = (CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(profileImageFrame)) * 0.5f;
    profileImageFrame.origin.y          = CGRectGetMaxY(_titleLabel.frame) +  kAFBlipInitialViewControllerSignUpViewContentView_ProfileImagePosY;
    _profileImage.frame                 = profileImageFrame;
    
    //Fields
    _name.font          = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _emailLabel.font    = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _passwordLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    
    //Terms
    _terms.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-2];
    
    //Submit button
    self.submitButton.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:2];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self validateSubmiteButton];
    
    //Name label
    if([textField isEqual:_name]) {
        
        [_emailLabel becomeFirstResponder];
        return NO;
    
    //Email label
    } else if([textField isEqual:_emailLabel]) {
        
        [_passwordLabel becomeFirstResponder];
        return NO;
    }
    
    [_passwordLabel resignFirstResponder];
    return YES;
}

#pragma mark - Submit button 
- (void)validateSubmiteButton {
    
    self.submitButton.enabled = (_name.text.length > 2 && [self validateEmailInput:_emailLabel.text] && _passwordLabel.text.length > 2);
}

#pragma mark - Email input validation
- (BOOL)validateEmailInput:(NSString *)input {
    
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"] evaluateWithObject:input]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *image;
    
    if(info[UIImagePickerControllerEditedImage]) {
        
        image = [info[UIImagePickerControllerEditedImage] copy];
        _userHasChosenAProfileImage = YES;
    } else {
        image        = [UIImage imageNamed:@"AFBlipPlaceholderImage"];
    }

    _model.profileImage = image;
    [_profileImage setImage:image forState:UIControlStateNormal];
    [self validateSubmiteButton];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openImagePicker {
    
    [self onProfileImage];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
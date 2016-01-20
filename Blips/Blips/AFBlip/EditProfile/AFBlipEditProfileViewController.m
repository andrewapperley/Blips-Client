//
//  AFBlipEditProfileViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-04-25.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipEditProfileViewController.h"
#import "AFBlipProfileControllerEditTextField.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipUserModel.h"
#import "AFBlipAlertView.h"
#import "UIFont+AFBlipFont.h"
#import "UIImage+ImageWithColor.h"
#import "AFBlipInitialViewControllerSignUpViewContentView.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipAWSS3AbstractFactory.h"
#import "UIButton+AFBlipButton.h"
#import "UIColor+AFBlipColor.h"
#import "AFFAlertViewButtonModel.h"
#import "AFBlipAdditionalFiltersViewController.h"
#import <StoreKit/StoreKit.h>

@interface AFBlipEditProfileViewController () <UITextFieldDelegate, AFFAlertViewDelegate> {
    
    NSString* _displayName;
    NSString* _email;
    NSString* _password;
    NSData* _profileImage;
    
    UILabel* _notificationsLabel;
    CGFloat _keyboardHeight;
    UITapGestureRecognizer* _tapGesture;
    UITextField* _currentTextField;
    UIScrollView* _scrollView;
    UIButton* _profileImageViewButton;
    UIButton* _deactivateButton;
    UIButton* _submitButton;
    UIButton* _filtersBuyButton;
    AFBlipActivityIndicator* _activityIndicator;
    NSArray* _editFields;
    NSMutableArray* _editButtons;
    NSError* _deactivateFailedError;
    AFBlipAdditionalFiltersViewController *_additionalFiltersController;
}
@end

//Profile Image
const CGFloat kAFBlipEditProfile_ProfileImagePosY            = 95.0f;
const CGFloat kAFBlipEditProfile_ProfileImageSize            = 90.0f;
const CGFloat kAFBlipEditProfile_ImageSize                   = 100;

//Toggle
const CGFloat kAFBlipEditProfile_TogglePaddingY              = 30.0f;
const CGFloat kAFBlipEditProfile_TogglePaddingX              = 21.0f;

//Text fields
const CGFloat kAFBlipEditProfile_TextFieldPosY               = 216.0f;
const CGFloat kAFBlipEditProfile_TextFieldPaddingY           = 1.0f;
const CGFloat kAFBlipEditProfile_TextFieldPaddingX           = 18.0f;
const CGFloat kAFBlipEditProfile_TextFieldEditButtonPaddingX = 5.0f;

//Submit button
const CGFloat kAFBlipEditProfile_SubmitButtonPaddingX        = 25.0f;
const CGFloat kAFBlipEditProfile_SubmitButtonHeight          = 44.0f;
const CGFloat kAFBlipEditProfile_SubmitButtonWhiteAlpha      = 0.1f;
const CGFloat kAFBlipEditProfile_SubmitButtonWhiteAlpha_High = 0.2f;
const CGFloat kAFBlipEditProfile_DeactivateButtonRedAlpha    = 0.5f;
const CGFloat kAFBlipEditProfile_SubmitButtonBorderWidth     = 1.0f;
const CGFloat kAFBlipEditProfile_HorizontalPadding           = 25.0f;

const NSInteger kAFBlipEditProfile_MaxTextLength             = 255;

typedef NS_ENUM(NSInteger, AFBlipEditProfileTextField) {
    AFBlipEditProfileTextField_Name,
    AFBlipEditProfileTextField_Email,
    AFBlipEditProfileTextField_Password,
    AFBlipEditProfileTextField_Count
};

typedef NS_ENUM(NSInteger, AFBlipEditProfileAlertViewTypes) {
    AFBlipEditProfileAlertViewTypes_Default,
    AFBlipEditProfileAlertViewTypes_Deactivate
};

@implementation AFBlipEditProfileViewController


- (void)viewDidLoad {

    [self createScrollView];
    [self createProfileImage];
    [self createUpdateFields];
    [self createNotificationsToggle];
    [self createSubmitButton];
    [self createFiltersBuyButton];
    [self createDeactivateButton];
    [self createNotifications];
    [self createGesture];
    
    [super viewDidLoad];
}

- (void)leftButtonAction {
    [self dismissView];
}

- (void)editButtonAction:(UIButton *)button {

    UIImage* const editCloseImage = [UIImage imageNamed:@"AFBlipseditcloseprofileimageicon"];
    UIImage* const editImage      = [UIImage imageNamed:@"AFBlipseditprofileimageicon"];
    
    AFBlipProfileControllerEditTextField* textField = _editFields[button.tag];
    [textField setEditState:![textField editState]];
    if (textField.editState) {
        [textField becomeFirstResponder];
        [(UIImageView *)button.subviews.lastObject setImage:editCloseImage];
    } else {
        [textField resignFirstResponder];
        [(UIImageView *)button.subviews.lastObject setImage:editImage];
    }
}

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
}

- (void)createProfileImage {
    
    _profileImageViewButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kAFBlipEditProfile_ProfileImageSize)/2, kAFBlipEditProfile_ProfileImagePosY, kAFBlipEditProfile_ProfileImageSize, kAFBlipEditProfile_ProfileImageSize)];
    _profileImageViewButton.layer.cornerRadius    = _profileImageViewButton.frame.size.width*0.5f;
    _profileImageViewButton.contentMode = UIViewContentModeScaleAspectFill;
    _profileImageViewButton.autoresizingMask      = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _profileImageViewButton.clipsToBounds         = YES;
    _profileImageViewButton.layer.borderColor     = [UIColor whiteColor].CGColor;
    _profileImageViewButton.layer.borderWidth     = 2.0f;

    typeof(_profileImageViewButton) __weak weakProfileImageViewButton = _profileImageViewButton;
    AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    [imageFactory objectForKey:[AFBlipUserModelSingleton sharedUserModel].userModel.userImageUrl completion:^(NSData *data) {
        [weakProfileImageViewButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal animated:YES];
    } failure:nil];
    
    [_profileImageViewButton addTarget:self action:@selector(onProfileImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* editIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AFBlipseditprofileimageicon"]];
    editIcon.userInteractionEnabled = NO;
    UIView* editIconContainer = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_profileImageViewButton.frame) - editIcon.frame.size.width*1.5, CGRectGetMinY(_profileImageViewButton.frame) + editIcon.frame.size.height/2, editIcon.frame.size.width*1.5, editIcon.frame.size.height*1.5)];
    editIconContainer.clipsToBounds = YES;
    editIconContainer.backgroundColor = [UIColor whiteColor];
    editIconContainer.layer.cornerRadius = editIconContainer.frame.size.width*0.5f;
    editIcon.frame = CGRectMake((editIconContainer.frame.size.width - editIcon.frame.size.width*0.75)/2, (editIconContainer.frame.size.height - editIcon.frame.size.height*0.75)/2, editIcon.frame.size.width*0.75, editIcon.frame.size.height*0.75);
    
    [_scrollView addSubview:_profileImageViewButton];
    [editIconContainer addSubview:editIcon];
    [_scrollView addSubview:editIconContainer];
}

- (void)createUpdateFields {
    
    UIImage* editIconImage = [UIImage imageNamed:@"AFBlipseditprofileimageicon"];
    
    CGFloat labelHeight                   = [AFBlipInitialViewControllerSignInUpTextField preferredHeight];
    CGRect frame                          = CGRectIntegral(CGRectMake(kAFBlipEditProfile_TextFieldPaddingX, kAFBlipEditProfile_TextFieldPosY, CGRectGetWidth(self.view.bounds) - kAFBlipEditProfile_TextFieldPaddingX * 2 - editIconImage.size.height*1.5, labelHeight));
    _editButtons = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (NSInteger i = 0; i < AFBlipEditProfileTextField_Count; i++) {
        
        UIImageView* editIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AFBlipseditprofileimageicon"]];
        UIButton* editIconContainer = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width + editIcon.frame.size.width*1.5, frame.origin.y + editIcon.frame.size.height/2, editIcon.frame.size.width*1.5, editIcon.frame.size.height*1.5)];
        editIconContainer.clipsToBounds = YES;
        [editIconContainer setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        editIconContainer.layer.cornerRadius = editIconContainer.frame.size.width*0.5f;
        editIcon.frame = CGRectMake((editIconContainer.frame.size.width - editIcon.frame.size.width*0.75)/2, (editIconContainer.frame.size.height - editIcon.frame.size.height*0.75)/2, editIcon.frame.size.width*0.75, editIcon.frame.size.height*0.75);
        [editIconContainer addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [editIconContainer addSubview:editIcon];
        [_editButtons addObject:editIconContainer];
        editIconContainer.tag = i;
    }
    
    AFBlipProfileControllerEditTextField* displayName = [[AFBlipProfileControllerEditTextField alloc] initWithFrame:frame roundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    displayName.text                                   = [AFBlipUserModelSingleton sharedUserModel].userModel.displayName;
    [displayName setLeftTextFieldText:NSLocalizedString(@"AFBlipSignupFormDisplayName", nil)];
    displayName.returnKeyType                          = UIReturnKeyDone;
    displayName.keyboardType                           = UIKeyboardTypeDefault;
    displayName.autocorrectionType                     = UITextAutocorrectionTypeNo;
    displayName.delegate                               = self;
    displayName.enablesReturnKeyAutomatically          = YES;
    displayName.tag                                    = AFBlipEditProfileTextField_Name;
    
    frame = CGRectIntegral(CGRectMake(kAFBlipEditProfile_TextFieldPaddingX, CGRectGetMaxY(displayName.frame) + kAFBlipEditProfile_TextFieldPaddingY, CGRectGetWidth(self.view.bounds) - kAFBlipEditProfile_TextFieldPaddingX * 2 - [[_editButtons firstObject] frame].size.width, labelHeight));
    
    [_editButtons[1] setFrame:CGRectMake(frame.size.width + editIconImage.size.width*1.5, frame.origin.y + editIconImage.size.height/2, [_editButtons[1] frame].size.width, [_editButtons[1] frame].size.height)];
    
    AFBlipProfileControllerEditTextField* email = [[AFBlipProfileControllerEditTextField alloc] initWithFrame:frame roundedCorners:0];
    email.text                             = [AFBlipUserModelSingleton sharedUserModel].userModel.userName;
    [email setLeftTextFieldText:NSLocalizedString(@"AFBlipSignupFormEmail", nil)];
    email.returnKeyType                    = UIReturnKeyDone;
    email.keyboardType                     = UIKeyboardTypeEmailAddress;
    email.autocorrectionType               = UITextAutocorrectionTypeNo;
    email.delegate                         = self;
    email.enablesReturnKeyAutomatically    = YES;
    email.autocapitalizationType           = UITextAutocapitalizationTypeNone;
    email.tag                              = AFBlipEditProfileTextField_Email;
    
    frame = CGRectIntegral(CGRectMake(kAFBlipEditProfile_TextFieldPaddingX, CGRectGetMaxY(email.frame) + kAFBlipEditProfile_TextFieldPaddingY, CGRectGetWidth(self.view.bounds) - kAFBlipEditProfile_TextFieldPaddingX * 2 - editIconImage.size.height*1.5, labelHeight));
    
    [_editButtons[2] setFrame:CGRectMake(frame.size.width + editIconImage.size.width*1.5, frame.origin.y + editIconImage.size.height/2, [_editButtons[1] frame].size.width, [_editButtons[1] frame].size.height)];
    
    AFBlipProfileControllerEditTextField* password = [[AFBlipProfileControllerEditTextField alloc] initWithFrame:frame roundedCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight];
    password.secureTextEntry               = YES;
    [password setLeftTextFieldText:NSLocalizedString(@"AFBlipSignupFormPassword", nil)];
    password.text                          = NSLocalizedString(@"AFBlipEditProfilePasswordButtonPlaceholder", nil);
    password.returnKeyType                 = UIReturnKeyDone;
    password.keyboardType                  = UIKeyboardTypeDefault;
    password.autocorrectionType            = UITextAutocorrectionTypeNo;
    password.autocapitalizationType        = UITextAutocapitalizationTypeNone;
    password.clearsOnBeginEditing          = YES;
    password.delegate                      = self;
    password.enablesReturnKeyAutomatically = YES;
    password.tag                           = AFBlipEditProfileTextField_Password;
    
    displayName.textAlignment = email.textAlignment = password.textAlignment = NSTextAlignmentRight;
    
    displayName.font = email.font = password.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    displayName.textColor = email.textColor = password.textColor = [UIColor darkGrayColor];
    
    _editFields = @[displayName, email, password];
    
    [_scrollView addSubview:displayName];
    [_scrollView addSubview:email];
    [_scrollView addSubview:password];
    
    for (UIButton* button in _editButtons) {
        [_scrollView addSubview:button];
    }
    
    displayName.editState = email.editState = password.editState = NO;
}

#pragma mark - Notifications Toggle
- (void)createNotificationsToggle {
    _notificationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAFBlipEditProfile_TogglePaddingX, CGRectGetMaxY([(UIView *)_editFields.lastObject frame]) + kAFBlipEditProfile_TogglePaddingY, self.view.frame.size.width, 0)];
    _notificationsLabel.textColor = [UIColor whiteColor];
    _notificationsLabel.text = NSLocalizedString(@"AFBlipEditProfileNotificationsTitle", nil);
    [_notificationsLabel sizeToFit];
    [_scrollView addSubview:_notificationsLabel];
    
    UISwitch* toggleSwitch = [[UISwitch alloc] init];
    toggleSwitch.frame = CGRectMake(self.view.frame.size.width - toggleSwitch.frame.size.width - kAFBlipEditProfile_TextFieldPaddingX, _notificationsLabel.frame.origin.y - 5, toggleSwitch.frame.size.width, toggleSwitch.frame.size.height);
    [toggleSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kAFBlipsUserNotificationPreferenceToggle]];
    toggleSwitch.onTintColor = [UIColor afBlipToggleSwitchColor];
    [toggleSwitch addTarget:self action:@selector(notificationsToggleDidSwitch:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:toggleSwitch];
}

#pragma mark - Deactivate Button
- (void)createDeactivateButton {
    
    _deactivateButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFBlipEditProfile_SubmitButtonPaddingX, CGRectGetMaxY(_filtersBuyButton.frame) + kAFBlipEditProfile_SubmitButtonHeight/3, CGRectGetWidth(self.view.bounds) - (kAFBlipEditProfile_SubmitButtonPaddingX * 2), kAFBlipEditProfile_SubmitButtonHeight)];
    _deactivateButton.autoresizingMask       = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _deactivateButton.backgroundColor = [UIColor afBlipDangerButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha];
    
    //Title
    NSString *text = NSLocalizedString(@"AFBlipEditProfileDeactivateButtonTitle", nil);
    [_deactivateButton setTitle:text forState:UIControlStateNormal];
    [_deactivateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deactivateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    //Actions
    //Normal
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchCancel];
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragExit];
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragOutside];
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchUpOutside];
    
    //Highlight
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    [_deactivateButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragInside];
    
    //Select
    [_deactivateButton addTarget:self action:@selector(onDeactivateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Border
    _deactivateButton.layer.cornerRadius = CGRectGetHeight(_deactivateButton.frame) * 0.5f;
    _deactivateButton.layer.borderWidth  = kAFBlipEditProfile_SubmitButtonBorderWidth;
    _deactivateButton.layer.borderColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipEditProfile_SubmitButtonWhiteAlpha].CGColor;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(_deactivateButton.frame) + kAFBlipEditProfile_SubmitButtonPaddingX/1.5);
    [_scrollView addSubview:_deactivateButton];
    
}

#pragma mark - Filters button
- (void)createFiltersBuyButton {
    
    CGFloat filtersButtonY = CGRectGetMaxY(_submitButton.frame) + kAFBlipEditProfile_SubmitButtonHeight/3;
    
    //Button
    _filtersBuyButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFBlipEditProfile_SubmitButtonPaddingX, filtersButtonY, CGRectGetWidth(self.view.bounds) - (kAFBlipEditProfile_SubmitButtonPaddingX * 2), kAFBlipEditProfile_SubmitButtonHeight)];
    _filtersBuyButton.autoresizingMask       = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _filtersBuyButton.backgroundColor = [UIColor afBlipBuyButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha];
    
    //Title
    NSString *text = NSLocalizedString(@"AFBlipEditProfileFiltersButtonTitle", nil);
    [_filtersBuyButton setTitle:text forState:UIControlStateNormal];
    [_filtersBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_filtersBuyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    //Actions
    //Normal
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchCancel];
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragExit];
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragOutside];
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchUpOutside];
    
    //Highlight
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    [_filtersBuyButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragInside];
    
    //Select
    [_filtersBuyButton addTarget:self action:@selector(onNewFiltersButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Border
    _filtersBuyButton.layer.cornerRadius = CGRectGetHeight(_filtersBuyButton.frame) * 0.5f;
    _filtersBuyButton.layer.borderWidth  = kAFBlipEditProfile_SubmitButtonBorderWidth;
    _filtersBuyButton.layer.borderColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipEditProfile_SubmitButtonWhiteAlpha].CGColor;
    [_scrollView addSubview:_filtersBuyButton];
    _filtersBuyButton.enabled = [SKPaymentQueue canMakePayments];
}

#pragma mark - Submit button
- (void)createSubmitButton {
    
    CGFloat submitButtonY = CGRectGetHeight(self.view.bounds) - ((kAFBlipEditProfile_SubmitButtonHeight + kAFBlipEditProfile_HorizontalPadding/1.5) * ((self.view.bounds.size.height > 480) ? 2 : 1));
    
    //Button
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFBlipEditProfile_SubmitButtonPaddingX, submitButtonY, CGRectGetWidth(self.view.bounds) - (kAFBlipEditProfile_SubmitButtonPaddingX * 2), kAFBlipEditProfile_SubmitButtonHeight)];
    _submitButton.autoresizingMask       = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _submitButton.enabled = NO;
    
    //Title
    NSString *text = NSLocalizedString(@"AFBlipEditProfileSaveButtonTitle", nil);
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
    _submitButton.layer.borderWidth  = kAFBlipEditProfile_SubmitButtonBorderWidth;
    _submitButton.layer.borderColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipEditProfile_SubmitButtonWhiteAlpha].CGColor;
    [_scrollView addSubview:_submitButton];
}

- (void)createGesture {
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyboardHide:)];
    _tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];
    _tapGesture.enabled = NO;
}

- (void)notificationsToggleDidSwitch:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.state forKey:kAFBlipsUserNotificationPreferenceToggle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    (sender.on) ? [self registerNotifications] : [self unregisterNotifications];
}

- (void)registerNotifications {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    
}

- (void)unregisterNotifications {
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAFBlipsUserNotificationNotificationUnRegister object:nil];
}

- (void)onNewFiltersButton:(UIButton *)button {
    [self onSubmitButtonNormal:button];
    [self showActivityIndicator:YES];
    typeof(self) __weak wself = self;
    _additionalFiltersController = [[AFBlipAdditionalFiltersViewController alloc] initWithToolbarWithTitle:NSLocalizedString(@"AFBlipAdditionalFiltersTitle", nil) leftButton:NSLocalizedString(@"AFBlipAdditionalFiltersCancelButtonTitle", nil) rightButton:nil loadedBlock:^(AFBlipAdditionalFiltersViewController *controller){
        [wself presentViewController:controller animated:YES completion:^{
            [wself showActivityIndicator:NO];
        }];
    } transactionComplete:nil];
}

- (void)onDeactivateButton:(UIButton *)button {
    
    [self onSubmitButtonNormal:button];
    
    AFBlipAlertView* alertView = [self showErrorMessage:NSLocalizedString(@"AFBlipEditProfileDeactivateMessage", nil) title:NSLocalizedString(@"AFBlipEditProfileDeactivateTitle", nil)  buttons:@[NSLocalizedString(@"AFBlipEditProfileDeactivateAlertNo", nil), NSLocalizedString(@"AFBlipEditProfileDeactivateAlertYes", nil)] style:AFFAlertViewStyle_SecureTextInput];
    alertView.tag = AFBlipEditProfileAlertViewTypes_Deactivate;
    alertView.delegate = self;
    [self removeNotifications];
    [alertView show];
}

- (void)onSubmitButton:(UIButton *)button {
    
    __block AFBlipUserModelFactory* modelFactory = [[AFBlipUserModelFactory alloc] init];
    
    typeof(self) __weak weakSelf = self;
    
    [self showActivityIndicator:YES];
    
    if (_email) {
        [modelFactory checkIfUsernameIsAvailable:_email success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (networkCallback.success) {
                [weakSelf updateUserInfoWithModelFactory:modelFactory];
            } else {
                [weakSelf showActivityIndicator:NO];
            }
        } failure:^(NSError *error) {
            
            NSString *message = NSLocalizedString(error.localizedDescription, nil);
            AFBlipAlertView* alertView = [weakSelf showErrorMessage:message title:NSLocalizedString(@"AFBlipEditProfileTitle", nil)  buttons:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)] style:AFFAlertViewStyle_Default];
            alertView.tag = AFBlipEditProfileAlertViewTypes_Default;
            [alertView show];
            [weakSelf showActivityIndicator:NO];
        }];
    } else {
        [self updateUserInfoWithModelFactory:modelFactory];
    }
    
    
    [self onSubmitButtonNormal:button];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _tapGesture.enabled = YES;
    _currentTextField = textField;
    if (_keyboardHeight > 0) {
        [_scrollView setContentOffset:CGPointMake(0, -_keyboardHeight + _currentTextField.frame.origin.y) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    AFBlipInitialViewControllerSignInUpTextField *_textField = (AFBlipInitialViewControllerSignInUpTextField *)textField;
    if (_textField.tag == AFBlipEditProfileTextField_Password && [[_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        if ([textField respondsToSelector:@selector(setEnableCheckmark:)]) {
            _textField.text = NSLocalizedString(@"AFBlipEditProfilePasswordButtonPlaceholder", nil);
            _textField.enableCheckmark = _submitButton.enabled = NO;
            _password = @"";
        }
    }
}

- (void)updateUserInfoWithModelFactory:(AFBlipUserModelFactory *)modelFactory {
    
    typeof(self) __weak weakSelf = self;
    
    [modelFactory updateUserWithUserId:[AFBlipUserModelSingleton sharedUserModel].userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken displayName:_displayName password:_password email:_email profileImage:_profileImage success:^(AFBlipUserModel *userModel, AFBlipBaseNetworkModel *networkCallback) {
        
        [weakSelf showActivityIndicator:NO];
        
        if (networkCallback.success) {
            [[AFBlipUserModelSingleton sharedUserModel] updateUserModelWithUserModel:userModel];
            
            NSString* newAccessToken = networkCallback.responseData[@"access_token"];
            NSString* expiryDate     = networkCallback.responseData[@"expiry_date"];
            if (![newAccessToken isEqualToString:@""] && ![expiryDate isEqualToString:@""]) {
                [[AFBlipKeychain keychain] setAccessToken:newAccessToken expiryDate:expiryDate userName:[AFBlipUserModelSingleton sharedUserModel].userModel.userName];
            }

        }
        
        if (((!_displayName || !_displayName || !_displayName) && _profileImage) || networkCallback.success) {
            [weakSelf dismissView];
            if ([_delegate respondsToSelector:@selector(userProfileDidUpdateWithProfileImage:displayName:)]) {
                [_delegate userProfileDidUpdateWithProfileImage:_profileImage displayName:_displayName];
            }
        }
        
    } failure:^(NSError *error) {
        NSString *message = NSLocalizedString(error.localizedDescription, nil);
        [weakSelf showActivityIndicator:NO];
       AFBlipAlertView* alertView = [weakSelf showErrorMessage:message title:NSLocalizedString(@"AFBlipEditProfileTitle", nil) buttons:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)] style:AFFAlertViewStyle_Default];
        alertView.tag = AFBlipEditProfileAlertViewTypes_Default;
        [alertView show];
    }];
}

- (void)onSubmitButtonHighlight:(UIButton *)button {
    
    button.backgroundColor = ([button isEqual:_submitButton] ? [UIColor colorWithWhite:1.0f alpha:kAFBlipEditProfile_SubmitButtonWhiteAlpha_High] : [button isEqual:_filtersBuyButton] ? [UIColor afBlipBuyButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha_High] : [UIColor afBlipDangerButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha_High]);
}

- (void)onSubmitButtonNormal:(UIButton *)button {
    
    button.backgroundColor = ([button isEqual:_submitButton] ? [UIColor clearColor] : [button isEqual:_filtersBuyButton] ? [UIColor afBlipBuyButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha] : [UIColor afBlipDangerButtonColor:kAFBlipEditProfile_SubmitButtonWhiteAlpha]);
}

- (BOOL)textFieldShouldReturn:(AFBlipProfileControllerEditTextField *)textField {
    [textField setEditState:NO];
    [textField resignFirstResponder];
    return YES;
}

- (void)onTextChange:(NSNotification *)notification {
    
    AFBlipInitialViewControllerSignInUpTextField *textField = notification.object;
    
    NSInteger length = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    switch (textField.tag) {
        case AFBlipEditProfileTextField_Name:
            textField.enableCheckmark = _submitButton.enabled = (length > 2 && length < kAFBlipEditProfile_MaxTextLength && ![textField.text isEqualToString:[AFBlipUserModelSingleton sharedUserModel].userModel.displayName]) || _profileImage;
            _displayName = (textField.enableCheckmark) ? textField.text : @"";
            break;
        case AFBlipEditProfileTextField_Email:
            textField.enableCheckmark = _submitButton.enabled = ([self validateEmailInput:textField.text] && length > 2 && length < kAFBlipEditProfile_MaxTextLength && ![textField.text isEqualToString:[AFBlipUserModelSingleton sharedUserModel].userModel.userName]) || _profileImage;
            _email = (textField.enableCheckmark) ? textField.text : @"";
            break;
        case AFBlipEditProfileTextField_Password:
            textField.enableCheckmark = _submitButton.enabled = (length > 2 && length < kAFBlipEditProfile_MaxTextLength) || _profileImage;
            _password = (textField.enableCheckmark) ? textField.text : @"";
            break;
    }
}

- (BOOL)validateEmailInput:(NSString *)input {
    
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"] evaluateWithObject:input]) {
        return YES;
    }
    
    return NO;
}

- (void)onProfileImage {
    
    UIActionSheet* profileImageChoiceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"AFBlipInitialViewImageSource", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"AFBlipInitialViewImageSourceAlbumType", nil), NSLocalizedString(@"AFBlipInitialViewImageSourceCameraType", nil), nil];
    [profileImageChoiceSheet dismissWithClickedButtonIndex:AFBlipInitialViewUserProfileImageType_Cancel animated:YES];
    [profileImageChoiceSheet showInView:self.view];
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
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    
    if(info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    _submitButton.enabled = YES;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kAFBlipEditProfile_ImageSize, kAFBlipEditProfile_ImageSize), YES, 0);
    
    [image drawInRect:CGRectMake(0, 0, kAFBlipEditProfile_ImageSize, kAFBlipEditProfile_ImageSize)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _profileImage = UIImageJPEGRepresentation(image, 1);
    [_profileImageViewButton setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.view.center;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    } else if(show) {
        [_activityIndicator startAnimating];
    }
    
    
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Keyboard
- (void)createNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onKeyboardShow:(NSNotification *)notification {
    
    _tapGesture.enabled = YES;
    //Keyboard animations
    NSDictionary *notifictionDictionary = notification.userInfo;
    _keyboardHeight                     = CGRectGetHeight([notifictionDictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    [_scrollView setContentOffset:CGPointMake(0, -_keyboardHeight + _currentTextField.frame.origin.y) animated:YES];
}

- (void)onKeyboardHide:(NSNotification *)notification {
    
    _tapGesture.enabled = NO;
    [_currentTextField resignFirstResponder];
    _currentTextField = nil;
    [_scrollView setContentOffset:CGPointZero animated:YES];
    
    for (AFBlipProfileControllerEditTextField* textfield in _editFields) {
        [textfield setEditState:NO];
    }
    
    UIImage* const editImage = [UIImage imageNamed:@"AFBlipseditprofileimageicon"];
    
    for (UIButton* button in _editButtons) {
        [(UIImageView *)button.subviews.lastObject setImage:editImage];
    }
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize {
    
    //Edit fields
    for(AFBlipProfileControllerEditTextField *textfield in _editFields) {
        textfield.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    }
    
    //Notification label
    _notificationsLabel.font      = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
    [_notificationsLabel sizeToFit];

    //Deactivate button
    _deactivateButton.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:2];
    
    //Submit button
    _submitButton.titleLabel.font = _deactivateButton.titleLabel.font;
    
    //Filters Button
    _filtersBuyButton.titleLabel.font = _submitButton.titleLabel.font;
}

#pragma mark - Error handling
- (AFBlipAlertView *)showErrorMessage:(NSString *)errorMessage title:(NSString *)title buttons:(NSArray *)buttonTitles style:(AFFAlertViewStyle)style {
    
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithStyle:style title:title message:errorMessage buttonTitles:buttonTitles];
    [self removeNotifications];

    return alertView;
}

- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    /** Handling for when the user chooses to deactivate their account or not */
    
    if (buttonModel.index == 1) {
        if (alertView.tag == AFBlipEditProfileAlertViewTypes_Deactivate) {
            typeof(self) __weak weakSelf = self;
            [self showActivityIndicator:YES];
            AFBlipUserModelFactory* factory = [[AFBlipUserModelFactory alloc] init];
            [factory fetchDeactivateUserId:[AFBlipUserModelSingleton sharedUserModel].userModel.user_id password:alertView.secureTextField.text accessToken:[AFBlipKeychain keychain].accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
                [weakSelf showActivityIndicator:NO];
                if (!networkCallback.success) {
                    _deactivateFailedError = [NSError errorWithDomain:@"" code:0 userInfo:@{@"responseMessage": networkCallback.responseMessage}];
                } else {
                    if ([weakSelf.delegate respondsToSelector:@selector(userDidDeactivateAccount)]) {
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            [weakSelf.delegate userDidDeactivateAccount];
                        }];
                    }
                }
            } failure:^(NSError *error) {
                [weakSelf showActivityIndicator:NO];
                _deactivateFailedError = [NSError errorWithDomain:@"" code:0 userInfo:@{@"responseMessage": error.localizedDescription}];
            }];
        } else {
            AFBlipAlertView* alertView = [self showErrorMessage:NSLocalizedString(@"AFBlipEditProfileDeactivateMessage", nil) title:NSLocalizedString(@"AFBlipEditProfileDeactivateTitle", nil) buttons:@[NSLocalizedString(@"AFBlipEditProfileDeactivateAlertNo", nil), NSLocalizedString(@"AFBlipEditProfileDeactivateAlertYes", nil)] style:AFFAlertViewStyle_SecureTextInput];
            alertView.tag = AFBlipEditProfileAlertViewTypes_Deactivate;
            alertView.delegate = self;
            [self removeNotifications];
            [alertView show];
        }
        
    } else {
        [self createNotifications];
    }
}

- (void)alertViewDidDismss:(AFFAlertView *)alertView {
    
    if (_deactivateFailedError) {
        AFBlipAlertView* alertView = [self showErrorMessage:NSLocalizedString(_deactivateFailedError.userInfo[@"responseMessage"], nil) title:NSLocalizedString(@"AFBlipEditProfileDeactivateTitle", nil)  buttons:@[NSLocalizedString(@"AFBlipEditProfileDeactivateAlertNo", nil), NSLocalizedString(@"AFBlipEditProfileRetryButtonTitle", nil)] style:AFFAlertViewStyle_Default];
        alertView.tag = AFBlipEditProfileAlertViewTypes_Default;
        [self removeNotifications];
        alertView.delegate = self;
        [alertView show];
        _deactivateFailedError = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
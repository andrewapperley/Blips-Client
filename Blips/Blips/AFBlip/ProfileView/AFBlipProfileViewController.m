//
//  AFBlipProfileViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFBlipFAQModal.h"
#import "AFBlipProfileCollectionView.h"
#import "AFBlipProfileViewController.h"
#import "AFBlipProfileViewControllerStatics.h"
#import "AFBlipProfileViewImage.h"
#import "AFBlipUserModelSingleton.h"
#import "AFFAlertViewButtonModel.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFBlipUserModel.h"
#import <MessageUI/MessageUI.h>
#import "AFBlipEditProfileViewController.h"
#import "AFPlatformUtility.h"

@interface AFBlipProfileViewController () <AFBlipProfileCollectionViewDelegate, AFFAlertViewDelegate, MFMailComposeViewControllerDelegate, AFBlipEditProfileDelegate> {
    
    CGRect _frame;
    AFBlipProfileViewImage* _profileImageView;
}

@end

@implementation AFBlipProfileViewController

#pragma mark - Init
- (instancetype)initWithViewFrame:(CGRect)frame{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _frame  = frame;
        _isOpen = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame            = _frame;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self createProfileViewImageView];
    [self createProfileViewCollectionView];
}

#pragma mark - Create profile image view 
- (void)createProfileViewImageView {
    
    CGRect profileImageViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kAFBlipProfileViewImage_Height);
    
    AFBlipUserModel *userModel       = [AFBlipUserModelSingleton sharedUserModel].userModel;
    NSString *userImageURLString     = userModel.userImageUrl;
    NSString *userDisplayNameString  = userModel.displayName;
    
    _profileImageView = [[AFBlipProfileViewImage alloc] initWithFrame:profileImageViewFrame displyName:userDisplayNameString displayImageURLString:userImageURLString];
    _profileImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_profileImageView];
}

#pragma mark - Create collection view
- (void)createProfileViewCollectionView {
    
    CGFloat borderWidth = kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundBorderWidth;
    
    AFBlipProfileCollectionView *collectionView  = [[AFBlipProfileCollectionView alloc] initWithFrame:CGRectMake( - borderWidth, kAFBlipProfileViewImage_Height, CGRectGetWidth(self.view.frame) + (borderWidth * 2), CGRectGetWidth(self.view.frame) * 2)];
    collectionView.profileCollectionViewDelegate = self;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:collectionView];
}

#pragma mark - AFBlipProfileCollectionViewDelegate
- (void)profileCollectionViewDidSelectEditProfile:(AFBlipProfileCollectionView *)profileCollectionView {
    
    if ([_delegate respondsToSelector:@selector(profileViewControllerDidSelectEditProfile:)]) {
        [_delegate profileViewControllerDidSelectEditProfile:self];
    }
}

- (void)profileCollectionViewDidSelectFeedback:(AFBlipProfileCollectionView *)profileCollectionView {
    
    UIColor *textColor                               = [UIColor afBlipNavigationBarElementColor];
    UIImage *backgroundImage                         = [UIImage imageNamed:@"AFBlipHeaderBackground"];
    NSDictionary *titleTextAttributes                = @{NSForegroundColorAttributeName : textColor, NSFontAttributeName : [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:4]};

    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    MFMailComposeViewController* mailController      = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate               = self;
    mailController.navigationBar.tintColor           = textColor;
    mailController.navigationBar.titleTextAttributes = titleTextAttributes;

    NSString *platformString = [NSString stringWithFormat:@"%@ %@", [AFPlatformUtility deviceModel], [AFPlatformUtility deviceOSVersion]];
    [mailController setSubject:NSLocalizedString(@"AFBlipFeedbackTitle", nil)];
    [mailController setToRecipients:@[NSLocalizedString(@"AFBlipFeedbackEmail", nil)]];
    [mailController setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"AFBlipFeedbackDefaultMessage", nil), [AFBlipUserModelSingleton sharedUserModel].userModel.displayName, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"], platformString]  isHTML:NO];
    
    [self presentViewController:mailController animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

- (void)profileCollectionViewDidSelectHelp:(AFBlipProfileCollectionView *)profileCollectionView {
    
    AFBlipFAQModal *faqModal = [[AFBlipFAQModal alloc] init];
    [self presentViewController:faqModal animated:YES completion:nil];
}

- (void)profileCollectionViewDidSelectLogout:(AFBlipProfileCollectionView *)profileCollectionView {
    
    NSString *title   = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
    NSString *message = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertMessage", nil);
    NSString *no      = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertNo", nil);
    NSString *yes     = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertYes", nil);
    
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[no, yes]];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:^{
                NSString *title   = NSLocalizedString(@"AFBlipFeedbackTitle", nil);
                NSString *message = NSLocalizedString(@"AFBlipFeedbackMessage", nil);
                NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);

                AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
                [alertView show];
            }];
            break;
        case MFMailComposeResultFailed: {
                NSString *title   = NSLocalizedString(@"AFBlipFeedbackTitle", nil);
                NSString *message = NSLocalizedString(@"AFBlipFeedbackFailureMessage", nil);
                NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
                
                AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
                [alertView show];
            break;
            }

    }
}

#pragma mark - AFBlipEditProfileDelegate
- (void)userProfileDidUpdateWithProfileImage:(NSData *)profileImage displayName:(NSString *)displayName {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (displayName) {
            [_profileImageView setDisplayName:displayName];
        }
        
        if (profileImage) {
            [_profileImageView updateProfileImageWithImageData:profileImage];
        }
    });
}

- (void)userDidDeactivateAccount {
    if ([_delegate respondsToSelector:@selector(profileViewControllerDidDeactivate:)]) {
        [_delegate profileViewControllerDidDeactivate:self];
    }
}

#pragma mark - AFFAlertViewDelegate
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    
    //YES
    if(buttonModel.index == 1) {
        if ([_delegate respondsToSelector:@selector(profileViewControllerDidSelectLogout:)]) {
            [_delegate profileViewControllerDidSelectLogout:self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dealloc
- (void)dealloc {
    _delegate = nil;
}

@end
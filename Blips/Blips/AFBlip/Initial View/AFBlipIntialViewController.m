//  AFBlipIntialViewController.m
//
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipAlertView.h"
#import "AFBlipIntialViewController.h"
#import "AFBlipInitialViewControllerBackgroundView.h"
#import "AFBlipInitialViewUserModel.h"
#import "AFBlipInitialViewControllerSignUpView.h"
#import "AFBlipInitialViewControllerSignUpViewContentView.h"
#import "AFBlipInitialViewControllerSignInView.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipKeychain.h"
#import "AFBlipTermsModal.h"
#import "AFFAlertViewButtonModel.h"
#import "UIImage+ImageEffects.h"

#pragma mark - Constants
static const NSInteger kAFBlipInitialViewController_ImageSize                = 100;

@interface AFBlipIntialViewController () <AFBlipInitialViewControllerBackgroundViewDelegate, AFBlipInitialViewControllerBaseDragViewDelegate, AFBlipInitialViewControllerSignInUpBaseViewDelegate, AFFAlertViewDelegate> {
    
    //Current view
    AFBlipInitialViewControllerBaseDragView     *_signInOrUpView;
    
    //Background
    AFBlipInitialViewControllerBackgroundView   *_backgroundView;
    UIImage                                     *_blurredImage;
    
    //Activity indicator
    AFBlipActivityIndicator                     *_activityIndicator;
}

@end

@implementation AFBlipIntialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background view
    _backgroundView                               = [[AFBlipInitialViewControllerBackgroundView alloc] initWithFrame:self.view.frame];
    _backgroundView.delegate                      = self;
    _backgroundView.autoresizingMask              = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view                                     = _backgroundView;

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!_blurredImage) {
        [self createBlurredImage];
    }
}

#pragma mark - AFBlipIntialViewControllerBackgroundViewDelegate
- (void)initialViewControllerBackgroundViewDidPressSignUp:(AFBlipInitialViewControllerBackgroundView *)initialViewControllerBackgroundView {
    
   
    if(_signInOrUpView)   {
        return;
    }
    
    _signInOrUpView                  = [[AFBlipInitialViewControllerSignUpView alloc] initWithFrame:self.view.frame blockerImage:_blurredImage];
    _signInOrUpView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _signInOrUpView.delegate         = self;
    [self.view addSubview:_signInOrUpView];

    [_signInOrUpView show];
    _backgroundView.enabledMotionEffects = NO;
}

- (void)initialViewControllerBackgroundViewDidPressSignIn:(AFBlipInitialViewControllerBackgroundView *)initialViewControllerBackgroundView {
    
    if(_signInOrUpView)   {
        return;
    }
    
    _signInOrUpView                  = [[AFBlipInitialViewControllerSignInView alloc] initWithFrame:self.view.frame blockerImage:_blurredImage];
    _signInOrUpView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _signInOrUpView.delegate         = self;
    [self.view addSubview:_signInOrUpView];

    [_signInOrUpView show];
    _backgroundView.enabledMotionEffects = NO;
}

#pragma mark - AFBlipInitialViewControllerBaseDragViewDelegate
- (void)initialViewControllerBaseDragViewDidTapBlocker:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView {
    
    UIView *contentView = initialViewControllerBaseDragView.draggableView.contentView;
    for(UIView *subView in contentView.subviews) {
        
        if(subView.isFirstResponder) {
            [subView resignFirstResponder];
        }
    }
    [initialViewControllerBaseDragView hide];
}

- (void)initialViewControllerSignInUpBaseViewDidPressHeaderForView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView {
    
    UIView *contentView = _signInOrUpView.draggableView.contentView;
    for(UIView *subView in contentView.subviews) {
        
        if(subView.isFirstResponder) {
            [subView resignFirstResponder];
        }
    }
    [_signInOrUpView hide];
}

- (void)initialViewControllerBaseDragViewWillHide:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView {

    _backgroundView.enabledMotionEffects = YES;
}

- (void)initialViewControllerBaseDragViewDidHide:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView {
    
    [initialViewControllerBaseDragView removeFromSuperview];
    initialViewControllerBaseDragView = nil;
    
    _signInOrUpView = nil;
}

- (void)initialViewControllerSignInUpBaseView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView didSelectSubmitButtonWithData:(AFBlipInitialViewUserModel *)data {
    
    [self showActivityIndicator:YES];

    //Sign in
    if(data.type == AFBlipInitialViewUserModelType_SignIn) {
        
        [self signIn:data];
        
    //Sign up
    } else {
    
        AFBlipInitialViewControllerSignUpViewContentView *contentView = (AFBlipInitialViewControllerSignUpViewContentView *)_signInOrUpView.draggableView;

        //Check if user name already exists
        AFBlipUserModelFactory *modelFactory = [[AFBlipUserModelFactory alloc] init];
        typeof(self) __weak weakSelf                 = self;
        
        //Check username
        [modelFactory checkIfUsernameIsAvailable:data.email success:^(AFBlipBaseNetworkModel *networkCallback) {
            
            //Check if the user has chosen a profile image. If not, then remind them to do so.
            if(contentView.userHasChosenAProfileImage) {
                [weakSelf signUp:data];
            } else {
                [weakSelf showSignUpProfileImageAlertView];
                [weakSelf showActivityIndicator:NO];
            }
            
        //Username taken
        } failure:^(NSError *error) {
            
            NSString *title   = NSLocalizedString(@"AFBlipSignupForFailureTitle", nil);
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"AFBlipSignupErrorUsernameTakenAppendage", nil), data.email];
            
            [weakSelf showActivityIndicator:NO];
            [weakSelf showErrorTitle:title errorMessage:message];
        }];
    }
}

- (void)initialViewControllerSignInUpBaseView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView didResetPasswordWithEmail:(NSString *)email {
    
    typeof(self) __weak weakSelf = self;
    
    AFBlipUserModelFactory *modelFactory = [[AFBlipUserModelFactory alloc] init];
    [modelFactory resetPasswordWithEmail:email success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        NSString *title = NSLocalizedString(@"AFBlipSignInResetPasswordAlertTitle", nil);
        NSString *message = NSLocalizedString(networkCallback.responseMessage, nil);
            
        [weakSelf showActivityIndicator:NO];
        [weakSelf showErrorTitle:title errorMessage:message];
        
    } failure:^(NSError *error) {
        
        NSString *title = NSLocalizedString(@"AFBlipSignInResetPasswordAlertTitle", nil);
        NSString *message = NSLocalizedString([error.localizedDescription capitalizedString], nil);
        
        [weakSelf showActivityIndicator:NO];
        [weakSelf showErrorTitle:title errorMessage:message];
    }];

}

- (void)showSignUpProfileImageAlertView {
    
    NSString *title   = NSLocalizedString(@"AFBlipSignupProfileImagePickerAlertTitle", nil);
    NSString *message = NSLocalizedString(@"AFBlipSignupProfileImagePickerAlertMessage", nil);
    NSString *yes     = NSLocalizedString(@"AFBlipSignupProfileImagePickerAlertYes", nil);
    NSString *no      = NSLocalizedString(@"AFBlipSignupProfileImagePickerAlertNo", nil);
    
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[no, yes]];
    alertView.delegate         = self;
    [alertView show];
}

#pragma mark - AFBlipAlertViewDelegate
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    
    //No
    if(buttonModel.index) {
        AFBlipInitialViewControllerSignUpViewContentView *contentView = (AFBlipInitialViewControllerSignUpViewContentView *)_signInOrUpView.draggableView;
        [contentView openImagePicker];
    //Yes
    } else {
        id data = (AFBlipInitialViewControllerSignUpViewContentView *)_signInOrUpView.draggableView->_model;
        [self signUp:data];
    }
}

- (void)initialViewControllerSignUpViewContentViewDidPressTerms:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView {
    
    AFBlipTermsModal *termsModal = [[AFBlipTermsModal alloc] init];
    [self presentViewController:termsModal animated:YES completion:nil];
}

#pragma mark - Sign in
- (void)signIn:(AFBlipInitialViewUserModel *)model {
    
    typeof(self) __weak weakSelf = self;

    AFBlipUserModelFactory *modelFactory = [[AFBlipUserModelFactory alloc] init];
    [modelFactory fetchUserModelAndAccessTokenWithUserName:model.email andPassword:model.password accessToken:model.accessToken success:^(AFBlipUserModel *userModel, NSString *accessToken, AFBlipBaseNetworkModel *networkCallback) {
        
        if (!networkCallback.success) {
            NSString *title = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
            NSString *message = NSLocalizedString(networkCallback.responseMessage, nil);
            
            [weakSelf showActivityIndicator:NO];
            [weakSelf showErrorTitle:title errorMessage:message];
            return;
        }
        
        [weakSelf showActivityIndicator:NO];

        if(_signInOrUpView) {
            [_signInOrUpView hide];
        }
        
        /*Saving user model*/
        [[AFBlipUserModelSingleton sharedUserModel] updateUserModelWithUserModel:userModel];

        [_delegate initialViewControllerDidLogin:weakSelf];
        
    } failure:^(NSError *error) {
        
        NSString *title = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
        NSString *message = NSLocalizedString([error.localizedDescription capitalizedString], nil);
        
        [weakSelf showActivityIndicator:NO];
        [weakSelf showErrorTitle:title errorMessage:message];
    }];
}

#pragma mark - Sign up
- (void)signUp:(AFBlipInitialViewUserModel *)model {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kAFBlipInitialViewController_ImageSize, kAFBlipInitialViewController_ImageSize), YES, 0);
    
    [model.profileImage drawInRect:CGRectMake(0, 0, kAFBlipInitialViewController_ImageSize, kAFBlipInitialViewController_ImageSize)];
    
    model.profileImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *profileImageData = UIImageJPEGRepresentation(model.profileImage, 1);

    __weak typeof(self) weakSelf = self;

    //Sign up
    AFBlipUserModelFactory *modelFactory = [[AFBlipUserModelFactory alloc] init];
    
    //Create user
    [modelFactory createUserWithUsername:model.email password:model.password displayName:model.name email:model.email profileImage:profileImageData success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        //User creation success
        if(networkCallback.success) {
            
            if(_signInOrUpView) {
                [_signInOrUpView hide];
            }
            
            //Login
            [weakSelf signIn:model];
            
        //User creation failure
        } else {
            [weakSelf showActivityIndicator:NO];
            NSString *title   = NSLocalizedString(@"AFBlipSignupForFailureTitle", nil);
            NSString *message = NSLocalizedString(networkCallback.responseMessage, nil);
            [weakSelf showErrorTitle:title errorMessage:message];
        }
    } failure:^(NSError *error) {
        
        NSString *title   = NSLocalizedString(@"AFBlipSignupForFailureTitle", nil);
        NSString *message = NSLocalizedString([error.localizedDescription capitalizedString], nil);
        
        if(!message) {
            message = [error.localizedDescription capitalizedString];
        }
        
        [weakSelf showActivityIndicator:NO];
        [weakSelf showErrorTitle:title errorMessage:message];
    }];
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.view.center;
        [_activityIndicator startAnimating];
    }
    
    [self.view addSubview:_activityIndicator];
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Error handling
- (void)showErrorTitle:(NSString *)errorTitle errorMessage:(NSString *)errorMessage {
    
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:errorTitle message:errorMessage buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
    [alertView show];
}

#pragma mark - Create preblurred background image
- (void)createBlurredImage {
    
    //Root view
    UIView *rootView                            = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    CGRect frame                                = CGRectIntegral(rootView.frame);
    
    UIImage *image                              = [self screenshotWithViewAndFrame:rootView frame:frame];
    
    __weak typeof(self) weakSelf                = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *blurredImage    = [weakSelf imageWithBlurredFrame:image frame:frame];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _blurredImage = blurredImage;
        });
    });
}

- (UIImage *)screenshotWithViewAndFrame:(UIView *)view frame:(CGRect)frame {
    
    UIGraphicsBeginImageContextWithOptions(frame.size, view.opaque, 0.0f);
    
    if([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [view drawViewHierarchyInRect:frame afterScreenUpdates:(view.superview) ? NO : YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithBlurredFrame:(UIImage *)image frame:(CGRect)frame {
    
    frame.size.height           = frame.size.height   * image.scale;
    frame.size.width            = frame.size.width    * image.scale;
    frame.origin.x              = frame.origin.x      * image.scale;
    frame.origin.y              = frame.origin.y      * image.scale;

    CGImageRef imageRef         = CGImageCreateWithImageInRect(image.CGImage, frame);

    UIImage *blurredCroppedArea = [[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:image.imageOrientation] applyBlurWithRadius:30.0f tintColor:[UIColor clearColor] saturationDeltaFactor:1.0f maskImage:nil];

    CGFloat scale               = 0.1f;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [blurredCroppedArea drawInRect:frame];
    
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    return blurredCroppedArea;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
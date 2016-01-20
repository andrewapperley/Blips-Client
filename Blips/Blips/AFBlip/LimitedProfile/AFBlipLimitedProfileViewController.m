//
//  AFBlipLimitedProfileViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipLimitedProfileViewController.h"
#import "AFBlipLimitedProfileView.h"
#import "AFBlipLimitedProfileViewContentView.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipAlertView.h"
#import "UIImage+ImageWithColor.h"

@interface AFBlipLimitedProfileViewController () <AFBlipInitialViewControllerSignInUpBaseViewDelegate, AFBlipInitialViewControllerBaseDragViewDelegate> {
    AFBlipLimitedProfileView* _profileView;
    NSString* _user;
    BOOL _toAdd;
}

@end

@implementation AFBlipLimitedProfileViewController

- (instancetype)initWithUser:(NSString *)user toAdd:(BOOL)toAdd {
    if (self = [super init]) {
        _user = user;
        _toAdd = toAdd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, self.view.frame.origin.y - CGRectGetHeight(self.navigationController.navigationBar.frame) - [UIApplication sharedApplication].statusBarFrame.size.height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame) + [UIApplication sharedApplication].statusBarFrame.size.height);
    
    AFBlipUserModelFactory* modelFactory = [[AFBlipUserModelFactory alloc] init];
    
    typeof(self) __weak wself = self;
    
    AFBlipUserModel *userModel       = [AFBlipUserModelSingleton sharedUserModel].userModel;

    [modelFactory fetchLimitedUserProfileForUser:_user userID:userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken success:^(AFBlipLimitedProfileModel *limitedProfileModel, AFBlipBaseNetworkModel *networkCallback) {
        
        if (!networkCallback.success) {
            AFBlipAlertView* alert = [[AFBlipAlertView alloc] initWithTitle:NSLocalizedString(@"AFBlipLimitedProfileAlertTitle", nil) message:networkCallback.responseMessage buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
            [alert show];
            return;
        }
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.4f]];
        
        _profileView = [[AFBlipLimitedProfileView alloc] initWithFrame:wself.view.frame blockerImage:image model:limitedProfileModel toAdd:_toAdd];
        _profileView.delegate = (id<AFBlipInitialViewControllerBaseDragViewDelegate>)wself;
        [wself.view addSubview:_profileView];
        [_profileView show];
    
    } failure:^(NSError *error) {
        AFBlipAlertView* alert = [[AFBlipAlertView alloc] initWithTitle:NSLocalizedString(@"AFBlipLimitedProfileAlertTitle", nil) message:[[error.localizedDescription capitalizedString] capitalizedString] buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
        [alert show];
    }];
}

- (void)initialViewControllerSignInUpBaseViewDidPressHeaderForView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView {
    [_profileView hide];
}

- (void)initialViewControllerBaseDragViewDidTapBlocker:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView {
    [_profileView hide];
}

- (void)initialViewControllerBaseDragViewDidHide:(AFBlipInitialViewControllerBaseDragView *)initialViewControllerBaseDragView {
    [_profileView removeFromSuperview];
    _profileView.delegate = nil;
    _profileView = nil;
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

@end
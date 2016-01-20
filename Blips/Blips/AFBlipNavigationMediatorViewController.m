//
//  AFBlipNavigationMediatorViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-06.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipAlertView.h"
#import "AFBlipFriendRequestBuilder.h"
#import "AFBlipIntialViewController.h"
#import "AFBlipNavigationMediatorViewController.h"
#import "AFBlipMainViewController.h"
#import "AFBlipOfflineViewController.h"
#import "AFBlipKeychain.h"
#import "AFBlipNotificationsModelFactory.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import <AFNetworkReachabilityManager.h>
#import "AFBlipReceiptsModelFactory.h"
#import "AFBlipStoreKitManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AFBlipNavigationMediatorViewController () <AFBlipMainViewControllerDelegate, AFBlipIntialViewControllerDelegate, AFBlipFriendRequestBuilderDelegate, AFBlipOfflineViewControllerDelegate> {
    
    AFBlipActivityIndicator *_activityIndicator;
    AFBlipStoreKitManager *_storekitManager;
    NSDictionary *_pendingNotificationData;
}

@end

@implementation AFBlipNavigationMediatorViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self startupSequence];
}

#pragma mark - Startup
- (void)startupSequence {
    
    [self showActivityIndicator:YES];

    [self setNavigationBarHidden:YES animated:NO];
    
    //Check for offline data connection
    if(![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showActivityIndicator:NO];
        [self displayOfflineViewController];
        return;
    }
    
    if([self checkForLoginInfo]) {
        
        typeof(self) __weak weakSelf = self;
        
        AFBlipKeychain *keychain = [AFBlipKeychain keychain];
        
        AFBlipUserModelFactory *userModelFactory = [[AFBlipUserModelFactory alloc] init];
        [userModelFactory fetchUserModelAndAccessTokenWithUserName:keychain.userName andPassword:@"" accessToken:keychain.accessToken success:^(AFBlipUserModel *userModel, NSString *accessToken, AFBlipBaseNetworkModel *networkCallback) {
            
            [weakSelf showActivityIndicator:NO];
            
            if (!networkCallback.success) {
                
                NSString *title   = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
                NSString *message = NSLocalizedString(networkCallback.responseMessage, nil);
                NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
                
                AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
                [alertView show];
                return;
            }
            
            //Unauthorized
            if(networkCallback.responseCode == 401) {
                
                NSString *title   = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
                NSString *message = NSLocalizedString(networkCallback.responseMessage, nil);
                NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
                
                AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
                [alertView show];

                [weakSelf displayInitialViewController];
                return;
            }
            
            [self createNotifications];
            [[AFBlipUserModelSingleton sharedUserModel] updateUserModelWithUserModel:userModel];
            if (!_storekitManager) {
                _storekitManager = [AFBlipStoreKitManager sharedInstance];
            }
            [self receiptsWithUser:userModel.user_id accessToken:accessToken];
            [weakSelf displayMainViewController];
            
        } failure:^(NSError *error) {
            
            [weakSelf showActivityIndicator:NO];

            NSString *title   = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
            NSString *message = NSLocalizedString([error.localizedDescription capitalizedString], nil);
            NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
            
            AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
            [alertView show];
            
            [weakSelf displayInitialViewController];
        }];
    } else {
        [self showActivityIndicator:NO];
        [self displayInitialViewController];
    }
}

- (void)receiptsWithUser:(NSString *)userID accessToken:(NSString *)accessToken {
    AFBlipReceiptsModelFactory *modelFactory = [[AFBlipReceiptsModelFactory alloc] init];
    [modelFactory receiveReceiptsForUserId:userID accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)displayInitialViewController {
    
    [self setNavigationBarHidden:YES animated:YES];

    AFBlipIntialViewController* viewController = [[AFBlipIntialViewController alloc] init];
    viewController.delegate                    = self;
    [self pushViewController:viewController animated:YES];
}

- (void)displayMainViewController {
    
    [self setNavigationBarHidden:NO animated:YES];
    [self registerNotifications];
    
    AFBlipMainViewController* viewController = [[AFBlipMainViewController alloc] init];
    viewController.delegate                  = self;
    [self pushViewController:viewController animated:YES];
}

- (void)displayOfflineViewController {
    
    AFBlipOfflineViewController *viewController = [[AFBlipOfflineViewController alloc] init];
    viewController.delegate                    = self;
    [self pushViewController:viewController animated:YES];
}

#pragma mark - AFBlipInitialViewDelegate
- (void)initialViewControllerDidLogin:(AFBlipIntialViewController *)initialViewController {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        initialViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [initialViewController removeFromParentViewController];
        [self displayMainViewController];
    }];
}

#pragma mark - AFBlipMainViewControllerDelegate
- (void)mainViewControllerDidLogout:(AFBlipMainViewController *)mainViewController {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"blipsUserReceipts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self displayInitialViewController];
    [mainViewController removeFromParentViewController];
    mainViewController = nil;
}

#pragma mark - AFBlipOfflineViewControllerDelegate
- (void)offlineViewControllerDidReconnect:(AFBlipOfflineViewController *)offlineViewController {
        
    [UIView animateWithDuration:0.3f animations:^{
        
        offlineViewController.view.alpha = 0;
    } completion:^(BOOL finished) {

        [offlineViewController removeFromParentViewController];
        [self startupSequence];
    }];
}

#pragma mark - Access Token Checks
- (BOOL)checkForLoginInfo {
    
    return [[AFBlipKeychain keychain] accessTokenValid];
}

#pragma mark - Notification Creation
- (void)createNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotifications) name:kAFBlipsUserNotificationNotificationRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisterForNotifications) name:kAFBlipsUserNotificationNotificationUnRegister object:nil];
}

#pragma mark - Push notification handling
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
}

- (void)registerForNotificationsWithUniqueToken:(NSString *)uniqueToken {
    
    NSString *userId      = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken = [AFBlipKeychain keychain].accessToken;
    
    AFBlipNotificationsModelFactory* ds = [[AFBlipNotificationsModelFactory alloc] init];
    [ds registerForNotificationsWithUniqueToken:uniqueToken userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        [[NSUserDefaults standardUserDefaults] setBool:networkCallback.success forKey:kAFBlipsUserNotificationPreferenceToggle];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error) {
        
    }];
}

- (void)unregisterForNotifications {
    
    NSString *userId      = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken = [AFBlipKeychain keychain].accessToken;
    
    typeof(self) wself = self;
    
    AFBlipNotificationsModelFactory* ds = [[AFBlipNotificationsModelFactory alloc] init];
    [ds unregisterForNotificationsWithUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        [wself unregisterNotifications];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setPendingNotificationData:(NSDictionary *)data {
    _pendingNotificationData = [data copy];
}

- (void)displayPendingPushNotification {
    [self displayPushNotification:_pendingNotificationData state:UIApplicationStateInactive];
    _pendingNotificationData = nil;
}

- (void)displayPushNotification:(NSDictionary *)pushNotification state:(UIApplicationState)state {
 
    AFBlipMainViewController *mainViewController = (AFBlipMainViewController *)[self topViewController];
    if(![mainViewController isKindOfClass:[AFBlipMainViewController class]]) {
        return;
    }
    [mainViewController updateNotificationListCount];
    
    if(!pushNotification) {
        return;
    }
    
    /* Vibrate phone or make an ipod ding */
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    else {
        AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
    }
    
    if(state == UIApplicationStateActive) {
        return;
    }
    
    NSNumber *pushNotificationTypeNumber = pushNotification[@"NotificationType"];
    if(!pushNotificationTypeNumber) {
        return;
    }
        
    AFBlipFriendRequestModalType notificationType    = [pushNotificationTypeNumber unsignedIntegerValue];
    AFBlipFriendRequestBuilder *friendRequestBuilder = [[AFBlipFriendRequestBuilder alloc] init];
    friendRequestBuilder.delegate = self;
    [friendRequestBuilder displayRequestType:notificationType data:pushNotification];
}

#pragma mark - AFBlipFriendRequestBuilderDelegate
- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didAcceptFriendInvitation:(BOOL)didAcceptFriendInvitation {

    AFBlipMainViewController *mainViewController = (AFBlipMainViewController *)[self topViewController];
    if(![mainViewController isKindOfClass:[AFBlipMainViewController class]]) {
        return;
    }
    
    [mainViewController updateNotificationListCount];
}

- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didSelectCreateVideoWithUser:(AFBlipUserModel *)friendModel timelineId:(NSString *)timelindId {
    
    AFBlipMainViewController *mainViewController = (AFBlipMainViewController *)[self topViewController];
    if(![mainViewController isKindOfClass:[AFBlipMainViewController class]]) {
        return;
    }
    
    NSString *userId      = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken = [AFBlipKeychain keychain].accessToken;
    typeof(mainViewController) __weak weakMainViewController = mainViewController;
    
    AFBlipNotificationsModelFactory *factory = [[AFBlipNotificationsModelFactory alloc] init];
    [factory markNotificationAsReadForNotificationUserId:friendModel.user_id userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        [weakMainViewController updateNotificationListCount];
    } failure:^(NSError *error) {
        
    }];
    
    AFBlipVideoTimelineModel *timelimeModel = [[AFBlipVideoTimelineModel alloc] init];
    timelimeModel.timelineIds = @[timelindId];
    timelimeModel.timelineUserId = friendModel.user_id;
    timelimeModel.timelineTitle = friendModel.displayName;
    timelimeModel.timelineDescription = friendModel.displayName;
    timelimeModel.timelineFriendImageURLString = friendModel.userImageUrl;
    [mainViewController openVideoCreationScreenWithVideoTimelineModel:timelimeModel];
}

- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didSelectViewVideoWithTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    AFBlipMainViewController __weak *mainViewController = (AFBlipMainViewController *)[self topViewController];
    if(![mainViewController isKindOfClass:[AFBlipMainViewController class]]) {
        return;
    }
    
    [mainViewController updateNotificationListCount];
    [mainViewController openVideoViewingScreenWithVideo:[timelineModel.videos firstObject] videoTimelineModel:timelineModel];
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    
    _activityIndicator.center           = self.view.center;
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - Cleanup
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
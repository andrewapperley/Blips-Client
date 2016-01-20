//
//  AFBlipMainViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-06.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFBlipConnectionModel.h"
#import "AFBlipConnectionModelFactory.h"
#import "AFBlipConnectionsViewController.h"
#import "AFBlipEditProfileViewController.h"
#import "AFBlipFriendRequestModal.h"
#import "AFBlipMainViewController.h"
#import "AFBlipNotificationBadge.h"
#import "AFBlipNotificationsDatasource.h"
#import "AFBlipProfileViewController.h"
#import "AFBlipProfileViewControllerStatics.h"
#import "AFBlipLimitedProfileViewController.h"
#import "AFBlipNavigationMediator.h"
#import "AFBlipNotificationsModelFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipTimeline.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipVideoViewControllerMediator.h"
#import "AFDynamicFontMediator.h"
#import "AFBlipAppDelegate.h"
#import "AFBlipNavigationMediatorViewController.h"

#import "UIImage+ImageWithColor.h"

const CGFloat kAFBlipMainViewController_badgePaddingTop   = 16.0f;
const CGFloat kAFBlipMainViewController_badgePaddingRight = - 5.0f;

@interface AFBlipMainViewController () <AFBlipNavigationMediatorDelegate, AFBlipProfileViewControllerDelegate, AFBlipConnectionsViewControllerDelegate, AFBlipFriendRequestModalDelegate, AFDynamicFontMediatorDelegate, AFBlipTimelineDelegate, AFBlipVideoViewControllerMediatorDelegate> {
    
    //View controllers
    AFBlipProfileViewController     *_settingsMenuViewController;
    AFBlipTimeline                  *_timelineViewController;
    AFBlipConnectionsViewController *_connectionsViewController;
    
    //View controller mediator
    AFBlipNavigationMediator        *_navigationMediator;
    
    //Notification badge
    AFBlipNotificationBadge         *_notificationBadge;
    
    //Font
    AFDynamicFontMediator           *_dynamicFont;
}

@end

@implementation AFBlipMainViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self createDynamicFont];
    [self setupTimelineViewController];
    [self createNotificationBadge];
    [self updateNotificationListCount];
    [self showPendingNotifications];
    [self loadRecentTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation bar setup
- (void)setupNavigationBar {
    
    UIImage *backgroundImage                                    = [UIImage imageNamed:@"AFBlipHeaderBackground"];
    UIColor *textColor                                          = [UIColor afBlipNavigationBarElementColor];
    self.navigationController.navigationBarHidden               = NO;
    self.navigationController.navigationBar.translucent         = NO;
    self.navigationController.navigationBar.shadowImage         = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem* leftMenuItem                               = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFBlipSettingsMenuButton"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(settingsMenuSelected)];
    UIBarButtonItem* rightMenuItem                              = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFBlipConnectionsButtonSmall"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(connectionsMenuSelected)];

    leftMenuItem.tintColor                                      = textColor;
    rightMenuItem.tintColor                                     = textColor;

    [self.navigationItem setLeftBarButtonItem:leftMenuItem animated:NO];
    [self.navigationItem setRightBarButtonItem:rightMenuItem animated:NO];

    self.title = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    UIColor *textColor                                          = [UIColor afBlipNavigationBarElementColor];

    NSDictionary *titleTextAttributes                           = @{NSForegroundColorAttributeName : textColor, NSFontAttributeName : [UIFont fontWithType:AFBlipFontType_Title sizeOffset:7]};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
}

#pragma mark - Timeline view controller
- (void)setupTimelineViewController {
        
    _timelineViewController          = [[AFBlipTimeline alloc] init];
    _timelineViewController.delegate = self;
    [self.view insertSubview:_timelineViewController.view atIndex:0];
    [self addChildViewController:_timelineViewController];
    [_timelineViewController didMoveToParentViewController:self];
}

#pragma mark - Notification badge
- (void)createNotificationBadge {

    CGSize size = [AFBlipNotificationBadge preferredSize];
    _notificationBadge = [[AFBlipNotificationBadge alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - size.width + kAFBlipMainViewController_badgePaddingRight, kAFBlipMainViewController_badgePaddingTop, size.width, size.height)];
    
    [self.navigationController.navigationBar addSubview:_notificationBadge];
}

- (void)updateNotificationListCount {

    NSString *userId                              = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken                         = [AFBlipKeychain keychain].accessToken;
    typeof(self) __weak weakSelf                  = self;
    
    AFBlipNotificationsModelFactory* modelFactory = [[AFBlipNotificationsModelFactory alloc] init];
    [modelFactory notificationCountForUserId:userId accessToken:accessToken success:^(NSUInteger notificationCount, AFBlipBaseNetworkModel *networkCallback) {
        [weakSelf updateNotificationBadgeCount:notificationCount];
    } failure:nil];
}

- (void)updateNotificationBadgeCount:(NSUInteger)badgeCount {
    
    [_notificationBadge updateBadgeCount:badgeCount badgeType:AFBlipNotificationBadgeType_Mirrored animated:YES];
}

- (void)markNotificationAsReadForUserModel:(AFBlipUserModel *)userModel {
 
    NSString *userId                              = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *notificationUserId                  = userModel.user_id;
    NSString *accessToken                         = [AFBlipKeychain keychain].accessToken;
    typeof(self) __weak weakSelf                  = self;
    
    AFBlipNotificationsModelFactory* modelFactory = [[AFBlipNotificationsModelFactory alloc] init];
    [modelFactory markNotificationAsReadForNotificationUserId:notificationUserId userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        [weakSelf updateNotificationListCount];
    } failure:^(NSError *error) {
    }];
}

- (void)showPendingNotifications {
    AFBlipAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController displayPendingPushNotification];
}

#pragma mark - Load recent timeline
- (void)loadRecentTimeline {
    
    NSString *userId        = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken   = [AFBlipKeychain keychain].accessToken;
    
    typeof(_timelineViewController) __weak weakTimelineViewController = _timelineViewController;
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory fetchAllTimelinesForUserId:userId accessToken:accessToken success:^(NSArray *timelineList, AFBlipBaseNetworkModel *networkCallback) {

        //Create timeline model
        AFBlipVideoTimelineModel *timelineModel = [[AFBlipVideoTimelineModel alloc] init];
        timelineModel.type                      = AFBlipVideoTimelineModelType_All_Recent;
        timelineModel.timelineIds               = timelineList;
        [weakTimelineViewController setNewTimelineModel:timelineModel];

    } failure:^(NSError *error) {
        
        NSString *title   = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
        NSString *message = NSLocalizedString(@"AFBlipTimelineErrorUnableToLoadTimeline", nil);
        NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);

        AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
        [alertView show];
    }];
}

#pragma mark - Load favourites
- (void)loadFavouritesTimeline {
    
    //Create timeline model
    AFBlipVideoTimelineModel *timelineModel = [[AFBlipVideoTimelineModel alloc] init];
    timelineModel.type                      = AFBlipVideoTimelineModelType_Favourites;
    [_timelineViewController setNewTimelineModel:timelineModel];
}

#pragma mark - Load connection timeline with timeline id
- (void)loadTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    timelineModel.type = AFBlipVideoTimelineModelType_Recent;
    [_timelineViewController setNewTimelineModel:timelineModel];
}

#pragma mark - AFBlipTimelineDelegate
    
- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectConnectionProfile:(AFBlipVideoModel *)videoModel {
    AFBlipConnectionModelFactory *modelFactory = [[AFBlipConnectionModelFactory alloc] init];
    [modelFactory connectionWithTimelineID:videoModel.timelineId success:^(AFBlipBaseNetworkModel *networkCallback, AFBlipConnectionModel *connectionModel) {
        if (connectionModel) {
            [self didSelectConnectionsProfileForConnection:connectionModel fromController:nil];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)timelineCanvasDidRemoveFriend:(AFBlipTimeline *)timeline {
    
    [self loadRecentTimeline];
}

- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    [self openVideoViewingScreenWithVideo:videoModel videoTimelineModel:videoTimelineModel];
}

- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectNewVideoWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    [self openVideoCreationScreenWithVideoTimelineModel:videoTimelineModel];
}

#pragma mark - Navigation Bar Menu Methods
#pragma mark - Settings menu
- (void)settingsMenuSelected {
    
    //Create settings
    if(!_settingsMenuViewController) {
        
        CGRect settingsMenuFrame             = CGRectMake(kAFBlipProfileViewControllerStatics_ProfileViewClosedPosX, 0, kAFBlipProfileViewControllerStatics_ProfileViewWidth, CGRectGetHeight(self.view.frame));
        
        _settingsMenuViewController          = [[AFBlipProfileViewController alloc] initWithViewFrame:settingsMenuFrame];
        _settingsMenuViewController.delegate = self;
    }
    
    //Navigate to timeline
    if(_settingsMenuViewController.isOpen) {
        
        _settingsMenuViewController.isOpen = NO;

        AFBlipNavigationMediator *navigationMediator = [self navigationMediator];
        [navigationMediator navigateToTimelineViewController:_timelineViewController fromSettingsViewController:_settingsMenuViewController navigationBar:self.navigationController.navigationBar completion:^{
            _settingsMenuViewController = nil;
        }];
        
    //Navigate to settings
    } else {
        
        _settingsMenuViewController.isOpen = YES;

        AFBlipNavigationMediator *navigationMediator = [self navigationMediator];
        [navigationMediator navigateToSettingsViewController:_settingsMenuViewController fromTimelineViewController:_timelineViewController navigationBar:self.navigationController.navigationBar completion:nil];
    }
}

#pragma mark - Connections
- (void)connectionsMenuSelected {
    
    //Create connections
    if(!_connectionsViewController) {
        
        CGRect connectionsMenuFrame          = CGRectMake(CGRectGetWidth(_timelineViewController.view.frame) +  kAFBlipConnectionsViewControllerStatics_ConnectionsViewClosedPosX, 0, kAFBlipConnectionsViewControllerStatics_ConnectionsViewWidth, CGRectGetHeight(self.view.frame));
        
        _connectionsViewController          = [[AFBlipConnectionsViewController alloc] initWithViewFrame:connectionsMenuFrame];
        _connectionsViewController.delegate = self;
    }
    
    //Navigate to timeline
    if(_connectionsViewController.isOpen) {
        
        _connectionsViewController.isOpen = NO;
        
        AFBlipNavigationMediator *navigationMediator = [self navigationMediator];
        [navigationMediator navigateToTimelineViewController:_timelineViewController fromConnectionsViewController:_connectionsViewController navigationBar:self.navigationController.navigationBar completion:^{
            _connectionsViewController = nil;
        }];
    //Navigate to connections
    } else {
        
        _connectionsViewController.isOpen = YES;

        AFBlipNavigationMediator *navigationMediator = [self navigationMediator];
        [navigationMediator navigateToConnectionsViewController:_connectionsViewController fromTimelineViewController:_timelineViewController navigationBar:self.navigationController.navigationBar completion:nil];
    }
}

#pragma mark - AFBlipVideoViewControllerMediatorDelegate
- (void)videoViewControllerMediatorRequiresTimelineReload:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator {
    
    [_timelineViewController reloadData];
}

- (void)videoViewControllerMediatorRequiresTimelineDelete:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator videoModel:(AFBlipVideoModel *)model {
    
    [_timelineViewController deleteVideoModel:model];
}

- (void)videoViewControllerMediatorRequiresCellReloadForModel:(AFBlipVideoModel *)model mediator:(AFBlipVideoViewControllerMediator *)videoViewControllerMediator {
    
    [_timelineViewController reloadTimelineCellWithModel:model];
}

#pragma mark - AFBlipProfileViewControllerDelegate
- (void)profileViewControllerDidSelectLogout:(AFBlipProfileViewController *)profileViewController {
    
    //Unregister notifications
    [self unregisterForNotifications];
    
    //Logout
    AFBlipKeychain *keyChain        = [AFBlipKeychain keychain];

    AFBlipUserModelFactory *factory = [[AFBlipUserModelFactory alloc] init];
    NSString *userId                = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    typeof(self) __weak weakSelf    = self;
    [factory fetchLogoutUserWithUserId:userId accessToken:keyChain.accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
       
        /*Reset all credentials and move user to login screen*/
        [weakSelf resetUserAndNavigateToInitialScreen:profileViewController];
       
    } failure:^(NSError *error) {
        
        NSString *title   = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
        NSString *message = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertMessageFailure", nil);
        NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
        
        AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
        [alertView show];
    }];
}

- (void)profileViewControllerDidDeactivate:(AFBlipProfileViewController *)profileViewController {
    [self resetUserAndNavigateToInitialScreen:profileViewController];
}

- (void)resetUserAndNavigateToInitialScreen:(AFBlipProfileViewController *)profileViewController {
    
    AFBlipUserModelSingleton *userModelSingleton = [AFBlipUserModelSingleton sharedUserModel];
    AFBlipKeychain *keyChain                     = [AFBlipKeychain keychain];
    
    //Reset keychain
    [userModelSingleton resetUserModel];
    [keyChain resetKeychain];
    
    //Navigate to timeline
    AFBlipNavigationMediator *navigationMediator = [self navigationMediator];
    [navigationMediator navigateToTimelineViewController:_timelineViewController fromSettingsViewController:profileViewController navigationBar:self.navigationController.navigationBar completion:^{
        
        //Remove settings view controller
        [_settingsMenuViewController removeFromParentViewController];
        _settingsMenuViewController = nil;
        _navigationMediator         = nil;
        
        //Logout
        [_delegate mainViewControllerDidLogout:self];
    }];
}

- (void)unregisterForNotifications {
    
    NSString *userId      = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken = [AFBlipKeychain keychain].accessToken;
    
    AFBlipNotificationsDatasource* ds = [[AFBlipNotificationsDatasource alloc] init];
    [ds unregisterForNotificationsWithUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Edit Profile View Opening
- (void)profileViewControllerDidSelectEditProfile:(AFBlipProfileViewController *)profileViewController {
    
    AFBlipEditProfileViewController* editProfileController = [[AFBlipEditProfileViewController alloc] initWithToolbarWithTitle:NSLocalizedString(@"AFBlipEditProfileTitle", nil) leftButton:NSLocalizedString(@"AFBlipEditProfileCancelButtonTitle", nil) rightButton:nil];
    editProfileController.delegate = (id)_settingsMenuViewController;

    editProfileController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:editProfileController animated:YES completion:nil];

}

#pragma mark - AFBlipConnectionsViewControllerDelegate
- (void)didSelectPersonalTimelineForSection:(kAFBlipConnectionsPersonalSection)section fromController:(AFBlipConnectionsViewController *__weak)controller {
    
    switch(section) {
        case kAFBlipConnectionsPersonalSection_Recent:
            [self loadRecentTimeline];
            break;
        case kAFBlipConnectionsPersonalSection_Favourites:
            [self loadFavouritesTimeline];
            break;
        default:
            break;
    }
    [self connectionsMenuSelected];
}

- (void)didSelectLimitedProfileForUser:(AFBlipUserModel *)user toAdd:(BOOL)toAdd fromController:(AFBlipConnectionsViewController *__weak)controller {
    
    AFBlipLimitedProfileViewController* limitedProfileVC = [[AFBlipLimitedProfileViewController alloc] initWithUser:user.user_id toAdd:toAdd];
    [self addChildViewController:limitedProfileVC];
    [self.view addSubview:limitedProfileVC.view];
    [limitedProfileVC didMoveToParentViewController:self];
}

- (void)didSelectConnectionsProfileForConnection:(AFBlipConnectionModel *)connection fromController:(AFBlipConnectionsViewController *__weak)controller {

    NSString *connectionDisplayName = connection.connectionFriend.displayName;
    
    //Timeline model
    AFBlipVideoTimelineModel *timelineModel = [[AFBlipVideoTimelineModel alloc] init];
    timelineModel.timelineConnectionId      = connection.connectionId;
    timelineModel.timelineTitle             = connectionDisplayName;
    timelineModel.timelineIds               = @[connection.timelineId];
    timelineModel.timelineUserId            = connection.connectionFriend.user_id;
    
    //Display timeline
    [self loadTimelineModel:timelineModel];
    if (controller) {
        [self connectionsMenuSelected];
    }

    //Mark notification as read
    [self markNotificationAsReadForUserModel:connection.connectionFriend];
}

- (void)didSelectConnectionsFriendRequest:(AFBlipConnectionModel *)connection fromController:(AFBlipConnectionsViewController *__weak)controller {
    
    //Display friend request modal
    [self displayFriendRequestModal:connection];
}

#pragma mark - Friend request modal
- (void)displayFriendRequestModal:(AFBlipConnectionModel *)connectionModel {
    
    AFBlipUserModel *userModel       = connectionModel.connectionFriend;
    
    AFBlipFriendRequestModal *modal  = [[AFBlipFriendRequestModal alloc] initWithType:AFBlipFriendRequestModalType_FriendRequest displayName:userModel.displayName imageURLString:userModel.userImageUrl data:connectionModel];
    modal.friendRequestModalDelegate = self;
    [modal show];
}

#pragma mark - AFBlipFriendRequestModalDelegate
- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didAcceptFriendInvitation:(BOOL)didAcceptFriendInvitation {
    
    //Mark notification as read
    AFBlipConnectionModel *connectionModel                                  = friendRequestModal.data;
    NSString *accessToken                                                   = [AFBlipKeychain keychain].accessToken;
    NSString *userId                                                        = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;

    typeof(self) __weak weakSelf                                            = self;
    typeof(_connectionsViewController) __weak weakConnectionsViewController = _connectionsViewController;
    
    AFBlipConnectionModelFactory *factory = [[AFBlipConnectionModelFactory alloc] init];
    [factory changeConnectionStatusWithUserID:userId connectionID:connectionModel.connectionId status:didAcceptFriendInvitation accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {

        if(weakConnectionsViewController) {
            [weakConnectionsViewController reloadData];
        }
        [weakSelf markNotificationAsReadForUserModel:connectionModel.connectionFriend];

    } failure:^(NSError *error) {

    }];
}

#pragma mark - Video handling
- (void)openVideoCreationScreenWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {

    if(!videoTimelineModel) {
        return;
    }
    
    AFBlipVideoViewControllerMediator *videoViewController = [[AFBlipVideoViewControllerMediator alloc] initWithVideoTimelineModel:videoTimelineModel initialState:AFBlipVideoViewControllerMediatorState_Capture viewVideoModel:nil];
    videoViewController.delegate                           = self;
    [self presentViewController:videoViewController animated:YES completion:nil];
}

- (void)openVideoViewingScreenWithVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    if(!videoModel) {
        return;
    }
    
    AFBlipVideoViewControllerMediator *videoViewController = [[AFBlipVideoViewControllerMediator alloc] initWithVideoTimelineModel:videoTimelineModel initialState:AFBlipVideoViewControllerMediatorState_ViewVideo viewVideoModel:videoModel];
    videoViewController.delegate                           = self;
    [self presentViewController:videoViewController animated:YES completion:nil];
}

#pragma mark - View controller navigation mediator
- (AFBlipNavigationMediator *)navigationMediator {
    
    if(!_navigationMediator) {
        _navigationMediator          = [[AFBlipNavigationMediator alloc] init];
        _navigationMediator.delegate = self;
    }
    
    return _navigationMediator;
}

#pragma mark - AFBlipNavigationMediatorDelegate
- (void)navigationMediatorDidTapBlockedViewFromMediator:(AFBlipNavigationMediator *)navigationMediator {
    
    //Tapped from settings
    if(_settingsMenuViewController) {
        
        [navigationMediator navigateToTimelineViewController:_timelineViewController fromSettingsViewController:_settingsMenuViewController navigationBar:self.navigationController.navigationBar completion:^{
            
            [_settingsMenuViewController removeFromParentViewController];
            _settingsMenuViewController = nil;
            _navigationMediator         = nil;
        }];
        
    //Tapped from connections
    } else if(_connectionsViewController){
        
        [navigationMediator navigateToTimelineViewController:_timelineViewController fromConnectionsViewController:_connectionsViewController navigationBar:self.navigationController.navigationBar completion:^{
            
            [_connectionsViewController removeFromParentViewController];
            _connectionsViewController  = nil;
            _navigationMediator         = nil;
        }];
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
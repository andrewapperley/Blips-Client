//
//  AFBlipAppDelegate.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-05.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAppDelegate.h"
#import "AFBlipNavigationMediatorViewController.h"
#import "AFBlipNotificationsModelFactory.h"
#import "AFBlipAmazonS3Statics.h"
#import "AWSCore.h"

const CGFloat kAFBlipAppDelegate_MotionEffectsAmountX = 100.0f;
const CGFloat kAFBlipAppDelegate_MotionEffectsAmountY = 50.0f;

@implementation AFBlipAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.navigationController       = [[AFBlipNavigationMediatorViewController alloc] init];
    self.window                     = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [self setupBackgroundView];

    AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithAccessKey:kAFBlipAWSAccessKey secretKey:kAFBlipAWSSecretKey];
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    /** Launch from push notification payload if application was not started when we got the push */
    NSDictionary *pushNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (pushNotificationUserInfo) {
        [self.navigationController setPendingNotificationData:pushNotificationUserInfo];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    return YES;
}

- (void)setupBackgroundView {
    
    UIView *parentView = self.window.rootViewController.view;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Create background
    UIImageView *appBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipBlurredBackgroundPurple"]];
    appBackgroundImage.frame = CGRectMake(0, 0, appBackgroundImage.frame.size.width + (kAFBlipAppDelegate_MotionEffectsAmountX * 2), appBackgroundImage.frame.size.height + (kAFBlipAppDelegate_MotionEffectsAmountY * 2));
    appBackgroundImage.center = parentView.center;
    [parentView insertSubview:appBackgroundImage atIndex:0];

    //Create motion effects for background
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - kAFBlipAppDelegate_MotionEffectsAmountX);
    motionEffectHorizontal.maximumRelativeValue         = @( kAFBlipAppDelegate_MotionEffectsAmountX);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - kAFBlipAppDelegate_MotionEffectsAmountY);
    motionEffectVertical.maximumRelativeValue           = @( kAFBlipAppDelegate_MotionEffectsAmountY);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    [appBackgroundImage addMotionEffect:motionEffectGroup];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self application:application didReceiveRemoteNotification:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/** Push Notifications */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    [_navigationController registerForNotificationsWithUniqueToken:hexToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [_navigationController displayPushNotification:userInfo state:application.applicationState];
}

@end

//
//  AFBlipOfflineViewControllerView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-31.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipOfflineViewControllerView.h"
#import "AFDynamicFontMediator.h"

#pragma mark - Constants
//Header
const CGFloat kAFBlipOfflineViewControllerView_LogoY                  = 53.0f;
const CGFloat kAFBlipOfflineViewControllerView_HorizontalPaddingLabel = 10.0f;

//Offline label
const CGFloat kAFBlipOfflineViewControllerView_OfflineLabelHeight     = 55.0f;

@interface AFBlipOfflineViewControllerView () <AFDynamicFontMediatorDelegate> {
    
    UILabel                 *_logoLabel;
    UILabel                 *_offlineLabel;
    AFDynamicFontMediator   *_dynamicFontObserver;
}

@end

@implementation AFBlipOfflineViewControllerView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self createLogoLabel];
        [self createOfflineLabel];
        [self createDynamicFont];
    }
    return self;
}

- (void)createLogoLabel {
    
    //Logo
    _logoLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipOfflineViewControllerView_LogoY, CGRectGetWidth(self.bounds), 0)];
    _logoLabel.textColor        = [UIColor whiteColor];
    _logoLabel.textAlignment    = NSTextAlignmentCenter;
    _logoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _logoLabel.text             = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
    _logoLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:37];
    [_logoLabel sizeToFit];
    
    CGRect frame     = _logoLabel.frame;
    frame.size.width = CGRectGetWidth(self.bounds);
    _logoLabel.frame = frame;
    [self addSubview:_logoLabel];
}

- (void)createOfflineLabel {
    
    CGFloat frameY                  = self.center.y - (kAFBlipOfflineViewControllerView_OfflineLabelHeight / 2);
    CGRect frame                    = CGRectMake(kAFBlipOfflineViewControllerView_HorizontalPaddingLabel, frameY, CGRectGetWidth(self.bounds) - (kAFBlipOfflineViewControllerView_HorizontalPaddingLabel * 2), kAFBlipOfflineViewControllerView_OfflineLabelHeight);
    
    _offlineLabel               = [[UILabel alloc] initWithFrame:frame];
    _offlineLabel.numberOfLines = 0;
    _offlineLabel.textAlignment = NSTextAlignmentCenter;
    _offlineLabel.textColor     = [UIColor whiteColor];
    _offlineLabel.text          = NSLocalizedString(@"AFBlipOfflineLaunchErrorMessage", nil);
    [self addSubview:_offlineLabel];
}

- (void)createDynamicFont {
    
    _dynamicFontObserver          = [[AFDynamicFontMediator alloc] init];
    _dynamicFontObserver.delegate = self;
    [_dynamicFontObserver updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {

    //Offline label
    _offlineLabel.font           = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1.5f];
}

@end
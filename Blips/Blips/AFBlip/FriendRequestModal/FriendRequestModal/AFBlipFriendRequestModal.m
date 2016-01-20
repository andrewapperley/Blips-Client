//
//  AFBlipFriendRequestModal.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFFAlertViewButtonModel.h"
#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipFriendRequestModal.h"
#import "AFDynamicFontMediator.h"
#import "UIImageView+AFBlipImageView.h"

#pragma mark - Constants
//Profile image view
const CGFloat kAFBlipFriendRequestModal_profileImageSize        = 80.0f;
const CGFloat kAFBlipFriendRequestModal_profileImageBorderWidth = 2.0f;
const CGFloat kAFBlipFriendRequestModal_profileImagePosY        = 40.0f;

//Title
const CGFloat kAFBlipFriendRequestModal_titlePaddingY           = 10.0f;

//Height
const CGFloat kAFBlipFriendRequestModal_height                  = 210.0f;

@interface AFBlipFriendRequestModal () <AFFAlertViewDelegate, AFDynamicFontMediatorDelegate> {
    
    AFBlipFriendRequestModalType _type;
    AFDynamicFontMediator        *_dynamicFont;
    
    UILabel *_titleLabel;
    UILabel *_displayNameLabel;
}

@end

@implementation AFBlipFriendRequestModal

#pragma mark - Init
- (instancetype)initWithType:(AFBlipFriendRequestModalType)type displayName:(NSString *)displayName imageURLString:(NSString *)imageURLString data:(id)data {
    
    self = [super initWithTitle:nil message:nil buttonTitles:[AFBlipFriendRequestModal buttonTitlesForType:type]];
    if(self) {
        
        _data = data;
        _type = type;
        self.delegate = self;
        [self createTitle];
        [self createProfileImage:imageURLString];
        [self createDisplayName:displayName];
        [self createDynamicFont];
    }
    return self;
}

- (void)createTitle {
    
    NSString *titleString       = [self titleForType:_type];

    _titleLabel                 = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor       = [UIColor whiteColor];
    _titleLabel.text            = titleString;

    [self addSubview:_titleLabel];
}

- (void)createProfileImage:(NSString *)profileImageURLString {
    
    //Image
    CGFloat posX = (CGRectGetWidth(self.bounds) - kAFBlipFriendRequestModal_profileImageSize) / 2;
    UIImageView __block *profileImageView         = [[UIImageView alloc] initWithFrame:CGRectMake(posX, kAFBlipFriendRequestModal_profileImagePosY, kAFBlipFriendRequestModal_profileImageSize, kAFBlipFriendRequestModal_profileImageSize)];
    profileImageView.contentMode                  = UIViewContentModeCenter;
    profileImageView.backgroundColor              = [UIColor clearColor];
    [self addSubview:profileImageView];

    //Border and corner radius
    profileImageView.layer.borderWidth            = kAFBlipFriendRequestModal_profileImageBorderWidth;
    profileImageView.layer.borderColor            = [UIColor whiteColor].CGColor;
    profileImageView.layer.allowsEdgeAntialiasing = YES;
    profileImageView.layer.rasterizationScale     = [UIScreen mainScreen].scale;
    profileImageView.layer.shouldRasterize        = YES;
    profileImageView.layer.cornerRadius           = afRound(CGRectGetWidth(profileImageView.frame) * 0.5f);
    profileImageView.layer.masksToBounds          = YES;
    profileImageView.layer.drawsAsynchronously    = YES;
    
    //Load image
    AFBlipAWSS3AbstractFactory *factory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    [factory objectForKey:profileImageURLString completion:^(NSData *data) {
        UIImage *image = [UIImage  imageWithData:data];
        [profileImageView setImage:image animated:YES];
    } failure:nil];
}

- (void)createDisplayName:(NSString *)displayName {
    
    _displayNameLabel                 = [[UILabel alloc] init];
    _displayNameLabel.backgroundColor = [UIColor clearColor];
    _displayNameLabel.textColor       = [UIColor whiteColor];
    _displayNameLabel.text            = displayName;
    
    [self addSubview:_displayNameLabel];
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
    _titleLabel.font        = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:2];
    [_titleLabel sizeToFit];

    CGRect frame            = _titleLabel.frame;
    frame.origin.y          = kAFBlipFriendRequestModal_titlePaddingY;
    frame.origin.x          = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2;
    _titleLabel.frame       = frame;

    //Display name
    _displayNameLabel.font  = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    [_displayNameLabel sizeToFit];

    frame                   = _displayNameLabel.frame;
    frame.origin.y          = kAFBlipFriendRequestModal_profileImageSize + (kAFBlipFriendRequestModal_titlePaddingY * 5);
    frame.origin.x          = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2;
    _displayNameLabel.frame = frame;
    
    //Buttons
    UIFont *buttonFont      = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    for(UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Utilities
- (NSString *)titleForType:(AFBlipFriendRequestModalType)type {
    
    NSString *title;
    
    switch(type) {
        case AFBlipFriendRequestModalType_FriendRequest:
            title = NSLocalizedString(@"AFBlipFriendRequestModalTitleRequest", nil);
            break;
        case AFBlipFriendRequestModalType_FriendRequestConfirmation:
            title = NSLocalizedString(@"AFBlipFriendRequestModalTitleConfirm", nil);
            break;
        case AFBlipFriendRequestModalType_NewVideo:
            title = NSLocalizedString(@"AFBlipFriendRequestModalTitleNewVideo", nil);
            break;
        default:
            break;
    }
    
    return title;
}

+ (NSArray *)buttonTitlesForType:(AFBlipFriendRequestModalType)type {
    
    NSArray *buttonTitles;
    
    switch(type) {
        case AFBlipFriendRequestModalType_FriendRequest:
            buttonTitles = @[NSLocalizedString(@"AFBlipFriendRequestModalButtonDecline", nil), NSLocalizedString(@"AFBlipFriendRequestModalButtonAccept", nil)];
            break;
        case AFBlipFriendRequestModalType_FriendRequestConfirmation:
            buttonTitles = @[NSLocalizedString(@"AFBlipFriendRequestModalButtonDismiss", nil), NSLocalizedString(@"AFBlipFriendRequestModalButtonPostVideo", nil)];
            break;
        case AFBlipFriendRequestModalType_NewVideo:
            buttonTitles = @[NSLocalizedString(@"AFBlipFriendRequestModalButtonDismiss", nil), NSLocalizedString(@"AFBlipFriendRequestModalButtonWatch", nil)];
            break;
        default:
            break;
    }
    
    return buttonTitles;
}

#pragma mark - AFFAlertViewDelegate
- (CGSize)alertViewPreferredSize:(AFFAlertView *)alertView {
    
    return CGSizeMake(CGRectGetWidth(alertView.frame), kAFBlipFriendRequestModal_height);
}

- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    
    BOOL actionBool = buttonModel.index == 1;

    switch(_type) {
        case AFBlipFriendRequestModalType_FriendRequest:
            if([_friendRequestModalDelegate respondsToSelector:@selector(friendRequestModal:didAcceptFriendInvitation:)]) {
                [_friendRequestModalDelegate friendRequestModal:self didAcceptFriendInvitation:actionBool];
            }
            break;
        case AFBlipFriendRequestModalType_FriendRequestConfirmation:
            if([_friendRequestModalDelegate respondsToSelector:@selector(friendRequestModal:didSelectPostVideo:)]) {
                [_friendRequestModalDelegate friendRequestModal:self didSelectPostVideo:actionBool];
            }
            break;
        case AFBlipFriendRequestModalType_NewVideo:
                if([_friendRequestModalDelegate respondsToSelector:@selector(friendRequestModal:didSelectViewVideo:)]) {
                [_friendRequestModalDelegate friendRequestModal:self didSelectViewVideo:actionBool];
                }
            break;
        default:
            break;
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    _friendRequestModalDelegate = nil;
}

@end
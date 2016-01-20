//
//  AFBlipLimitedProfileViewContentView.m
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipLimitedProfileViewContentView.h"
#import "AFBlipLimitedProfileModel.h"
#import "AFBlipConnectionModelFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipAlertView.h"
#import "AFDynamicFontMediator.h"
#import "UIColor+AFBlipColor.h"
#import "AFBlipAWSS3AbstractFactory.h"
#import "UIImageView+AFBlipImageView.h"

const CGFloat kAFBlipLimitedUserProfileNameSize                   = 2;
const NSInteger kAFBlipLimitedUserProfileNameOffset               = 25;
const NSInteger kAFBlipLimitedUserProfileCountYOffset             = 10;
const NSInteger kAFBlipLimitedUserProfileImageOffset              = 35;
const NSInteger kAFBlipLimitedUserProfileImageSize                = 80;
const NSInteger kAFBlipLimitedUserProfileConnectionsIconXOffset   = 45;
const NSInteger kAFBlipLimitedUserProfileConnectionsIconYOffset   = 60;
const NSInteger kAFBlipLimitedUserProfileVideoIconXOffset         = 70;
const NSInteger kAFBlipLimitedUserProfileVideoIconYOffset         = 63;
const NSInteger kAFBlipLimitedUserProfileLabelHeight              = 20;

//Background color
const CGFloat kAFBlipLimitedUserProfile_DragViewWhiteAlpha        = 0.95f;
const CGFloat kAFBlipLimitedUserProfile_DragViewWhiteAmount       = 0.3f;
const CGFloat kAFBlipLimitedUserProfile_DragViewHeaderWhiteAmount = 0.2f;

@interface AFBlipLimitedProfileViewContentView() <AFDynamicFontMediatorDelegate, AFFAlertViewDelegate> {
    AFBlipActivityIndicator *_activityIndicator;
    AFDynamicFontMediator *_dynamicFont;
    UILabel* _displayNameLabel;
    UIImageView* _connectionsCountIcon;
    UILabel* _connectionsCountLabel;
    UIImageView* _videoCountIcon;
    UILabel* _videoCountLabel;
    NSString* _user_id;
}

@end

@implementation AFBlipLimitedProfileViewContentView

- (id)initWithFrame:(CGRect)frame model:(AFBlipLimitedProfileModel *)model toAdd:(BOOL)toAdd {
    self = [super initWithFrame:frame];
    if (self) {
        _user_id = model.user_id;
        if (!toAdd) {
            [self.submitButton removeFromSuperview];
        } else {
            self.submitButton.enabled = YES;
            [self.submitButton setTitle:NSLocalizedString(@"AFBlipLimitedProfileButtonText", nil) forState:UIControlStateNormal];
        }
        
        self.backgroundView.backgroundColor = [UIColor afBlipModalBackgroundColor];
        _header.backgroundColor             = [UIColor afBlipModalHeaderBackgroundColor];
        [self createProfileImageWithModel:model];
        [self createConnectionsCountWithCount:model.connectionsCount];
        [self createVideosCountWithCount:model.videosCount];
        [self createDynamicFont];
    }
    return self;
}

- (void)createProfileImageWithModel:(AFBlipLimitedProfileModel *)model {
    
    UIImageView* __block profileImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - kAFBlipLimitedUserProfileImageSize)/2, _header.frame.size.height + kAFBlipLimitedUserProfileImageOffset , kAFBlipLimitedUserProfileImageSize, kAFBlipLimitedUserProfileImageSize)];
    profileImage.backgroundColor     = [UIColor clearColor];
    profileImage.layer.cornerRadius  = profileImage.frame.size.width * 0.5f;
    profileImage.layer.borderColor   = [UIColor whiteColor].CGColor;
    profileImage.layer.borderWidth   = 2;
    profileImage.layer.masksToBounds = YES;
    profileImage.clipsToBounds       = YES;
    
    AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    [imageFactory objectForKey:model.userImageUrl completion:^(NSData *data) {
        [profileImage setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];

    [self addSubview:profileImage];
    [self createUsername:model.displayName withStartingPoint:CGRectGetMaxY(profileImage.frame)];
}

- (void)createUsername:(NSString *)displayName withStartingPoint:(CGFloat)position {
    
    _displayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, position + kAFBlipLimitedUserProfileNameOffset, self.frame.size.width, kAFBlipLimitedUserProfileLabelHeight)];
    _displayNameLabel.textColor = [UIColor whiteColor];
    _displayNameLabel.textAlignment = NSTextAlignmentCenter;
    _displayNameLabel.text = displayName;
    
    [self addSubview:_displayNameLabel];
}

- (void)createConnectionsCountWithCount:(NSInteger)count {
    
    _connectionsCountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipConnectionsButton"]];
    _connectionsCountIcon.frame = CGRectMake(kAFBlipLimitedUserProfileConnectionsIconXOffset, _header.frame.size.height + kAFBlipLimitedUserProfileConnectionsIconYOffset, _connectionsCountIcon.frame.size.width * 0.85f, _connectionsCountIcon.frame.size.height * 0.85f);
    
    _connectionsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(_connectionsCountIcon.frame) + kAFBlipLimitedUserProfileCountYOffset, CGFLOAT_MAX, kAFBlipLimitedUserProfileLabelHeight)];
    _connectionsCountLabel.textColor = [UIColor whiteColor];
    _connectionsCountLabel.textAlignment = NSTextAlignmentCenter;
    _connectionsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    [self addSubview:_connectionsCountLabel];
    [self addSubview:_connectionsCountIcon];
    _connectionsCountLabel.center = CGPointMake(_connectionsCountIcon.center.x, _connectionsCountLabel.center.y);

}

- (void)createVideosCountWithCount:(NSInteger)count {
    
    _videoCountIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlipsVideoIcon"]];
    _videoCountIcon.frame = CGRectMake(self.frame.size.width - kAFBlipLimitedUserProfileVideoIconXOffset - 36, _header.frame.size.height + kAFBlipLimitedUserProfileVideoIconYOffset - 1, _videoCountIcon.frame.size.width, _videoCountIcon.frame.size.height);
    
    _videoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(_videoCountIcon.frame) + kAFBlipLimitedUserProfileCountYOffset - 9, CGFLOAT_MAX, kAFBlipLimitedUserProfileLabelHeight)];
    _videoCountLabel.textColor = [UIColor whiteColor];
    _videoCountLabel.textAlignment = NSTextAlignmentCenter;
    _videoCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    [self addSubview:_videoCountLabel];
    [self addSubview:_videoCountIcon];
    _videoCountLabel.center = CGPointMake(_videoCountIcon.center.x - 1, _videoCountLabel.center.y);

}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    //Display name
    _displayNameLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipLimitedUserProfileNameSize];
    
    //Connections
    _connectionsCountLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipLimitedUserProfileNameSize];
    [_connectionsCountLabel sizeToFit];
    _connectionsCountLabel.center = CGPointMake(_connectionsCountIcon.center.x, _connectionsCountLabel.center.y);

    //Video
    _videoCountLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipLimitedUserProfileNameSize];
    [_videoCountLabel sizeToFit];
    _videoCountLabel.center = CGPointMake(_videoCountIcon.center.x - 2, _videoCountLabel.center.y);
    
    //Submit button
    self.submitButton.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:2];
}

- (void)onSubmitButton:(UIButton *)sender {
    
    if(!_activityIndicator) {
        
        _activityIndicator        = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        CGPoint center            = self.superview.center;
        center.y += CGRectGetHeight(_activityIndicator.frame);
        _activityIndicator.center = center;
        [self.superview addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    }
    
    self.userInteractionEnabled   = NO;
    AFBlipConnectionModelFactory* modelFactory = [[AFBlipConnectionModelFactory alloc] init];
    
    __block NSString *title = NSLocalizedString(@"AFBlipConnectionAddingForFailureTitle", nil);
    __block NSString *message;
    
    typeof(self) __weak weakSelf                           = self;
    typeof(_activityIndicator) __weak weakActivityIndicator = _activityIndicator;

    AFBlipUserModel *userModel       = [AFBlipUserModelSingleton sharedUserModel].userModel;
    [modelFactory createConnectionWithUserID:userModel.user_id otherUser:_user_id accessToken:[AFBlipKeychain keychain].accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        [weakActivityIndicator stopAnimating];
        weakSelf.userInteractionEnabled = NO;
        message = NSLocalizedString(networkCallback.responseMessage, nil);
        
        AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
        alertView.delegate = weakSelf;
        [alertView show];
        
    } failure:^(NSError *error) {
       
        [weakActivityIndicator stopAnimating];
        weakSelf.userInteractionEnabled = NO;
        message = [error.localizedDescription capitalizedString];
        
        AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
        [alertView show];
    }];
}

#pragma mark - AFFAlertViewDelegate
- (void)alertViewDidDismss:(AFFAlertView *)alertView {
    
    [self.delegate initialViewControllerSignInUpBaseViewDidPressHeaderForView:self];
}

@end
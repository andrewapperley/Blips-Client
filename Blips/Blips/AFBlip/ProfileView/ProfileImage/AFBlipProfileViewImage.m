//
//  AFBlipProfileViewImage.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipProfileViewImage.h"
#import "AFBlipUserModel.h"
#import "AFBlipAWSS3AbstractFactory.h"
#import "AFDynamicFontMediator.h"
#import "UIImageView+AFBlipImageView.h"

//Self height
const CGFloat kAFBlipProfileViewImage_Height                            = 142.0f;

//Profile image
const CGFloat kAFBlipProfileViewImage_ProfileImageWidth                 = 78.0f;
const CGFloat kAFBlipProfileViewImage_ProfileImageAnimateInDuration     = 0.3f;

//Profile label
const CGFloat kAFBlipProfileViewImage_ProfileLabelPosY                  = kAFBlipProfileViewImage_ProfileImageWidth + 7;

//Notifications
const CGFloat kAFBlipProfileViewImage_NotificationsPosX                 = 152.0f;
const CGFloat kAFBlipProfileViewImage_NotificationsPosY                 = 3.0f;
const CGFloat kAFBlipProfileViewImage_NotificationsTitleLeftInset       = 5.0f;

@interface AFBlipProfileViewImage () <AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator   *_dynamicFont;
    UIImageView             *_profileImage;
    UILabel                 *_profileLabel;
}

@end

@implementation AFBlipProfileViewImage

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame displyName:(NSString *)displayName displayImageURLString:(NSString *)displayImageURLString {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createProfileImage:displayImageURLString];
        [self createDisplayNameLabel:displayName];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Create user image
- (void)createProfileImage:(NSString *)imageURL {
    
    //Create button
    _profileImage                          = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - kAFBlipProfileViewImage_ProfileImageWidth) / 2, 0, kAFBlipProfileViewImage_ProfileImageWidth, kAFBlipProfileViewImage_ProfileImageWidth)];
    _profileImage.backgroundColor          = [UIColor clearColor];
    _profileImage.layer.cornerRadius       = CGRectGetWidth(_profileImage.frame) * 0.5f;
    _profileImage.layer.borderWidth        = 2.0f;
    _profileImage.layer.borderColor        = [UIColor whiteColor].CGColor;
    _profileImage.layer.shouldRasterize    = YES;
    _profileImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _profileImage.clipsToBounds            = YES;
    
    //Load image
    AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    typeof(_profileImage) __weak weakProfileImage = _profileImage;
    [imageFactory objectForKey:imageURL completion:^(NSData *data) {
        [weakProfileImage setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];

    [self addSubview:_profileImage];
}

#pragma mark - Create disply name label
- (void)createDisplayNameLabel:(NSString *)displayName {
    
    _profileLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipProfileViewImage_ProfileLabelPosY, CGRectGetWidth(self.bounds), 40)];
    _profileLabel.textAlignment     = NSTextAlignmentCenter;
    _profileLabel.text              = displayName;
    _profileLabel.textColor         = [UIColor whiteColor];
    _profileLabel.backgroundColor   = [UIColor clearColor];
    
    [self addSubview:_profileLabel];
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _profileLabel.font              = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
}

#pragma mark - Display image
- (void)setDisplayImage:(UIImage *)displayImage {
    
    _profileImage.image = displayImage;
}

- (UIImage *)displayImage {
    
    return _profileImage.image;
}

#pragma mark - Display name 
- (void)setDisplayName:(NSString *)displayName {
    
    _profileLabel.text = displayName;
}

- (NSString *)displayName {
    
    return _profileLabel.text;
}

#pragma mark - Update Information
- (void)updateUserName:(NSString *)displayName displayImage:(NSString *)imageURL {
    
    _profileLabel.text                            = displayName;

    AFBlipAWSS3AbstractFactory *imageFactory      = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    typeof(self) __weak wself = self;
    [imageFactory objectForKey:imageURL completion:^(NSData *data) {
        [wself updateProfileImageWithImageData:data];
    } failure:nil];
}

- (void)updateProfileImageWithImageData:(NSData *)data {
    [_profileImage setImage:[UIImage imageWithData:data] animated:YES];
}

@end
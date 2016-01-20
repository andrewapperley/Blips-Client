//
//  AFBlipConnectionProfileViewProfiles.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipConnectionProfileViewProfiles.h"
#import "AFBlipUserModel.h"
#import "UIImageView+AFBlipImageView.h"

#pragma mark - Constants
//Min header height
const CGFloat kAFBlipConnectionProfileViewProfile_HeightMin                  = 0.0f;

//Portraits
const CGFloat kAFBlipConnectionProfileViewProfiles_PortraitPaddingHorizontal = 15.0f;
const CGFloat kAFBlipConnectionProfileViewProfiles_PortraitPaddingVertical   = 15.0f;
const CGFloat kAFBlipConnectionProfileViewProfiles_PortraitWidthHeight       = 82.0f;
const CGFloat kAFBlipConnectionProfileViewProfiles_PortraitBorderWidth       = 2.0f;

//Border
const CGFloat kAFBlipConnectionProfileViewProfiles_BottomBorderWidth         = 1.0f;

@interface AFBlipConnectionProfileViewProfiles () {
    
    //Frame properties
    CGFloat                     _height;
    CGFloat                     _maxHeight;
    
    //Portraits
    UIImageView                 *_userPortrait;
    UIImageView                 *_connectionPortrait;
}

@end

@implementation AFBlipConnectionProfileViewProfiles

#pragma mark - Init 
- (instancetype)initWithFrame:(CGRect)frame userModel:(AFBlipUserModel *)userModel connectionUserModel:(AFBlipUserModel *)connectionUserModel {

    self = [super initWithFrame:frame];
    if(self){
        
        _maxHeight           = CGRectGetHeight(frame);
        _height              = _maxHeight;
        [self createPortraits:userModel connectionUserModel:connectionUserModel];
        [self createBackground];
        [self createBottomBorder];
    }
    return self;
}

#pragma mark - Background
- (void)createBackground {
    
    self.clipsToBounds   = YES;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AFBlipTimelineHeaderBackground"]];
}

#pragma mark - Portraits
- (void)createPortraits:(AFBlipUserModel *)userModel connectionUserModel:(AFBlipUserModel *)connectionUserModel {
    
    CGRect frame;
    
    //User
    _userPortrait                        = [self createPortrait];
    _userPortrait.autoresizingMask       = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_userPortrait];

    frame                                = _userPortrait.frame;
    frame.origin.x                       = kAFBlipConnectionProfileViewProfiles_PortraitPaddingHorizontal;
    frame.origin.y                       = kAFBlipConnectionProfileViewProfiles_PortraitPaddingVertical;
    _userPortrait.frame                  = frame;

    //Connection
    _connectionPortrait                  = [self createPortrait];
    _connectionPortrait.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:_connectionPortrait];

    frame                                = _connectionPortrait.frame;
    frame.origin.x                       = CGRectGetWidth(self.bounds) - kAFBlipConnectionProfileViewProfiles_PortraitPaddingHorizontal;
    frame.origin.y                       = kAFBlipConnectionProfileViewProfiles_PortraitPaddingVertical;
    _connectionPortrait.frame            = frame;
    
    //Load images
    AFBlipAWSS3AbstractFactory *imageFactory = [[AFBlipAWSS3AbstractFactory alloc] init];

    typeof(_userPortrait) __weak weakUserPortrait = _userPortrait;
    [imageFactory objectForKey:userModel.userImageUrl completion:^(NSData *data) {
        [weakUserPortrait setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];

    typeof(_connectionPortrait) __weak weakConnectionPortrait = _connectionPortrait;
    [imageFactory objectForKey:userModel.userImageUrl completion:^(NSData *data) {
        [weakConnectionPortrait setImage:[UIImage imageWithData:data] animated:YES];
    } failure:nil];
}

- (UIImageView *)createPortrait {
    
    UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAFBlipConnectionProfileViewProfiles_PortraitWidthHeight, kAFBlipConnectionProfileViewProfiles_PortraitWidthHeight)];
    portrait.backgroundColor              = [UIColor whiteColor];
    
    //Border and corner radius
    portrait.layer.borderWidth            = kAFBlipConnectionProfileViewProfiles_PortraitBorderWidth;
    portrait.layer.borderColor            = [UIColor whiteColor].CGColor;
    portrait.layer.allowsEdgeAntialiasing = YES;
    portrait.layer.rasterizationScale     = [UIScreen mainScreen].scale;
    portrait.layer.shouldRasterize        = YES;
    portrait.layer.cornerRadius           = afRound(CGRectGetWidth(portrait.frame) * 0.5f);
    portrait.layer.masksToBounds          = YES;
    portrait.layer.drawsAsynchronously    = YES;
    
    return portrait;
}

#pragma mark - Bottom border
- (void)createBottomBorder {
    
    CGFloat height                = kAFBlipConnectionProfileViewProfiles_BottomBorderWidth;
    UIView *bottomBorder          = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height)];
    bottomBorder.backgroundColor  = [UIColor whiteColor];
    bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomBorder];
}

#pragma mark - Set header y position
- (void)setProfileViewInternalPosY:(CGFloat)internalPosY {
    
    _height = MAX(kAFBlipConnectionProfileViewProfile_HeightMin, _maxHeight - internalPosY);
    [self setNeedsLayout];
}

#pragma mark - Max header height
- (CGFloat)maxHeaderHeight {
    
    return _maxHeight;
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Set height
    CGRect frame                          = self.frame;
    frame.size.height                     = _height;
    self.frame                            = frame;
    
    //Portrait frames
    CGFloat heightDiff        = _maxHeight - _height;
    CGFloat portraitPosY      = kAFBlipConnectionProfileViewProfiles_PortraitPaddingVertical + kAFBlipConnectionProfileViewProfiles_PortraitWidthHeight + (heightDiff * 0.5f);
    
    frame                     = _userPortrait.frame;
    frame.origin.y            = portraitPosY;
    _userPortrait.frame       = frame;

    frame                     = _connectionPortrait.frame;
    frame.origin.y            = portraitPosY;
    _connectionPortrait.frame = frame;
}

@end
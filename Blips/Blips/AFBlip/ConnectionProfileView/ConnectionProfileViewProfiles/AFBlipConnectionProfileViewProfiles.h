//
//  AFBlipConnectionProfileViewProfiles.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipUserModel;

@interface AFBlipConnectionProfileViewProfiles : UIView

- (instancetype)initWithFrame:(CGRect)frame userModel:(AFBlipUserModel *)userModel connectionUserModel:(AFBlipUserModel *)connectionUserModel;

/** Adjusts the header height based on a given position. */
- (void)setProfileViewInternalPosY:(CGFloat)internalPosY;

@end
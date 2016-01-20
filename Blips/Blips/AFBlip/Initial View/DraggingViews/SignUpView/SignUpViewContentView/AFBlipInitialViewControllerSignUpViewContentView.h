//
//  AFBlipInitialViewControllerSignUpViewContentView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpBaseView.h"

typedef NS_ENUM(NSInteger, AFBlipInitialViewUserProfileImageType) {
    AFBlipInitialViewUserProfileImageType_Album,
    AFBlipInitialViewUserProfileImageType_Camera,
    AFBlipInitialViewUserProfileImageType_Cancel
};

@interface AFBlipInitialViewControllerSignUpViewContentView : AFBlipInitialViewControllerSignInUpBaseView

@property (nonatomic, assign, readonly) BOOL userHasChosenAProfileImage;

- (void)openImagePicker;

@end
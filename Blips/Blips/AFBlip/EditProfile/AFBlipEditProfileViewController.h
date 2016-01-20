//
//  AFBlipEditProfileViewController.h
//  Blips
//
//  Created by Andrew Apperley on 2014-04-25.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseFullScreenModalViewController.h"

@protocol AFBlipEditProfileDelegate <NSObject>

- (void)userProfileDidUpdateWithProfileImage:(NSData *)profileImage displayName:(NSString *)displayName;
- (void)userDidDeactivateAccount;

@end

@interface AFBlipEditProfileViewController : AFBlipBaseFullScreenModalViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, weak)id<AFBlipEditProfileDelegate> delegate;

@end
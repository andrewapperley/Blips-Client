//  AFBlipProfileViewImage.h
//
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipProfileViewImage;
@class AFBlipUserModel;

FOUNDATION_EXPORT const CGFloat kAFBlipProfileViewImage_Height;

@interface AFBlipProfileViewImage : UIView

@property (nonatomic, assign) UIImage *displayImage;
@property (nonatomic, assign) NSString *displayName;

- (instancetype)initWithFrame:(CGRect)frame displyName:(NSString *)displayName displayImageURLString:(NSString *)displayImageURLString;
- (void)updateUserName:(NSString *)displayName displayImage:(NSString *)imageURL;
- (void)updateProfileImageWithImageData:(NSData *)data;

@end
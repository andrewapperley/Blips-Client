//
//  AFBlipInitialViewUserModel.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-21.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFBlipInitialViewUserModelType) {
    
    AFBlipInitialViewUserModelType_SignIn,
    AFBlipInitialViewUserModelType_SignUp
};

@interface AFBlipInitialViewUserModel : NSObject

@property (nonatomic, assign) AFBlipInitialViewUserModelType type;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *profileImage;

@end

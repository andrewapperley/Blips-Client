//
//  AFBlipUserModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipUserModel : NSObject

@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *user_id;
@property (nonatomic, copy, readonly) NSString *userImageUrl;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, assign) NSUInteger videoCount;
@property (nonatomic, readonly) BOOL isNewConnection;
@property (nonatomic) BOOL isDeactivated;

@end

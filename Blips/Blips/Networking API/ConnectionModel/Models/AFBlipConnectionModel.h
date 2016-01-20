//
//  AFBlipConnectionModel.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFBlipUserModel;

@interface AFBlipConnectionModel : NSObject

@property(nonatomic, copy, readonly)NSString* connectionId;
@property(nonatomic, copy, readonly)NSString* timelineId;
@property(nonatomic, strong, readonly)AFBlipUserModel* connectionFriend;

@end
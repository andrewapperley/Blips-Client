//
//  AFBlipLimitedProfileModel.h
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipUserModel.h"

@interface AFBlipLimitedProfileModel : AFBlipUserModel

@property (nonatomic) NSInteger videosCount;
@property (nonatomic) NSInteger connectionsCount;

@end
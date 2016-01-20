//
//  AFBlipBaseNetworkStatics.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#pragma mark - Class forwards
@class AFBlipBaseNetworkModel;

#pragma mark - Network callback block typedefs
typedef void(^AFBlipBaseNetworkSuccess)(AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipBaseNetworkFailure)(NSError *error);

#pragma mark - Network base URL
FOUNDATION_EXPORT NSString *const kAFBlipBaseNetworkURL_Non_Amazon;
FOUNDATION_EXPORT NSString *const kAFBlipBaseNetworkURL_Amazon;
FOUNDATION_EXPORT NSString *const kAFBlipBaseNetworkURL_Local;
//
//  AFBlipBaseNetworkDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"

typedef NS_ENUM(NSUInteger, AFBlipNetworkCallType) {
    kAFBlipNetworkCallType_POST,
    kAFBlipNetworkCallType_GET
};

@interface AFBlipBaseNetworkDatasource : NSObject

- (NSURLSessionDataTask *)makeURLRequestWithType:(AFBlipNetworkCallType)type endpointURLString:(NSString *)urlString success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;
- (NSURLSessionDataTask *)makeURLRequestWithType:(AFBlipNetworkCallType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end

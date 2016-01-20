//
//  AFBlipBaseNetworkModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipBaseNetworkModel : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic) NSUInteger responseCode;
@property (nonatomic, copy, readonly) NSString *responseMessage;
@property (nonatomic, copy, readonly) NSDictionary *responseData;

+ (AFBlipBaseNetworkModel *)networkModelFromResponse:(id)callbackObject;

@end

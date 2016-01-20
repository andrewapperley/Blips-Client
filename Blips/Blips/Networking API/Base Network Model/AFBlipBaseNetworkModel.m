//
//  AFBlipBaseNetworkModel.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkModel.h"

@implementation AFBlipBaseNetworkModel

#pragma mark - Status handling
+ (AFBlipBaseNetworkModel *)networkModelFromResponse:(id)callbackObject {
    
    NSMutableDictionary *networkCallbackDictionary = callbackObject;
    
    AFBlipBaseNetworkModel *networkModel = [[AFBlipBaseNetworkModel alloc] init];
    
    //Status
    networkModel.success = [networkCallbackDictionary[@"status"] boolValue];
    [networkCallbackDictionary removeObjectForKey:@"status"];
    
    //Response code
    NSUInteger responseCode = [networkCallbackDictionary[@"HTTP_CODE"] unsignedIntegerValue];
    networkModel.responseCode = responseCode;
    [networkCallbackDictionary removeObjectForKey:@"HTTP_CODE"];
    
    //Response message
    NSString *responseMessage = networkCallbackDictionary[@"message"];
    [networkModel setValue:responseMessage forKey:@"responseMessage"];
    [networkCallbackDictionary removeObjectForKey:@"message"];
    
    //Response data
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:networkCallbackDictionary];
    
    if(responseDictionary && responseDictionary.allValues.count > 0 && responseDictionary.allKeys.count > 0) {
        [networkModel setValue:responseDictionary forKey:@"responseData"];
    }
    
    return networkModel;
}

@end

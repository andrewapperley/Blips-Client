//
//  AFBlipBaseNetworkDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <AFNetworking.h>
#import "AFBlipBaseNetworkDatasource.h"
#import "AFHash.h"

const NSString *kAFBlipBaseNetworkKeyPostParam          = @"params";
const NSString *kAFBlipBaseNetworkKeyTimestampParam     = @"request_timestamp";
const NSString *kAFBlipBaseNetworkKeyDeviceTokenParam   = @"device_token";
const NSString *kAFBlipBaseNetworkKeyDeviceToken        = @"&^uZ7S?56BaRP73hq7*#568gGG#xZau$MFrnM6Wm6rt+zM&GWq29aV!ScrBL2ba#2npc!N6V^qUHDjx!";

@implementation AFBlipBaseNetworkDatasource

- (NSURLSessionDataTask *)makeURLRequestWithType:(AFBlipNetworkCallType)type endpointURLString:(NSString *)urlString success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    return [self makeURLRequestWithType:type endpointURLString:urlString parameters:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)makeURLRequestWithType:(AFBlipNetworkCallType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    //Base request URL
    static AFHTTPSessionManager *sessionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *URLString;
        NSString *isLocalPath = [NSProcessInfo processInfo].environment[@"IS_LOCAL"];

        //Amazon
        NSString *isNotAmazon = [NSProcessInfo processInfo].environment[@"NON_AMAZON"];
        if(isNotAmazon) {
    
            //Local
            if([isLocalPath boolValue]) {
                URLString = kAFBlipBaseNetworkURL_Local;
            } else {
                URLString = kAFBlipBaseNetworkURL_Non_Amazon;
            }
        } else {
            URLString = kAFBlipBaseNetworkURL_Amazon;
        }
        
        NSURL *baseRequestURL = [NSURL URLWithString:URLString];
        
        //Create session manager
        sessionManager        = [[AFHTTPSessionManager alloc] initWithBaseURL:baseRequestURL];
    });
    
    [sessionManager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    
    if (!parameters) {
        parameters = [NSDictionary dictionary];
    }
    
    NSMutableDictionary *newParamDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParamDictionary setObject:[NSString stringWithFormat:@"%ld", ((long)[[NSDate date] timeIntervalSince1970])] forKey:kAFBlipBaseNetworkKeyTimestampParam];
    [newParamDictionary setObject:hashed_password([NSString stringWithFormat:@"%ld%@", (long)[newParamDictionary[kAFBlipBaseNetworkKeyTimestampParam] integerValue], kAFBlipBaseNetworkKeyDeviceToken]) forKey:kAFBlipBaseNetworkKeyDeviceTokenParam];
    parameters = newParamDictionary;
    
    //If the type is "POST" then we must wrap any parameters in a 'params' dictionary.
    if(type == kAFBlipNetworkCallType_POST) {
        
        NSMutableDictionary *newParamDictionary = [NSMutableDictionary dictionary];
        if(parameters) {
            [newParamDictionary setObject:parameters forKey:kAFBlipBaseNetworkKeyPostParam];
        }
        
        [sessionManager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
        
        return [sessionManager POST:urlString parameters:newParamDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
            
            AFBlipBaseNetworkModel *networkModel = [AFBlipBaseNetworkModel networkModelFromResponse:responseObject];
            success(networkModel);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
        
    } else {
        return [sessionManager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            AFBlipBaseNetworkModel *networkModel = [AFBlipBaseNetworkModel networkModelFromResponse:responseObject];
            success(networkModel);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

@end

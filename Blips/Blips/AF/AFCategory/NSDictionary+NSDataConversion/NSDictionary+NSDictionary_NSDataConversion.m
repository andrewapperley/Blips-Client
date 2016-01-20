//
//  NSDictionary+NSDictionary_NSDataConversion.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "NSDictionary+NSDictionary_NSDataConversion.h"

@implementation NSDictionary (NSDictionary_NSDataConversion)

#pragma mark - Dictionary from data
+ (instancetype)dictionaryWithData:(NSData *)data {
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return dictionary;
}

@end

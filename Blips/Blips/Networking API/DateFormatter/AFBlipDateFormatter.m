//
//  AFBlipDateFormatter.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipDateFormatter.h"

#pragma mark - Network date formatting
NSString *const kAFBlipDateFormatterDefaultDateFormat                       = @"EEE, dd MMM yyyy hh:mm:ss z";
NSString *const kAFBlipDateFormatterExpiryDateFormat                        = @"YYYY-dd-MM HH:mm:ss";
NSString *const kAFBlipDateFormatterDefaultDateDisplayMonthDayYearFormat    = @"MMM dd yyyy";
NSString *const kAFBlipDateFormatterDefaultDateDisplayHourMinutesFormat     = @"h:mm a";

@implementation AFBlipDateFormatter

+ (AFBlipDateFormatter *)defaultDateFormat {
    
    static AFBlipDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter            = [AFBlipDateFormatter formatter];
        formatter.dateFormat = kAFBlipDateFormatterDefaultDateFormat;
    });
    
    return formatter;
}

+ (AFBlipDateFormatter *)expiryDateFormat {
    
    static AFBlipDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter            = [AFBlipDateFormatter formatter];
        formatter.dateFormat = kAFBlipDateFormatterExpiryDateFormat;
    });
    
    return formatter;
}

+ (AFBlipDateFormatter *)defaultDateFormatterMonthDayYearFormat {
    
    static AFBlipDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter            = [AFBlipDateFormatter formatter];
        formatter.dateFormat = kAFBlipDateFormatterDefaultDateDisplayMonthDayYearFormat;
    });
    
    return formatter;
}

+ (AFBlipDateFormatter *)defaultDateFormatterHourMinutesFormat {
    
    static AFBlipDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter            = [AFBlipDateFormatter formatter];
        formatter.dateFormat = kAFBlipDateFormatterDefaultDateDisplayHourMinutesFormat;
    });
    
    return formatter;
}

#pragma mark - Singleton instance
+ (AFBlipDateFormatter *)formatter {
    
    NSTimeZone *timeZone           = [NSTimeZone systemTimeZone];
    AFBlipDateFormatter *formatter = [[AFBlipDateFormatter alloc] init];
    formatter.timeZone             = [NSTimeZone timeZoneWithAbbreviation:timeZone.abbreviation];
    formatter.locale               = [NSLocale currentLocale];
    
	return formatter;
}

@end
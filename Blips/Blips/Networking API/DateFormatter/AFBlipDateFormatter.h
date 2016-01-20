//
//  AFBlipDateFormatter.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipDateFormatter : NSDateFormatter

/** Returns a date formatter with the format of 'EEE, dd MMM yyyy hh:mm:ss z' -> 'Mon, 01 Jan 1970 00:00:00 am' */
+ (AFBlipDateFormatter *)defaultDateFormat;

/** Returns a date formatter with the format of 'MMM DD yyyy' -> 'Jan 01 1970' */
+ (AFBlipDateFormatter *)defaultDateFormatterMonthDayYearFormat;

/** Returns a date formatter with the format of 'hh:mm:ss z' -> '00:00:00 am' */
+ (AFBlipDateFormatter *)defaultDateFormatterHourMinutesFormat;

/** Returns a date formatter with the format of 'YYYY-dd-mm hh:mm:ss' -> '1970-01-01 00:00:00' */
+ (AFBlipDateFormatter *)expiryDateFormat;

@end

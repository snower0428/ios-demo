//
//  NSDateExtention.mm
//
//  Created by zhangtianfu on 11-1-12.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "NSDateExtention.h"


@implementation NSDateExtention


+ (NSString*)stringFormDate:(NSDate*)date dateFormat:(NSString*)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:format];
	NSString *dateString = [formatter stringFromDate:date];
	[formatter release];
	
	return dateString;
}

+ (NSDate*)dateFormString:(NSString*)dateString dateFormat:(NSString*)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:format];
	NSDate *date = [formatter dateFromString:dateString];
	[formatter release];
	
	return date;
}

+ (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)date;
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:unitFlags fromDate:date];
	return components;
}

+ (int)era:(NSDate*)date
{
	NSDateComponents *components = [self components:NSEraCalendarUnit fromDate:date];
	return [components era];
}

+ (int)year:(NSDate*)date
{
	NSDateComponents *components = [self components:NSYearCalendarUnit fromDate:date];
	return [components year];
}

+ (int)month:(NSDate*)date
{
	NSDateComponents *components = [self components:NSMonthCalendarUnit fromDate:date];
	return [components month];
}

+ (int)day:(NSDate*)date
{
	NSDateComponents *components = [self components:NSDayCalendarUnit fromDate:date];
	return [components day];
}

+ (int)hour:(NSDate*)date
{
	NSDateComponents *components = [self components:NSHourCalendarUnit fromDate:date];
	return [components hour];
}

+ (int)minute:(NSDate*)date
{
	NSDateComponents *components = [self components:NSMinuteCalendarUnit fromDate:date];
	return [components minute];
}

+ (int)second:(NSDate*)date
{
	NSDateComponents *components = [self components:NSSecondCalendarUnit fromDate:date];
	return [components second];
}

+ (int)week:(NSDate*)date
{
	NSDateComponents *components = [self components:NSWeekCalendarUnit fromDate:date];
	return [components week];
}

+ (int)weekday:(NSDate*)date
{
	NSDateComponents *components = [self components:NSWeekdayCalendarUnit fromDate:date];
	return [components weekday];
}

+ (int)weekdayOrdinal:(NSDate*)date
{
	NSDateComponents *components = [self components:NSWeekdayOrdinalCalendarUnit fromDate:date];
	return [components weekdayOrdinal];
}



@end

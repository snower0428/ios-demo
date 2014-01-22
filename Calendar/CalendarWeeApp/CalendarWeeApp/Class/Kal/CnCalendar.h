//
//  CnCalendar.h
//  Picker
//
//  Created by Lost on 12-5-21.
//  Copyright 2012 Lost. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface CnCalendar : NSObject {
}

+ (NSDate *)getLunarDate:(NSDate *)date;
+ (NSString *)getLunarDay:(NSDate *)date;		// 返回农历日期
+ (NSString *)getLunarOnlyDay:(NSDate *)date;
+ (NSString *)getLunarSpecialDay:(NSDate *)date;		// 返回农历节气，非节气时返回nil
+ (NSString *)getLunarHolidayDay:(NSDate *)date;		// 返回农历节日，非节日时返回nil
+ (NSString *)getSolarHolidayDay:(NSDate *)date;		// 返回新历节日，非节日时返回nil

+ (NSString *)nextLunarSpecialDaySinceNow;				// 返回当天到下一个节气的天数描述字符串
+ (NSInteger)nextLunarSpecialIntervalDaySinceNow;		// 返回当前系统时间到下一个节气的天数，当天是节气的返回0
+ (NSString *)nextLunarSpecialDaySinceDate:(NSDate *)date;				// 返回date到下一个节气天数的描述字符串
+ (NSInteger)nextLunarSpecialIntervalDaySinceDate:(NSDate *)date;		// 返回date到下一个节气的天数，当天是节气返回0

+ (NSString *)nextLunarHolidaySinceNow;								// 返回当天到下一个农历节日的天数描述字符串
+ (NSString *)nextLunarHolidaySinceDate:(NSDate *)date;				// 返回date到下一个农历节日天数的描述字符串
+ (NSInteger)nextLunarHolidayIntervalDaySinceDate:(NSDate *)date;	// 返回date到下一个农历节日的天数，当天是节气返回0

+ (NSString *)nextSolarHolidaySinceNow;								// 返回当天到下一个新历节日的天数描述字符串
+ (NSString *)nextSolarHolidaySinceDate:(NSDate *)date;				// 返回date到下一个新历节日天数的描述字符串
+ (NSInteger)nextSolarHolidayIntervalDaySinceDate:(NSDate *)date;	// 返回date到下一个新历节日的天数，当天是节气返回0

+ (NSString *)getWeekday:(NSDate *)date;		// 返回周几
+ (NSString *)getAmPm:(NSDate *)date;			// 返回上午下午
@end

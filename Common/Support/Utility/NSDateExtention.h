//
//  NSDateExtention.h
//
//  Created by zhangtianfu on 11-1-12.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateExtention : NSObject {
}

//输出相应时间格式的字符串(如12小时制:"yyyy-MM-dd a hh:mm:ss";  24小时制:"yyyy-MM-dd HH:mm:ss")
+ (NSString*)stringFormDate:(NSDate*)date dateFormat:(NSString*)format;
+ (NSDate*)dateFormString:(NSString*)dateString dateFormat:(NSString*)format;

+ (int)era:(NSDate*)date;
+ (int)year:(NSDate*)date;
+ (int)month:(NSDate*)date;
+ (int)day:(NSDate*)date;
+ (int)hour:(NSDate*)date;
+ (int)minute:(NSDate*)date;
+ (int)second:(NSDate*)date;
+ (int)week:(NSDate*)date;			//当年中的第几星期（每个“星期天～星期六”为一周，如果年初的哪个星期前半段在上一年的也算为一星期）
+ (int)weekday:(NSDate*)date;		//星期几（1=星期天，2=星期一，...7=星期六）
+ (int)weekdayOrdinal:(NSDate*)date;//当月中的第几个7天（不管1号是星期几，都是1周的第一天）

+ (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)date;


@end


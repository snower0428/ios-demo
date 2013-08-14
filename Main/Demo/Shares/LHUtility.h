//
//  LHUtility.h
//  Demo
//
//  Created by leihui on 13-8-13.
//
//

#import <Foundation/Foundation.h>

// 判断字符串是否为空
BOOL stringIsEmpty(NSString *str);

/**
 *  描述：向目标日期增加天数
 *  返回值：返回增加天数的日期
 *  days: 增加的天数
 *  fromDate: 从该日期开始增加(格式如：2013-02-21)
 */
NSString *addDays(int days, NSString *fromDate);

NSDate *addDaysFromDate(int days, NSDate *fromDate);

/**
 *  传入一个url字符串，返回一个去掉字符和encoding的url字符串
 */
NSString *urlEncodeString(NSString *str);

long get_file_size( NSString *filenameStr);


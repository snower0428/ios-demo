//
//  Logger.h
//  SystemCommand
//
//  Created by zhangtianfu on 10-10-25.
//  Copyright 2010 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_PATH  [NSTemporaryDirectory() stringByAppendingString:@"Log.txt"]

//#define NSLog(...)

#if TARGET_IPHONE_SIMULATOR
   #define  MLOG(...) NSLog(__VA_ARGS__);
#else 
   #define  MLOG(...) NSLog(__VA_ARGS__);//[[Logger shareInstance] log:[NSString stringWithFormat:__VA_ARGS__] fileName:__FILE__ line:__LINE__];
#endif

@interface Logger : NSObject
{
	FILE		*m_hFile;
}

+ (Logger*)shareInstance;
+ (void)exitInstance;
- (void)log:(NSString *)text fileName:(const char *)name line:(int)number;

@end


//
//  Logger.h
//  SystemCommand
//
//  Created by zhangtianfu on 10-10-25.
//  Copyright 2010 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef CONFIG_LOG  //给配置员的log
    #if  TARGET_IPHONE_SINULATOR
        #define  WriteLog(...)  NSLog(__VA_ARGS__)
    #else
        #define  WriteLog(...) [[Logger shareInstance] log:[NSString stringWithFormat:__VA_ARGS__] fileName:__FILE__ line:__LINE__];
    #endif
#else
    #ifdef DEBUG  
        #define  WriteLog(...)  NSLog(__VA_ARGS__)//调试debug
    #else	
        #define  WriteLog(...)  do{}while(0)//release
    #endif
#endif


@interface Logger : NSObject {
	FILE		*m_hFile;
	NSString	*m_logPath;
}

+ (Logger*)shareInstance;
+ (void)exitInstance;
- (void)log:(NSString *)text fileName:(const char *)name line:(int)number;

@end

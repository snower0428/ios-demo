//
//  Logger.m
//  SystemCommand
//
//  Created by zhangtianfu on 10-10-25.
//  Copyright 2010 ND WebSoft Inc. All rights reserved.
//

#import "Logger.h"
#import <fcntl.h>


static Logger *kInstance = nil;

@implementation Logger

+ (Logger*)shareInstance{
	@synchronized(self){
		if (nil == kInstance){
			kInstance = [[Logger alloc] init];
		}
	}
	
	return kInstance;
}

+ (void)exitInstance{
	@synchronized(self){
		if (nil != kInstance){
			[kInstance release];
			kInstance = nil;
		}
	}
}

- (id)init{
	if (self = [super init]) {
		NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
		
		NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
		}

		m_logPath = [[NSString alloc] initWithFormat:@"%@.txt", [tempPath stringByAppendingPathComponent:bundleName]];
	}
	
	return self;
}


- (void)log:(NSString *)text fileName:(const char *)name line:(int)number{
	NSString *fileName = [NSString stringWithUTF8String:name];
	fileName = [fileName lastPathComponent];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *curDate = [formatter stringFromDate:[NSDate date]];
	NSString *logText = [[NSString alloc] initWithFormat:@"%@  %@(%d): %@\r\n", curDate, fileName, number, text];
	
	if (NULL == m_hFile){
		m_hFile = fopen([m_logPath UTF8String], "wb+");//创建文件，如果存在会清空内容
	}
	
	if (NULL != m_hFile){
		NSData *data = [logText dataUsingEncoding:NSUTF8StringEncoding];
		fseek(m_hFile, 0, SEEK_END);
		fwrite([data bytes], 1, [data length], m_hFile);
		fflush(m_hFile);
	}

	[logText release];
	[formatter release];
}

- (void)dealloc{
	[m_logPath release];
	fclose(m_hFile);
	[super dealloc];
}

@end

//
//  Logger.m
//  SystemCommand
//
//  Created by zhangtianfu on 10-10-25.
//  Copyright 2010 ND WebSoft Inc. All rights reserved.
//

#import "Logger.h"

static Logger *kLogger = nil;

@implementation Logger

+ (Logger*)shareInstance
{
	@synchronized(self)
	{
		if (nil == kLogger)
		{
			kLogger = [[Logger alloc] init];
		}
	}
	
	return kLogger;
}

+ (void)exitInstance
{
	@synchronized(self)
	{
		if (nil != kLogger)
		{
			[kLogger release];
			kLogger = nil;
		}
	}
}


- (void)log:(NSString *)text fileName:(const char *)name line:(int)number
{
	NSString *fileName = [NSString stringWithUTF8String:name];
	fileName = [fileName lastPathComponent];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *curDate = [formatter stringFromDate:[NSDate date]];
	NSString *logText = [[NSString alloc] initWithFormat:@"%@  %@(%d): %@\n", curDate, fileName, number, text];
	
	if (NULL == m_hFile)
	{
		m_hFile = fopen([LOG_PATH UTF8String], "wb+");//创建文件，如果存在会清空内容
	}
	
	if (NULL != m_hFile)
	{
		NSData *data = [logText dataUsingEncoding:NSUTF8StringEncoding];
		fseek(m_hFile, 0, SEEK_END);
		fwrite([data bytes], 1, [data length], m_hFile);
		fflush(m_hFile);
	}

	[logText release];
	[formatter release];
}

- (void)dealloc
{
	fclose(m_hFile);
	[super dealloc];
}

@end

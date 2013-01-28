//
//  NSString+Additions.m
//  Demo
//
//  Created by lei hui on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64Ex.h"

#define CHUNK_SIZE 1024

@implementation NSString(Additions)

- (NSString *)md5Digest
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    
    return [hash lowercaseString];
}

- (NSString *)file_md5:(NSString *)path
{
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(handle == nil)
        return nil;
    
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    
    NSData* filedata;
    do {
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
    }
    while([filedata length]);
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    
    [handle closeFile];
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];
}

//对字符串的base64编码和解码（原始值必须是字符串）
- (NSString *)encodeBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [GTMBase64Ex stringByEncodingData:data];
}

- (NSString *)decodeBase64
{
    NSData *data = [GTMBase64Ex decodeString:self];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

//对URL进行编码和解码
- (NSString *)encodeURL
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)decodeURL
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeURLParam
{
    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                 (CFStringRef)self, 
                                                                 NULL, 
                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),//CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), 
                                                                 kCFStringEncodingUTF8) autorelease];
}

- (NSString *)addURLKey:(NSString *)key value:(NSString *)value
{
    NSMutableString *URLString = [NSMutableString stringWithString:self];
    if (key && value) {
        if (![self hasSuffix:@"&"] && ![self hasSuffix:@"?"]) {
            [URLString appendString:@"&"];
        }
        [URLString appendString:key];
        [URLString appendString:@"="];
        [URLString appendString:value];
    }
    return URLString;
}

//对字符串的DES加密和解密（原始值必须是字符串）
- (NSString *)DES_EncryptWithKey:(NSString *)key8
{
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *outputData = [inputData DES_CCOperation:kCCEncrypt withKey:key8];
    return [GTMBase64Ex stringByEncodingData:outputData];
}

- (NSString *)DES_DecryptWithKey:(NSString *)key8
{
    NSData *inputData = [GTMBase64Ex decodeString:self];
    NSData *outputData = [inputData DES_CCOperation:kCCDecrypt withKey:key8];
    return  [[[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding] autorelease];
}

//获取符合key的字符串
- (NSString *)getStringFromCharacterSet:(NSString *)characterSet
{
	if ([self length] == 0) {
		return nil;
	}
	
	NSMutableString *strippedString = [NSMutableString stringWithCapacity:self.length];
    
	NSScanner *scanner = [NSScanner scannerWithString:self];
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:characterSet];
    
	while ([scanner isAtEnd] == NO) {
		NSString *buffer = nil;
		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
			[strippedString appendString:buffer];
			buffer = nil;
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
    
	return ([strippedString length]>0) ? [NSString stringWithString:strippedString] : nil;
}

//获取纯数字
- (NSString *)getNumberString
{
	return [self getStringFromCharacterSet:@"0123456789"];
}

//获取int
- (NSString *)getIntString
{
	return [self getStringFromCharacterSet:@"0123456789-"];
}

//获取float
- (NSString *)getFloatString
{
	return [self getStringFromCharacterSet:@"0123456789-."];
}

//是否是中文标点
- (BOOL)isChineseSymbol
{
    NSString *key = @" ，。；！？“”‘’－｀～｜、⋯";
    if ([self getStringFromCharacterSet:key]) {
        return YES;
    } else {
        return NO;
    }
}

//恢复回车换行符号（从配置文件读取会在换行符号前增加一个"\n"）
- (NSString *)restoreEnterSymbol
{
    if (nil == self) {
        return nil;
    }
    NSString *t1 = [self stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    NSString *t2 = [t1 stringByReplacingOccurrencesOfString:@"\\r" withString:@"\n"];
    NSString *t3 = [t2 stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    return  t3;
}

//删除换行字符
- (NSString *)removeEnterSymbol
{
    if (nil == self) {
        return nil;
    }
    NSString *t = [[self restoreEnterSymbol] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return  t;
}

- (UIColor *)getColor
{
	UIColor *color = nil;
	
	NSArray *array = [self componentsSeparatedByString:@","];
	int count = [array count];
	if (count >=3) {
		float r = [[array objectAtIndex:0] floatValue];
		float g = [[array objectAtIndex:1] floatValue];
		float b = [[array objectAtIndex:2] floatValue];
		float a = (count>=4 ? [[array objectAtIndex:3] floatValue] : 1);
		color = RGBA(r, g, b, a);
	}
	
	return color;
}

- (NSString *)getValueFromURLForKey:(NSString *)key
{
	if (nil == key) {
		return nil;
	}
	
	int index = [self rangeOfString:@"?" options:NSCaseInsensitiveSearch].location;
	if (index == NSNotFound){
		return nil;
	}
	
	NSString *paramList = [self substringFromIndex:index+1];
	NSArray *array = [paramList componentsSeparatedByString:@"&"];
	int minlen = [key length] + 1;
	for (NSString *item in array) {
		if ([item length] > minlen && ([key caseInsensitiveCompare:[item substringToIndex:minlen-1]] == NSOrderedSame)){
			int index = [item rangeOfString:@"=" options:NSCaseInsensitiveSearch].location;
			NSString *first = [item substringToIndex:index];
			if ([key caseInsensitiveCompare:first] == NSOrderedSame) {
				return [item substringFromIndex:index+1];
			}
		}
	}
	
	return nil;
}

- (TransitionDirection)directionFromLeftValue
{
	int returnValue = 1;
	
	NSArray *values = [self componentsSeparatedByString:@","];
	int count = [values count];
	if (count>0) {
		returnValue = [[values objectAtIndex:0] intValue];
	}
	
	return (TransitionDirection)returnValue;
}

- (TransitionDirection)directionFromRightValue
{
	int returnValue = 0;
	
	NSArray *values = [self componentsSeparatedByString:@","];
	int count = [values count];
	if (count>1) {
		returnValue = [[values objectAtIndex:1] intValue];
	}
	
	return (TransitionDirection)returnValue;
}

- (BOOL)isFile
{
	BOOL ret = NO;
	BOOL isDirectory = YES;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:self isDirectory:&isDirectory] && !isDirectory) {
		ret = YES;
	} else {
		ret = NO;
	}
	
	return ret;
}

- (NSString *)formatNumber
{
    int length = [self length];
    if (length <= 3) {
        return self;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:self];
    int count = (length-1)/3;
    int index = (length-1)%3+1;
    for (int i=0; i<count; i++) {
        [string insertString:@"," atIndex:index+i];
        index += 3;
    }
    
    return string;
}

- (NSString *)formatVersion
{
	NSRange firstDotRange = [self rangeOfString:@"."];
	if (firstDotRange.location == NSNotFound) {
		return self;
	} else {
		NSRange searchRange = NSMakeRange(firstDotRange.location+1, [self length]-firstDotRange.location-1);
		NSString *dstVersion = [self stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:searchRange];
		return dstVersion;
	}
}

- (BOOL)isEmpty
{
	if (self == nil) {
		return YES;
	}
	if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

@end

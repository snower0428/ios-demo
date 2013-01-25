//
//  PlistParser.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-2.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "PlistParser.h"

@implementation PlistParser

//dictionary
+ (id)dictionaryWithContentsOfFile:(NSString *)path  key:(NSString*)key{
    return [self dictionaryWithContentsOfFile:path key:key mutabilityOption:NSPropertyListImmutable];
}

+ (id)dictionaryWithContentsOfFile:(NSString *)path  key:(NSString*)key mutabilityOption:(int)option{
	NSData *data = [PlistParser dataWithContentsOfFile:path key:key];
	
	NSString *errorStr = nil;
	NSPropertyListFormat format;
	NSDictionary *propertyList = [NSPropertyListSerialization propertyListFromData:data
																  mutabilityOption:option
																			format:&format
																  errorDescription:&errorStr];
	if ([propertyList isKindOfClass:[NSDictionary class]]) {
		return propertyList;
	}else{
		return nil;
	}
}



+ (BOOL)dictionary:(NSDictionary*)dict writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile  key:(NSString*)key{
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
	return [PlistParser data:data writeToFile:path atomically:useAuxiliaryFile   key:key];
}

//array
+ (id)arrayWithContentsOfFile:(NSString *)path  key:(NSString*)key{
    return [self arrayWithContentsOfFile:path key:key mutabilityOption:NSPropertyListImmutable];
}

+ (id)arrayWithContentsOfFile:(NSString *)path  key:(NSString*)key mutabilityOption:(int)option{
	NSData *data = [PlistParser dataWithContentsOfFile:path key:key];
	
	NSString *errorStr = nil;
	NSPropertyListFormat format;
	NSArray *propertyList = [NSPropertyListSerialization propertyListFromData:data
                                                             mutabilityOption:option
                                                                       format:&format
                                                             errorDescription:&errorStr];
	if ([propertyList isKindOfClass:[NSArray class]]) {
		return propertyList;
	}else{
		return nil;
	}
}


+ (BOOL)array:(NSArray*)array writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile  key:(NSString*)key{
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:array format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
	return [PlistParser data:data writeToFile:path atomically:useAuxiliaryFile key:key];
}


//data
+ (id)dataWithContentsOfFile:(NSString *)path  key:(NSString*)key{
	NSData *retData = nil;

	NSFileManager *fileMng = [NSFileManager defaultManager];
	if (![path hasSuffix:@".dat"] && [fileMng fileExistsAtPath:path]) {//直接解析
		retData = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
	}else {//解密解析
		NSString *datPath = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"dat"];
		if ([fileMng fileExistsAtPath:datPath]) {
			NSData *data = [NSData dataWithContentsOfFile:datPath];
			retData = [data AES256_CCOperation:kCCDecrypt withKey:key];
		}
	}

	return retData;
}


+ (BOOL)data:(NSData*)data writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile  key:(NSString*)key{
	if (nil == data || nil == path) {
		return NO;
	}
		
	NSData *outData = data;
	NSString *outputPath= [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"dat"];
	if ([path hasSuffix:@".dat"] || [[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
		//传入的是dat格式或者对应dat文件存在,则用加密处理
		outData = [data AES256_CCOperation:kCCEncrypt withKey:key];
	}else {
		outputPath = [[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
	}

	return [outData writeToFile:outputPath atomically:useAuxiliaryFile];
}

@end

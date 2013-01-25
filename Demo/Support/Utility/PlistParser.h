//
//  PlistParser.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-2.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  plist读取和保存管理类（如果是dat则读取或者保存的时候需要传入加密key）	================

#import <Foundation/Foundation.h>


@interface PlistParser : NSObject {

}

//dictionary
+ (id)dictionaryWithContentsOfFile:(NSString *)path key:(NSString*)key;
+ (id)dictionaryWithContentsOfFile:(NSString *)path  key:(NSString*)key mutabilityOption:(int)option;
+ (BOOL)dictionary:(NSDictionary*)dict writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile key:(NSString*)key;
//array
+ (id)arrayWithContentsOfFile:(NSString *)path key:(NSString*)key;
+ (id)arrayWithContentsOfFile:(NSString *)path  key:(NSString*)key mutabilityOption:(int)option;
+ (BOOL)array:(NSArray*)array writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile key:(NSString*)key;
//data
+ (id)dataWithContentsOfFile:(NSString *)path key:(NSString*)key;
+ (BOOL)data:(NSData*)data writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile key:(NSString*)key;
@end

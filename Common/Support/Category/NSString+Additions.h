//
//  NSString+Additions.h
//  Demo
//
//  Created by lei hui on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Additions)

//md5
- (NSString *)md5Digest;
- (NSString *)md5:(NSString *)str;
- (NSString *)file_md5:(NSString *)path;

//对字符串的base64编码和解码（原始值必须是字符串）
- (NSString *)encodeBase64; 
- (NSString *)decodeBase64; 

//对URL进行编码和解码
- (NSString *)encodeURL;
- (NSString *)decodeURL;
- (NSString *)encodeURLParam;
- (NSString *)addURLKey:(NSString*)key value:(NSString*)value;

//对字符串的DES加密和解密（原始值必须是字符串）
- (NSString *)DES_EncryptWithKey:(NSString *)key8; 
- (NSString *)DES_DecryptWithKey:(NSString *)key8; 

//获取符合key的字符串
- (NSString *)getStringFromCharacterSet:(NSString*)characterSet;

//获取纯数字
- (NSString *)getNumberString;

//获取int
- (NSString *)getIntString;

//获取float
- (NSString *)getFloatString;

//是否是中文标点
- (BOOL)isChineseSymbol;

//恢复回车换行符号（从配置文件读取会在换行符号前增加一个"\n"）
- (NSString *)restoreEnterSymbol;

//删除换行字符
- (NSString *)removeEnterSymbol;

//解析格式为r,g,b,alpha为相应的颜色，例如255,255,255,1--至少要rgb值存在才能解析
- (UIColor *)getColor;

//解析URL键值（解析？号之后的URL部分）
- (NSString *)getValueFromURLForKey:(NSString *)key;

- (TransitionDirection)directionFromLeftValue;
- (TransitionDirection)directionFromRightValue;

//判断一个路径是否为文件
- (BOOL)isFile;

//格式输出数字每三位加个逗号（如果23,456,789）
- (NSString *)formatNumber;

//格式输出版本号只保留第一个小数点（如5.0.1-->5.01）
- (NSString *)formatVersion;

//是否为空字符串
- (BOOL)isEmpty;

@end

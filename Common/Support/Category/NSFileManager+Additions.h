//
//  NSFileManager+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager(Additions)

- (BOOL)isFileExists:(NSString *)path;
- (BOOL)isDirectoryExists:(NSString *)path;
- (BOOL)createDirectoryAtPath:(NSString *)directory;
- (BOOL)isEmptyDirectoryAtPath:(NSString *)directory;

@end

//
//  NSFileManager+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "NSFileManager+Additions.h"

@implementation NSFileManager(Additions)

- (BOOL)isFileExists:(NSString *)path
{
    BOOL isDirectory = NO;
    if ([self fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDirectoryExists:(NSString *)path
{
    BOOL isDirectory = NO;
    if ([self fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        return YES;
    }
    
    return NO; 
}

- (BOOL)createDirectoryAtPath:(NSString *)directory
{
    if (![self isDirectoryExists:directory]) {
        return [self createDirectoryAtPath:directory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}

- (BOOL)isEmptyDirectoryAtPath:(NSString *)directory
{
    if ([self isDirectoryExists:directory]) {
        NSArray *array = [self contentsOfDirectoryAtPath:directory error:nil];
        for (NSString *item in array) {
            if (![item hasPrefix:@"."]) {
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

@end

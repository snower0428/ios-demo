//
//  PlistPathManager.m
//  CommDemo
//
//  Created by leihui on 12-10-18.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "PlistPathManager.h"

@implementation PlistPathManager

+ (NSString *)documentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
	return directory;
}

+ (NSString *)libraryDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,YES);
    NSString *directory = [paths objectAtIndex:0];
	return directory;
}

+ (NSString *)tempDirectory
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
	return path;
}

+ (NSString *)babyCompletePlist
{
    return [RES_DIRECTORY stringByAppendingPathComponent:@"baby_complete.plist"];
}

+ (NSString *)faceCompletePlist
{
    return [RES_DIRECTORY stringByAppendingPathComponent:@"face.plist"];
}


+ (NSString *)hertCompletePlist
{
    return [RES_DIRECTORY stringByAppendingPathComponent:@"hert.plist"];
}

+ (NSString *)loadingViewPlist
{
    return [RES_DIRECTORY stringByAppendingPathComponent:@"loading_view.plist"];
}

@end

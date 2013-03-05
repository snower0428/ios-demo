//
//  PlistPathManager.h
//  CommDemo
//
//  Created by leihui on 12-10-18.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommDefines.h"

@interface PlistPathManager : NSObject

+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)tempDirectory;

@end

//
//  UIButton+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(Additions)

- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block;

+ (id)buttonWithNormalFile:(NSString *)normalFile;
+ (id)buttonWithNormalFile:(NSString *)normalFile downFile:(NSString *)downFile;
+ (id)buttonWithNormalFile:(NSString *)normalFile downFile:(NSString *)downFile disableFile:(NSString *)disableFile;

+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile;
+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile downFile:(NSString *)downFile;
+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile downFile:(NSString *)downFile disableFile:(NSString *)disableFile;

@end

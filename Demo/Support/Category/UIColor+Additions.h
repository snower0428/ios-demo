//
//  UIColor+Additions.h
//  Demo
//
//  Created by 晖 雷 on 13-1-25.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(Additions)

- (CGColorSpaceModel)colorSpaceModel;
- (NSString *)colorSpaceString;
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

@end

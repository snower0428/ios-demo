//
//  UIImageView+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView(Additions)

+ (id)imageViewWithFile:(NSString *)file;
+ (id)imageViewWithFile:(NSString *)file atPostion:(CGPoint)position;

@end

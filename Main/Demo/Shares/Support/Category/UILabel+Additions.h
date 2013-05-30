//
//  UILabel+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(Additions)

- (CGSize)ajustFrame;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor *)color;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor *)color alignment:(UITextAlignment)alignment;

@end

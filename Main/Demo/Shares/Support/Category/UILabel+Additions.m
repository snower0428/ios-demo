//
//  UILabel+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel(Additions)

- (CGSize)ajustFrame
{
    CGRect frame = self.frame;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, frame.size.height)];
    frame.size = size;
    self.frame = frame;
    
    return size;
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame
{
    return [self labelWithName:name font:font frame:frame color:nil];
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor *)color
{
    return [self labelWithName:name font:font frame:frame color:color alignment:UITextAlignmentLeft];
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor *)color alignment:(UITextAlignment)alignment
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = name;
    if (color != nil) {
        label.textColor = color;
    }
    label.textAlignment = alignment;
    
    return label;
}

@end

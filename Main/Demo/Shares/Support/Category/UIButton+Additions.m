//
//  UIButton+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIButton+Additions.h"
#import <objc/runtime.h>

static NSString *KEY_UIBUTTON_BLOCK = @"UIBUTTON_BLOCK_KEY";

@implementation UIButton(Additions)

- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block
{
    objc_setAssociatedObject(self, KEY_UIBUTTON_BLOCK, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(invokeBlock) forControlEvents:controlEvents];
}

- (void)invokeBlock
{
    ButtonBlock block = objc_getAssociatedObject(self, KEY_UIBUTTON_BLOCK);
    if (block) {
        block();
    }
}

+ (id)buttonWithNormalFile:(NSString *)normalFile
{
    return [self buttonWithNormalFile:normalFile downFile:nil disableFile:nil];
}

+ (id)buttonWithNormalFile:(NSString *)normalFile downFile:(NSString *)downFile
{
    return [self buttonWithNormalFile:normalFile downFile:downFile disableFile:nil];
}

+ (id)buttonWithNormalFile:(NSString *)normalFile downFile:(NSString *)downFile disableFile:(NSString *)disableFile
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalFile) {
        UIImage *image = [UIImage imageFile:normalFile];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        }
    }
    if (downFile) {
        UIImage *image = [UIImage imageFile:downFile];
        if (image) {
            [btn setImage:image forState:UIControlStateHighlighted];
            if (nil == normalFile) {
                [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            }
        }
    }
    if (disableFile) {
        UIImage *image = [UIImage imageFile:disableFile];
        if (image) {
            [btn setImage:image forState:UIControlStateDisabled];
        }
    }
    
    return btn;
}

+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile
{
    return [self buttonWithBackgroundNormalFile:normalFile downFile:nil disableFile:nil];
}

+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile downFile:(NSString *)downFile
{
    return [self buttonWithBackgroundNormalFile:normalFile downFile:downFile disableFile:nil];
}

+ (id)buttonWithBackgroundNormalFile:(NSString *)normalFile downFile:(NSString *)downFile disableFile:(NSString *)disableFile
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalFile) {
        UIImage *image = [UIImage imageFile:normalFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        }
    }
    if (downFile) {
        UIImage *image = [UIImage imageFile:downFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            if (nil == normalFile) {
                [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            }
        }
    }
    if (disableFile) {
        UIImage *image = [UIImage imageFile:disableFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateDisabled];
        }
    }
    
    return btn;
}

@end

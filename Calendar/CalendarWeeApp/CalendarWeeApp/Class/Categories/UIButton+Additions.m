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

@end

//
//  UIButton+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ButtonBlock)(void);

@interface UIButton(Additions)

- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block;

@end

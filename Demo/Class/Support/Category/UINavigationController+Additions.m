//
//  UINavigationController+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UINavigationController+Additions.h"

@implementation UINavigationController(Additions)

- (UIViewController *)rootViewController
{
    NSArray *viewControllers = [self viewControllers];
    if ([viewControllers count] > 0) {
        return [viewControllers objectAtIndex:0];
    }
    return nil;
}

@end

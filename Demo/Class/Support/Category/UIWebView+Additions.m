//
//  UIWebView+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIWebView+Additions.h"

@implementation UIWebView(Additions)

- (void)setTransparentBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    // Modified by lh 2012/07/13
    // 在4.2.1会崩溃
    NSArray *array = [NSArray arrayWithArray:[self subviews]];
    if ([array count] > 0) {
        UIScrollView *scrollView = (UIScrollView *)[array objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        for (UIView *subView in scrollView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                subView.hidden = YES;
            }
        }
    }
    //    UIScrollView *scrollView = [self scrollView];
    //    for (UIView *subView in scrollView.subviews) {
    //        if ([subView isKindOfClass:[UIImageView class]]) {
    //            subView.hidden = YES;
    //        }
    //    }
}

@end

//
//  UIScrollView+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIScrollView+Additions.h"

@implementation UIScrollView(Additions)

- (int)currentPage
{
    float scrollWidth = self.frame.size.width;
    int currentPage = floor((self.contentOffset.x - scrollWidth/2) / scrollWidth) + 1;
    return currentPage;
}

@end

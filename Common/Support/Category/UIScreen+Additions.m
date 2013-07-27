//
//  UIScreen+Additions.m
//  Demo
//
//  Created by lei hui on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIScreen+Additions.h"

@implementation UIScreen(Additions)

- (BOOL)isRetina
{
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		float scale = [[UIScreen mainScreen] scale];
		return (scale == 2.0);
	} else {
		return NO;
	}
}

@end

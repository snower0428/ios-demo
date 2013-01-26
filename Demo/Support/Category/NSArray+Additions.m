//
//  NSArray+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray(Additions)

- (NSArray *)getImages:(NSString *)resDirectory
{
	NSMutableArray *images = [NSMutableArray array];
	
	for (NSString *item in self) {
		NSString *path = [resDirectory stringByAppendingPathComponent:item];
		UIImage *image = [[UIImage alloc] initWithContentsOfFileEx:path];
		if (image) {
			[images addObject:image];
			[image release];
		} else {
			WriteLog(@"images- ========%@",path);
		}
	}
	
	if ([images count] > 0) {
		return images;
	} else {
		return nil;
	}
}

@end

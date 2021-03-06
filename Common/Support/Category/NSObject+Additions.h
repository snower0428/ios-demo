//
//  NSObject+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Additions)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

@end

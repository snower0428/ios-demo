//
//  NSObject+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject(Additions)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{ 
    NSMethodSignature *signature = [self methodSignatureForSelector:selector]; 
    if (signature) { 
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature]; 
        [invocation setTarget:self]; 
        [invocation setSelector:selector]; 
        for(int i = 0; i < [objects count]; i++){ 
            id object = [objects objectAtIndex:i]; 
            [invocation setArgument:&object atIndex: (i + 2)];        
        } 
        [invocation invoke]; 
        
        if (signature.methodReturnLength) { 
            id anObject; 
            [invocation getReturnValue:&anObject]; 
            return anObject; 
        }
    } 
    
    return nil;
} 

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [[block copy] autorelease];
    [self performSelector:@selector(invokeBlock:) withObject:block afterDelay:delay];
}

- (void)invokeBlock:(void(^)(void))block
{
    if (block) {
        block();
    }
}

@end

//
//  TimerManager.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-20.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimerManager : NSObject {
	NSMutableArray	*m_targetSets;//目标集合
	NSTimer			*m_timer;
}

+ (TimerManager*)sharedInstance;
+ (void)exitInstance;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;
- (void)removeAllTarget;

@end

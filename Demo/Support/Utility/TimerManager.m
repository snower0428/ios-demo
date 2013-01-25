//
//  TimerManager.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-20.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "TimerManager.h"

static TimerManager *kInstance = nil;


@implementation TimerManager

+ (TimerManager*)sharedInstance{
	@synchronized(self){
		if (nil == kInstance){
			kInstance = [[TimerManager alloc] init];
		}
	}
	
	return kInstance;
}

+ (void)exitInstance{
	@synchronized(self){
		if (nil != kInstance){
			[kInstance release];
			kInstance = nil;
		}
	}
}

- (void)addTarget:(id)target{
	if (nil == m_targetSets) {
		m_targetSets = [[NSMutableArray alloc] init];
	}
	if (![m_targetSets containsObject:target]) {
		[m_targetSets addObject:target];
	}
	if (nil == m_timer) {
		m_timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
	}
}


- (void)removeTarget:(id)target{
	if (target && m_targetSets) {
		[m_targetSets removeObject:target];
		
		if ([m_targetSets count] == 0) {
			[m_timer invalidate];
			m_timer = nil;
			
			[m_targetSets release];
			m_targetSets = nil;
		}
	}
}

- (void)removeAllTarget{
	[m_timer invalidate];
	m_timer = nil;
	
	[m_targetSets release];
	m_targetSets = nil;
}

- (void)updateTimer:(NSTimer*)timer{
	//double t1 = CFAbsoluteTimeGetCurrent();
	for (id target in m_targetSets) {
		if ([target respondsToSelector:@selector(updateTimer:)]) {
			[target performSelector:@selector(updateTimer:) withObject:timer];
		}
	}
	
	//double t2 = CFAbsoluteTimeGetCurrent();
	//NSLog(@"t2-t1:%f", t2-t1);
}


- (void)dealloc{
	[self removeAllTarget];
	[super dealloc];
}

@end

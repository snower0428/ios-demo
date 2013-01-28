//
//  AudioView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-1-21.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "AudioView.h"


@implementation AudioView

@synthesize audio = m_audio;
@synthesize clickRect = m_clickRect;


- (id)initWithFrame:(CGRect)frame audioPath:(NSString*)path{
	if (self = [super initWithFrame:frame]){
		m_audioPath = [path retain];
		m_audio = [[BBAudioPlayer alloc] initWithContentsOfFile:m_audioPath];
		
		self.backgroundColor = [UIColor clearColor];
		m_clickRect = frame;
	}
	
	return self;
}


- (void)play{
	if ([self isPlaying]) {
		[self stop];
	}
	
	m_audio = [[BBAudioPlayer alloc] initWithContentsOfFile:m_audioPath];
	[m_audio play];
}

- (void)pause{
	if ([self isPlaying]) {
		[m_audio stop];
	}
}

- (void)stop{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	if ([self isPlaying]) {
		[m_audio stop];
	}
	[m_audio setCurrentTime:0];
}

- (BOOL)isPlaying{
	return [m_audio isPlaying];
}


- (void)dealloc {
	[m_audioPath release];
	[self stop];
	[m_audio release];   
    [super dealloc];
}


@end

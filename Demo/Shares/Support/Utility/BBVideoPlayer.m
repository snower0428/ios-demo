//
//  BBVideoPlayer.m
//  Video
//
//  Created by zhangtianfu on 11-10-13.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BBVideoPlayer.h"


@implementation BBVideoPlayer

@synthesize moviePlayer = m_moviePlayer;
@synthesize playing = m_playing;
@synthesize isPause = m_isPause;

- (id)initWithContentsOfFile:(NSString*)path frame:(CGRect)frame delegate:(id)delegate{
	BOOL isDirectory = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
		[self release];
		return nil;
	}
	
	if (self = [super init]) {
		NSURL	*url = [NSURL fileURLWithPath:path];
		
		//moviePlayer
        m_playing = NO;
		m_moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
		m_moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
#if		defined(TARGET_IPAD)
		m_moviePlayer.view.frame = frame;
		m_moviePlayer.controlStyle = MPMovieControlStyleNone;
#endif
		[self prepareToPlay];
		
		//delegate
		m_delegate = delegate;
        
		//监听
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(moviePlayerPlaybackDidFinish:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(durationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
	}
	
	return self;
}

// 解锁屏幕
- (void)becomeActive:(NSNotification*)notify
{
    if (m_isPause) {
        [m_moviePlayer setCurrentPlaybackTime:m_currentInterval];
        NSLog(@"currentPlaybackTime = %f, duration = %f", [m_moviePlayer currentPlaybackTime], [m_moviePlayer duration]);
//        [m_moviePlayer setInitialPlaybackTime:m_currentInterval];
        [self play];
    }
}

// 锁定屏幕
- (void)resignActive:(NSNotification*)notify
{
    if (m_playing) {
        [self pause];
        m_currentInterval = [m_moviePlayer currentPlaybackTime];
    }
}

//- (void)durationAvailable:(NSNotification *)notification
//{
//    NSLog(@"durationAvailable...");
//}

- (void)moviePlayerPlaybackDidFinish:(NSNotification*)aNotification
{
    m_playing = NO;
	if (m_delegate && [m_delegate respondsToSelector:@selector(BBVideoPlayerDidStop:)]) {
		[m_delegate BBVideoPlayerDidStop:self];
	}
}

- (void)showOnView:(UIView*)container
{
#if		defined(TARGET_IPAD)
	if (m_moviePlayer && ![[m_moviePlayer view] superview]) {
		[container addSubview:[m_moviePlayer view]];
	}
#endif
}

- (void)prepareToPlay
{
#if		defined(TARGET_IPAD)
	if (![m_moviePlayer isPreparedToPlay]) {
		[m_moviePlayer prepareToPlay];
	}
#endif
}

- (void)play
{
    m_playing = YES;
    m_isPause = NO;
	[m_moviePlayer play];
}

- (void)pause
{
#if defined(TARGET_IPAD)
    m_isPause = YES;
	[m_moviePlayer pause];
#endif
}

- (void)stop
{
    m_isPause = NO;
	[m_moviePlayer stop];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stop];
	[m_moviePlayer release];
	[super dealloc];
}

@end

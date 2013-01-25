//
//  BBAudioPlayer.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-28.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BBAudioPlayer.h"


@implementation BBAudioPlayer

@synthesize audioPlayer = m_audioPlayer;
@synthesize playCount = m_playCount;
@synthesize tag = m_tag;
@synthesize delegate = m_delegate;


- (id)initWithContentsOfFile:(NSString *)path{
	
	BOOL isDirectory = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
		[self release];
		return nil;
	}

	if (self = [super init]) {
		NSURL *url = [NSURL fileURLWithPath:path];
		m_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		m_audioPlayer.delegate = self;
		[m_audioPlayer prepareToPlay];
		
//        if ([[BookManager sharedInstance] readingMode] != ReadingModeRecord) {
//            //禁止锁屏后继续播放
//            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
//            [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        }
	}
	
	return self;
}


	//=============property===============
//	numberOfChannels
- (NSUInteger)numberOfChannels{
	return [m_audioPlayer numberOfChannels];
}

//	duration
- (NSTimeInterval)duration{
	return [m_audioPlayer duration];
}

//	volume
- (float)volume{
	return [m_audioPlayer volume];
}

- (void)setVolume:(float)v{
	if (m_audioPlayer) {
		[m_audioPlayer setVolume:v];
	}
}

//	currentTime
- (NSTimeInterval)currentTime{
	return [m_audioPlayer currentTime];
}

- (void)setCurrentTime:(NSTimeInterval)i{
	if (m_audioPlayer) {
		[m_audioPlayer setCurrentTime:i];
	}
}

//	numberOfLoops
- (NSInteger)numberOfLoops{
	return [m_audioPlayer numberOfLoops];
}

- (void)setNumberOfLoops:(NSInteger)i{
	if (m_audioPlayer) {
		[m_audioPlayer setNumberOfLoops:i];
	}
}

 

//=============function===============

//- (BOOL)prepareToPlay{
//	return [m_audioPlayer prepareToPlay];
//}

- (BOOL)play{
	return [m_audioPlayer play];
}

- (BOOL)isPlaying{
	return [m_audioPlayer isPlaying];
}

- (void)pause{
	[m_audioPlayer pause];
}

- (void)stop{
	[m_audioPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	if (flag) {
		m_playCount++;
		
		if (m_delegate && [m_delegate respondsToSelector:@selector(BBAudioPlayerDidFinishPlaying:)]) {
			[m_delegate BBAudioPlayerDidFinishPlaying:self];
		}
	}
}

- (void)dealloc{
	if (m_audioPlayer) {
		[self stop];
		[m_audioPlayer setDelegate:nil];
		[m_audioPlayer release];
	}
	
	[super dealloc];
}

@end

//
//  BBAudioRecorder.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-28.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BBAudioRecorder.h"


@implementation BBAudioRecorder

@synthesize audioRecorder = m_audioRecorder;
@synthesize delegate = m_delegate;

- (id)initWithContentsOfFile:(NSString *)path{
	if (self = [super init]) {
		[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
		[[AVAudioSession sharedInstance] setActive:YES error:nil];
		
		NSDictionary *recordSettings =[[NSDictionary alloc] initWithObjectsAndKeys:
									   [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
									   [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
									   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
									   [NSNumber numberWithInt: AVAudioQualityMax],
									   AVEncoderAudioQualityKey,nil];
		
		NSURL *fileURL=[[NSURL alloc]initFileURLWithPath:path];
		m_audioRecorder=[[AVAudioRecorder alloc]initWithURL:fileURL settings:recordSettings error:nil];
		m_audioRecorder.delegate = self;
		[m_audioRecorder recordForDuration:DERUATION_FOR_RECORD];
        [fileURL release];
		
		[recordSettings release];
	}
	
	return self;  
}

- (BOOL)record{
	[m_audioRecorder prepareToRecord];
	return [m_audioRecorder record];
}

- (BOOL)isRecording{
	return [m_audioRecorder isRecording];
}

- (void)pause{
	[m_audioRecorder pause];
}

- (void)stop{
	[m_audioRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
	if (m_delegate && [m_delegate respondsToSelector:@selector(BBAudioRecorderDidFinishRecording:successfully:)]) {
		[m_delegate BBAudioRecorderDidFinishRecording:self successfully:flag];
	}
}


- (void)dealloc{
	if (m_audioRecorder) {
		[self stop];
		[m_audioRecorder setDelegate:nil];
		[m_audioRecorder release];
	}
	
	[super dealloc];
}

@end

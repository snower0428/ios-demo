//
//  BBAudioRecorder.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-28.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioRecorder.h>

@protocol BBAudioRecorderDelegate;

@interface BBAudioRecorder : NSObject<AVAudioRecorderDelegate> {
	AVAudioRecorder					*m_audioRecorder;
	id<BBAudioRecorderDelegate>	m_delegate;
}

@property(nonatomic, assign)	id<BBAudioRecorderDelegate> delegate;
@property(nonatomic, retain)	AVAudioRecorder				*audioRecorder;

- (id)initWithContentsOfFile:(NSString *)path;

- (BOOL)record;
- (BOOL)isRecording;
- (void)pause;
- (void)stop;

@end

@protocol BBAudioRecorderDelegate <NSObject>
- (void)BBAudioRecorderDidFinishRecording:(BBAudioRecorder *)player successfully:(BOOL)flag;
@end

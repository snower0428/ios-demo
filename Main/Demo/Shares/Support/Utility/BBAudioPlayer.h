//
//  BBAudioPlayer.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-6-28.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@protocol BBAudioPlayerDelegate;


@interface BBAudioPlayer : NSObject<AVAudioPlayerDelegate>{
	AVAudioPlayer	*m_audioPlayer;
	int				m_playCount;
	int				m_tag;
	
	id<BBAudioPlayerDelegate> m_delegate;
}

@property(nonatomic, assign)	id<BBAudioPlayerDelegate> delegate;
@property(nonatomic, retain)	AVAudioPlayer				*audioPlayer;
@property(nonatomic, assign)	int							playCount;
@property(nonatomic, assign)	int							tag;

@property(readonly, getter=isPlaying) BOOL playing;
@property(readonly) NSUInteger numberOfChannels;
@property(readonly) NSTimeInterval duration; 
@property float volume; 
@property NSTimeInterval currentTime;
@property NSInteger numberOfLoops;

- (id)initWithContentsOfFile:(NSString *)path;

//- (BOOL)prepareToPlay;
- (BOOL)play;
- (void)pause;			
- (void)stop;

@end


@protocol BBAudioPlayerDelegate <NSObject>
- (void)BBAudioPlayerDidFinishPlaying:(BBAudioPlayer *)player;
@end

//
//  SoundEffect.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-11-25.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "SoundEffect.h"

static SoundEffect *kInstance = nil;


@implementation SoundEffect

+ (SoundEffect*)sharedInstance{
	@synchronized(self){
		if (nil == kInstance){
			kInstance = [[SoundEffect alloc] init];
		}
	}
	
	return kInstance;
}

+ (void)exitInstance{
	@synchronized(self){
		if (nil != kInstance){
			[kInstance stopSound:nil];
			[kInstance release];
			kInstance = nil;
		}
	}
}

- (id)init{
	if (self = [super init]) {
		NSString *path = [RES_DIRECTORY stringByAppendingPathComponent:@"sound.plist"];
		m_soundEffectSource = [[PlistParser dictionaryWithContentsOfFile:path key:AES_KEY] retain];
		m_soundEffectPlayers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)preloadSound:(NSString*)key{
    [self preloadSound:key source:m_soundEffectSource resDirectory:RES_DIRECTORY];
}

- (void)preloadSound:(NSString *)key source:(NSDictionary*)audiosSource resDirectory:(NSString*)resDirectory{
    BBAudioPlayer *player = [m_soundEffectPlayers objectForKey:key];
	if (nil == player) {
		NSString *soundName = [audiosSource objectForKey:key];
		NSString *soundPath = [resDirectory stringByAppendingPathComponent:soundName];
		if ([soundPath isFile]) {
			player = [[BBAudioPlayer alloc] initWithContentsOfFile:soundPath];
			[m_soundEffectPlayers setValue:player forKey:key];
			[player release];
		}
	}
}

- (void)playSound:(NSString*)key{
	[self playSound:key source:m_soundEffectSource resDirectory:RES_DIRECTORY];
}


- (void)playSound:(NSString *)key source:(NSDictionary*)audiosSource resDirectory:(NSString*)resDirectory{
	BBAudioPlayer *player = [m_soundEffectPlayers objectForKey:key];
	if (nil == player) {
		NSString *soundName = [audiosSource objectForKey:key];
		NSString *soundPath = [resDirectory stringByAppendingPathComponent:soundName];
		if ([soundPath isFile]) {
			player = [[BBAudioPlayer alloc] initWithContentsOfFile:soundPath];
			[m_soundEffectPlayers setValue:player forKey:key];
			[player release];
		}
	}else {
		[player stop];
	}
	
    [player setCurrentTime:0];
	[player play];
}

- (void)stopSound:(NSString*)key{
	if (key) {
		BBAudioPlayer *player = [m_soundEffectPlayers objectForKey:key];
		if (player) {
			[player stop];
		}
	}else {
		for (BBAudioPlayer *player in [m_soundEffectPlayers allValues]) {
			[player stop];
		}
	}
}

//将声音移除
- (void)removeSound:(NSString*)key{
	if (key) {
		BBAudioPlayer *player = [m_soundEffectPlayers objectForKey:key];
		if (player) {
			[player stop];
			[m_soundEffectPlayers removeObjectForKey:key];
		}
	}else {
		for (BBAudioPlayer *player in [m_soundEffectPlayers allValues]) {
			[player stop];
		}
		
		[m_soundEffectPlayers removeAllObjects];
	}
}

- (void)dealloc{
	[self stopSound:nil];
	[m_soundEffectPlayers release];
	[m_soundEffectSource release];
	[super dealloc];
}

@end

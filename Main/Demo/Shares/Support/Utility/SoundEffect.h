//
//  SoundEffect.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-11-25.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SoundEffect : NSObject {
	NSDictionary			*m_soundEffectSource;
	NSMutableDictionary		*m_soundEffectPlayers;
}

+ (SoundEffect*)sharedInstance;
+ (void)exitInstance;

    //预加载音效
- (void)preloadSound:(NSString*)key;
- (void)preloadSound:(NSString *)key source:(NSDictionary*)audiosSource resDirectory:(NSString*)resDirectory;

	//播放key对应的音效
- (void)playSound:(NSString*)key;

	//根据传入资源的播放key对应的音效
- (void)playSound:(NSString *)key source:(NSDictionary*)audiosSource resDirectory:(NSString*)resDirectory;

	//停止key对应的音效
- (void)stopSound:(NSString*)key;

	//将声音移除
- (void)removeSound:(NSString*)key;

@end

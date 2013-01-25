//
//  DialogView.h
//  Maze
//
//  Created by zhangtianfu on 11-2-10.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DialogView : UIView <BBAudioPlayerDelegate>{
	id				m_target;
	NSString		*m_resDirectory;
	NSDictionary	*m_dialogInfo;
	NSMutableArray	*m_layers;
	NSMutableArray	*m_languageLayers;
	BBAudioPlayer	*m_dialogAudioPlayer;
	LanguageType	m_languageType;
	
	NSMutableArray	*m_audiosArray;
	int				m_audioIndex;
	UIView			*m_containerView;
	
	AnimationView	*m_reward;
	int				m_currentRewardIndex;
	int				m_rewardNumber;
}

@property(nonatomic, readonly)	BBAudioPlayer				*audioPlayer;

- (id)initWithFrame:(CGRect)frame dialogInfo:(NSDictionary*)dialogInfo  resDirectory:(NSString*)resDirectory target:(id)target language:(LanguageType)type;

// 启动对话框：是否有显示特效，是否有播放声音，延时多少秒
- (void)showAnimation:(BOOL)animated play:(BOOL)play afterDelay:(NSTimeInterval)interval;
- (void)stopAnimation;

- (void)initLayers;
- (void)addLayers:(NSArray*)layers;
- (void)stopAudio;
- (void)playAudio;
- (void)pauseAudio;
- (NSArray*)subItems;

@end

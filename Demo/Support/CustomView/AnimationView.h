//
//  AnimationView.h
//
//  Created by zhangtianfu on 11-11-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnimationView : UIView {
	NSTimer		*m_timer;
	
	/*-----------animation-------------*/
	UIImageView	*m_animationView;
	UIImage		*m_animationOriginImage;
	NSArray		*m_animationImages;
	
	NSInteger		m_animationImageIndex;
	NSInteger		m_animationCycleCount;
	NSInteger		m_animationCycleIndex;
	NSInteger		m_animationCycleAnimatingCount;
	NSTimeInterval	m_animationCycleAnimatingDuration;
	NSTimeInterval	m_animationCycleSleepDuration;
	NSTimeInterval	m_animationTotalDuration;
	
	NSInteger		m_tempAnimatingCount;
	NSTimeInterval	m_tempSleepDuration;
	
	BOOL		m_setLastFrameAfterAnimating;
	NSInteger	m_performCount;
	
	/*-----------sound---------------*/
	BBAudioPlayer	*m_audioPlayer;
	NSMutableArray	*m_audioPlayers;
	NSArray			*m_soundEffectSouces;
	BOOL			m_enableSoundEffect;
	
	
	/*-----------delegate-------------*/
	//start
	id				m_startTarget;
	SEL				m_startSelector;
	id				m_startContext;
	//change
	id				m_changeTarget;
	SEL				m_changeSelector;
	id				m_changeContext;
	//stop
	id				m_stopTarget;
	SEL				m_stopSelector;
	id				m_stopContext;
	
	/*---------others(used by external)----*/
	CGRect			m_clickRect;
	BOOL			m_autoStart;
	NSTimeInterval	m_autoStartDelayTime;
}


@property (nonatomic,retain)	UIImage			*animationOriginImage;			//动画默认显示图片
@property (nonatomic,retain)	NSArray			*animationImages;				//动画图片集合
@property (nonatomic,readonly)	NSInteger		animationImageIndex;			//当前指向的图片索引（-1为默认图）
@property (nonatomic,readonly)	NSInteger		animationCycleIndex;			//当前指向的周期索引
@property (nonatomic)			NSInteger		animationCycleCount;			//动画播放的周期总数（默认是最大值，一直播放）
@property (nonatomic)			NSInteger		animationCycleAnimatingCount;	//一个周期内动画播放的次数（默认是1）
@property (nonatomic)			NSTimeInterval	animationCycleAnimatingDuration;//动画播放一次的时间（播放一套图片的时间）
@property (nonatomic)			NSTimeInterval	animationCycleSleepDuration;	//一个周期内动画休息时间
@property (nonatomic,readonly)	NSTimeInterval	animationTotalDuration;			//动画播放的总时间
@property (nonatomic)			BOOL			setLastFrameAfterAnimating;		//是否播放结束设置为最后一帧
@property (nonatomic)			NSInteger		performCount;					//动画执行的次数（默认是无数次）

@property (nonatomic,retain)	NSArray			*soundEffectSouces;				//动画音效资源路径集合

@property (nonatomic)			CGRect			clickRect;					//响应动画的点击区域
@property (nonatomic)			BOOL			autoStart;					//动画是否自动启动
@property (nonatomic)			NSTimeInterval	autoStartDelayTime;			//动画自动启动的延迟时间间隔


- (void)startAnimating;
- (void)startAnimatingWithoutAudio;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (void)setStartSelector:(SEL)selector target:(id)target context:(id)context;//设置动画启动响应的代理和方法
- (void)setChangeSelector:(SEL)selector target:(id)target context:(id)context;//设置帧改变时响应的代理和方法
- (void)setStopSelector:(SEL)selector target:(id)target context:(id)context;//设置动画结束响应的代理和方法


@end





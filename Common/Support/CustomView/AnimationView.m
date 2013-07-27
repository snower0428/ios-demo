//
//  AnimationView.m
//
//  Created by zhangtianfu on 11-11-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView(privateMethods)
- (void)playAnimating;
- (void)playSoundEffect;
- (void)stopSoundEffect;

- (void)setImageAtIndex:(NSInteger)index;
@end



@implementation AnimationView


@synthesize		animationOriginImage = m_animationOriginImage;
@synthesize		animationImages = m_animationImages;
@synthesize		animationImageIndex = m_animationImageIndex;
@synthesize		animationCycleIndex = m_animationCycleIndex;
@synthesize		animationCycleCount = m_animationCycleCount;
@synthesize		animationCycleAnimatingCount = m_animationCycleAnimatingCount;
@synthesize		animationCycleAnimatingDuration = m_animationCycleAnimatingDuration;
@synthesize		animationCycleSleepDuration = m_animationCycleSleepDuration;
@synthesize		animationTotalDuration = m_animationTotalDuration;		
@synthesize		setLastFrameAfterAnimating = m_setLastFrameAfterAnimating;
@synthesize		performCount = m_performCount;

@synthesize		soundEffectSouces = m_soundEffectSouces;

@synthesize		clickRect = m_clickRect;
@synthesize		autoStart = m_autoStart;					
@synthesize		autoStartDelayTime = m_autoStartDelayTime;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        m_animationView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:m_animationView];
		[m_animationView release];
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;

		m_animationImageIndex = -1;
		m_animationCycleIndex = -1;
		m_animationCycleAnimatingCount = 1;
		m_animationCycleSleepDuration = 0;
		m_animationCycleCount = NSIntegerMax;//默认无限周期
		
		m_tempAnimatingCount = 0;
		m_tempSleepDuration = 0;

		m_setLastFrameAfterAnimating = NO;
		m_performCount = NSIntegerMax;
		
		m_enableSoundEffect = YES;
		
		[m_animationView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
											 |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin
											 |UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return self;
}


- (id)initwithImage:(UIImage*)image{
	CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	if (self = [self initWithFrame:frame]) {
		m_animationView.image = image;
		m_animationOriginImage = [image retain];
	}
	return self;
}


#pragma mark ---------------set Property-------------------

- (void)setAnimationOriginImage:(UIImage *)image{
	if (m_animationOriginImage != image) {
		[m_animationOriginImage release];
		m_animationOriginImage = [image retain];
	}
	
	if (m_animationView.image != image)
	{
		m_animationView.image = image;
	}
}

- (void)setPerformCount:(NSInteger)performCount{
	m_performCount = performCount;
	if (m_performCount < 0) {
		m_performCount = NSIntegerMax;
	}
}

- (void)setAnimationCycleCount:(NSInteger)count{
	m_animationCycleCount = count;
	if (m_animationCycleCount <1) {
		m_animationCycleCount = NSIntegerMax;
	}
}

- (void)setAnimationCycleAnimatingCount:(NSInteger)count{
	m_animationCycleAnimatingCount = count;
	if (m_animationCycleAnimatingCount<1) {
		m_animationCycleAnimatingCount = 1;
	}
}

- (void)setSoundEffectSouces:(NSArray *)source{
	if (m_soundEffectSouces != source) {
		[m_soundEffectSouces release];
		m_soundEffectSouces = [source retain];
		
		int count = [m_soundEffectSouces count];
		for (int i=0; i<count; i++) {
			NSString *path = [m_soundEffectSouces objectAtIndex:i];
			BOOL isDirectory = YES;
			if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory){
				BBAudioPlayer *audioPlayer = [[BBAudioPlayer alloc] initWithContentsOfFile:path];
				if (nil == m_audioPlayers) {
					m_audioPlayers = [[NSMutableArray arrayWithObject:audioPlayer] retain];
				}else {
					[m_audioPlayers addObject:audioPlayer];
				}
				[audioPlayer release];
			}
		}
	}
}

- (NSTimeInterval)animationTotalDuration{
	int count = [m_animationImages count];
	if (count == 0) {
		return 0;
	}
	
	if (m_animationCycleCount==0 || m_animationCycleCount== NSIntegerMax) {
		return -1;
	}
	
	NSTimeInterval cycleAnimatingDuration = (m_animationCycleAnimatingDuration==0? count/30.0f : m_animationCycleAnimatingDuration);
	NSTimeInterval cycleTime = ((cycleAnimatingDuration+m_animationCycleSleepDuration)*m_animationCycleAnimatingCount)*m_animationCycleCount;
	return (cycleTime-m_animationCycleSleepDuration);//忽略最后一个休息时间
}


#pragma mark ---------------anmation-------------------

- (void)startAnimating{
	//执行次数不足一次
	if (m_performCount < 1) {
		return;
	}
	m_performCount--;
	
	//animating
	[self playAnimating];
	//sound
	m_enableSoundEffect = YES;
	[self playSoundEffect];
}

- (void)startAnimatingWithoutAudio{
	//执行次数不足一次
	if (m_performCount < 1) {
		return;
	}
	m_performCount--;
	
	//animating
	[self playAnimating];
	//sound
	m_enableSoundEffect = NO;
}

- (void)playAnimating{
	if (m_timer != nil) {
		return;
	}
	
	int count = [m_animationImages count];
	if (count == 0) {
		return;
	}
	
	m_animationCycleIndex = 0;
	m_animationImageIndex = 0;
	
	m_tempAnimatingCount = 0;
	m_tempSleepDuration = 0;
	
	if (m_animationCycleAnimatingDuration == 0) {
		m_animationCycleAnimatingDuration = count/30.0f;
	}
	
	//开始第一帧
	[self setImageAtIndex:0];
	
	//启动定时器继续播放下一帧
	NSTimeInterval frameTime = m_animationCycleAnimatingDuration/count;
	m_timer = [[NSTimer scheduledTimerWithTimeInterval:frameTime target:self selector:@selector(update:) userInfo:nil repeats:YES] retain];
	
	//通知代理动画开始
	if (m_startTarget && m_startSelector ){
		[m_startTarget performSelector:m_startSelector withObject:m_startContext];
	}
}

- (void)stopAnimating{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	if (m_timer) {
		[m_timer invalidate];
		[m_timer release];
		m_timer = nil;
	}
	
	if (!m_setLastFrameAfterAnimating) {
		if (m_animationView.image != m_animationOriginImage) {
			m_animationView.image = m_animationOriginImage;
		}
	}
	

	[self stopSoundEffect];
	
	m_startSelector = nil;
	m_startTarget = nil;
	[m_startContext release];
	m_startContext = nil;
	
	m_changeSelector = nil;
	m_changeTarget = nil;
	[m_changeContext release];
	m_changeContext = nil;
	
	m_stopSelector = nil;
	m_stopTarget = nil;
	[m_stopContext release];
	m_stopContext = nil;
}

- (BOOL)isAnimating{
	return (m_timer != nil)||([m_audioPlayer isPlaying]);
}


- (void)setImageAtIndex:(NSInteger)index{
	int count = [m_animationImages count];
	if (index>=0 && index <count) {
		UIImage *image = [m_animationImages objectAtIndex:index];
		[m_animationView setImage:image];
	}
}

- (void)update:(NSTimer*)timer{
	int count = [m_animationImages count];
	int imageIndex = (m_animationImageIndex+1)%count;
	if (imageIndex==0 && m_tempSleepDuration==0) {
		m_tempAnimatingCount++;//图片播完一个循环了
	}

	//图片播完了一个周期的所有循环
	if (m_tempAnimatingCount == m_animationCycleAnimatingCount) {
		//动画播完所有周期
		if (m_animationCycleIndex >= m_animationCycleCount-1) {//忽略最后一个周期的睡眠时间
			m_animationImageIndex = -1;
			m_animationCycleIndex = -1;
			m_tempSleepDuration = 0;
			m_tempAnimatingCount = 0;
			
			[m_timer invalidate];
			[m_timer release];
			m_timer = nil;
			
			if (!m_setLastFrameAfterAnimating) {
				if (m_animationView.image != m_animationOriginImage) {
					m_animationView.image = m_animationOriginImage;
				}
			}
			
			if (m_stopTarget && m_stopSelector) {
				[m_stopTarget performSelector:m_stopSelector withObject:m_stopContext];
			}
			return;//动画停止
		}else {
			//一个周期内的动画次数都播放完毕则切换为默认图
			if (m_tempSleepDuration == 0 && !m_setLastFrameAfterAnimating) {
				if (m_animationView.image != m_animationOriginImage) {
					m_animationView.image = m_animationOriginImage;
				}
			}
			
			m_tempSleepDuration += [timer timeInterval];
			if (m_tempSleepDuration >= m_animationCycleSleepDuration) {
				m_tempSleepDuration = 0;
				m_tempAnimatingCount = 0;
				m_animationCycleIndex++;
				
				//如果是无限循环则循环播放音效
				if (m_animationCycleCount == NSIntegerMax) {
					[self playSoundEffect];
				}
			}else {
				return;//正在进入动画休息时间
			}
		}

	}

	//切换到下一帧
	m_animationImageIndex = (m_animationImageIndex+1)%count;
	[self setImageAtIndex:m_animationImageIndex];
	
	if (m_changeTarget && m_changeSelector) {
		[m_changeTarget performSelector:m_changeSelector withObject:m_changeContext];
	}
}

#pragma mark -------------- delegate-------------------
- (void)setStartSelector:(SEL)selector target:(id)target context:(id)context{
	m_startSelector = selector;
	m_startTarget = target;
	m_startContext = [context retain];
}

- (void)setChangeSelector:(SEL)selector target:(id)target context:(id)context{
	m_changeSelector = selector;
	m_changeTarget = target;
	m_changeContext = [context retain];
}

- (void)setStopSelector:(SEL)selector target:(id)target context:(id)context{
	m_stopSelector = selector;
	m_stopTarget = target;
	m_stopContext = [context retain];
}



#pragma mark ---------------sound fffect------------------

- (void)playSoundEffect{
	[self stopSoundEffect];
	
	int count = [m_audioPlayers count];
	if (count>0) {
		int index = [RandomExtention createRandomsizeValueInt:0 toInt:count-1];
		m_audioPlayer = [m_audioPlayers objectAtIndex:index];
//		m_audioPlayer.volume = [[BookManager sharedInstance] animationVolume];
		[m_audioPlayer play];
	}
}

- (void)stopSoundEffect{
	if (m_audioPlayer) {
		[m_audioPlayer stop];
		m_audioPlayer = nil;
	}
}

- (void)dealloc {
	[self stopAnimating];
	
	[m_animationOriginImage release];
	[m_animationImages release];
	[m_soundEffectSouces release];
	[m_audioPlayers release];
    [super dealloc];
}


@end

//
//  DialogView.mm
//  Maze
//
//  Created by zhangtianfu on 11-2-10.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "DialogView.h"
#import <QuartzCore/QuartzCore.h>

@interface DialogView(privateMethod)
- (void)startAnmimation;
- (void)initAudio:(NSNumber*)indexValue;
- (CGRect)getRandomFrame:(UIView *)view;
@end


@implementation DialogView

@synthesize audioPlayer = m_dialogAudioPlayer;

- (id)initWithFrame:(CGRect)frame dialogInfo:(NSDictionary*)dialogInfo  resDirectory:(NSString*)resDirectory target:(id)target language:(LanguageType)type{
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        m_target = target;
		m_resDirectory = [[NSString alloc] initWithString:resDirectory];
		m_dialogInfo = [[NSDictionary alloc] initWithDictionary:dialogInfo];
		m_languageType = type;
		m_audioIndex = 0;

		[self initLayers];
		
		if ([m_layers count] == 0 && [m_languageLayers count] == 0) {
			[self release];
			return nil;//解析失败
		}
		
		m_containerView = [[UIView alloc] initWithFrame:self.bounds];
		m_containerView.backgroundColor = [UIColor clearColor];
		[self addSubview:m_containerView];
		[m_containerView release];
		
		[self addLayers:m_layers];
		[self addLayers:m_languageLayers];
		
		NSDictionary *extention = [m_dialogInfo objectForKey:@"extention"];
		
		
		if (extention)
		{
			NSDictionary *reward = [extention objectForKey:@"reward"];
			if (reward)
			{
				m_rewardNumber = [[reward objectForKey:@"rewardNumber"] intValue];
				NSDictionary *animation = [reward objectForKey:@"animation"];
				m_reward = [[LayerParser parseLayerItem:animation resDirectory:m_resDirectory] retain];
				m_reward.frame = [self getRandomFrame:m_reward];
				[m_reward setStopSelector:@selector(animationDidFinished:) target:self context:nil];
				
				[m_containerView addSubview:m_reward];
			}
		}
    }
    return self;
}

	//	===================layers================
- (void)initLayers{
	m_audiosArray = [[NSMutableArray alloc] init];
	//	audios
	NSDictionary *audiosInfo = [m_dialogInfo objectForKey:@"audios"];
	if ([audiosInfo count]) {
		NSArray *audios = [audiosInfo getValueWithLanguageType:m_languageType];
		
		for (NSString *audioName in audios) {// audio
			NSString *audioPath = [m_resDirectory stringByAppendingPathComponent:audioName];
			if ([audioPath isFile]){
				[m_audiosArray addObject:audioPath];
			}
		}
	}else{
		// audio
		NSDictionary *audioInfo = [m_dialogInfo objectForKey:@"audio"];
		if ([audioInfo count]) {
			NSString *audioName = [audioInfo getValueWithLanguageType:m_languageType];
			NSString *audioPath = [m_resDirectory stringByAppendingPathComponent:audioName];
			if ([audioPath isFile]){
				[m_audiosArray addObject:audioPath];
			}
		}
	}
	[self initAudio:[NSNumber numberWithInt:0]];
	
	//layers
	NSArray *layersArray = [m_dialogInfo objectForKey:@"layers"];
	m_layers = [[LayerParser parseLayers:layersArray resDirectory:m_resDirectory] retain];
	
	//layersLanguage
	NSArray *layersArrayLanguage = [m_dialogInfo getLayersWithLanguageType:m_languageType];
	m_languageLayers = [[LayerParser parseLayers:layersArrayLanguage resDirectory:m_resDirectory] retain];
}

- (void)addLayers:(NSArray*)layers{
	for (id item in layers){
		if (item != (id)[NSNull null]){
			[m_containerView addSubview:item];
			
			//设置子view的相对坐标
			CGRect itemFrame = [item frame];
			itemFrame.origin.x -=self.frame.origin.x;
			itemFrame.origin.y-=self.frame.origin.y;
			[item setFrame:itemFrame];
		}
		
		if ([item isKindOfClass:[UIButton class]]){
			[(UIButton*)item addTarget:m_target action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		} else if ([item isKindOfClass:[SegmentView class]]) {
            [(SegmentView *)item addTarget:m_target action:@selector(clickSegment:)];
            
//            if ([item tag] == (int)ActionTypeCameraFaceType){
//				[(SegmentView*)item setAction:[BookManager sharedInstance].cameraFaceType];
//            }
        } else if ([item isKindOfClass:[MultiSwitchView class]]) {
            [(MultiSwitchView *)item addTarget:m_target action:@selector(clickMultiSwitch:)];
            
//            if ([item tag] == (int)ActionTypeCameraFaceState){
//				[(SegmentView*)item setAction:[BookManager sharedInstance].cameraFaceIsOpen];
//            }
        } else if ([item isMemberOfClass:[UICheckButton class]]){
			[(UICheckButton*)item setDelegate:m_target];
		}
	}
}

- (void)animationDidFinished:(AnimationView *)animationView
{
	m_currentRewardIndex++;
	if (m_currentRewardIndex < m_rewardNumber)
	{
		m_reward.frame = [self getRandomFrame:m_reward];
		[m_reward startAnimating];
	}
}

- (CGRect)getRandomFrame:(UIView *)view
{
	CGRect rect = view.frame;
	rect.origin.x = arc4random()%(int)(self.frame.size.width - CGRectGetWidth(view.frame));
	rect.origin.y = arc4random()%(int)(self.frame.size.height - CGRectGetHeight(view.frame));
	
	return rect;
}

//	===================audios================
- (void)initAudio:(NSNumber*)indexValue{
	if (m_dialogAudioPlayer) {
		[m_dialogAudioPlayer stop];
		[m_dialogAudioPlayer release];
		m_dialogAudioPlayer = nil;
	}
	
	int count = [m_audiosArray count];
	int index = [indexValue intValue];
	if (index>=0 && index <count ) {
		m_audioIndex = index;
		NSString *audioPath =[m_audiosArray objectAtIndex:index];
		m_dialogAudioPlayer = [[BBAudioPlayer alloc] initWithContentsOfFile:audioPath];
		[m_dialogAudioPlayer setDelegate:self];
	}
}

- (void)playAudio{
	if (m_dialogAudioPlayer && !m_dialogAudioPlayer.playing) {
		[m_dialogAudioPlayer play];
	}
}

- (void)stopAudio{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAudio) object:nil];
	
	if (m_dialogAudioPlayer && [m_dialogAudioPlayer isPlaying]) {
		[m_dialogAudioPlayer stop];
	}
}

- (void)pauseAudio{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAudio) object:nil];
	
	if (m_dialogAudioPlayer && m_dialogAudioPlayer.playing) {
		[m_dialogAudioPlayer pause];
	}
}
		 
- (void)BBAudioPlayerDidFinishPlaying:(BBAudioPlayer *)player
{
	// Add by lh - 2011/12/16
	if ([m_target respondsToSelector:@selector(AudioPlayerDidFinished:)])
	{
		// 播放音频完成，通知Parent
		[m_target performSelector:@selector(AudioPlayerDidFinished:) withObject:[NSNumber numberWithInt:m_audioIndex]];
	}
	[self initAudio:[NSNumber numberWithInt:m_audioIndex+1]];
	[self playAudio];
}

	//	===================showAnimation & play===============
- (void)showAnimation:(BOOL)animated play:(BOOL)play afterDelay:(NSTimeInterval)interval{
	if (animated) {
		[self startAnmimation];
	}else
	{
		[m_reward startAnimating];
	}

	
	if (play) {
		if ([m_audiosArray count]) {
			[self performSelector:@selector(playAudio) withObject:nil afterDelay:interval];
		}
	}
}

- (void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self stopAudio];
	
	if (m_reward)
	{
		if ([m_reward isAnimating])
		{
			[m_reward stopAnimating];
		}
		[m_reward release];
		m_reward = nil;
	}
}

- (NSArray*)subItems{
	return [m_containerView subviews];
}


- (void)startAnmimation{
	CAKeyframeAnimation * animation; 
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
	animation.duration = 0.5; 
	animation.delegate = self;
	animation.fillMode = kCAFillModeForwards;
	
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]]; 
	
	animation.values = values;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
	[m_containerView.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (flag)
	{
		[m_reward startAnimating];
	}
}

- (void)dealloc {
	//MSLog(@"removeDialog--dealloc");
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[m_containerView.layer removeAllAnimations];
	[m_containerView removeFromSuperview];
	
	[m_dialogAudioPlayer setDelegate:nil];
	[m_dialogAudioPlayer stop];
	[m_dialogAudioPlayer release];
	m_dialogAudioPlayer = nil;
	
	[m_audiosArray release];
	[m_layers release];
	[m_languageLayers release];
	[m_resDirectory release];
	[m_dialogInfo release];
    [super dealloc];
}


@end

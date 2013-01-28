//
//  AnimationPlayerView.m
//  BabyBooks
//
//  Created by 雷 晖 on 12-3-22.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "AnimationPlayerView.h"

@implementation AnimationPlayerView

@synthesize animations = m_animations;
@synthesize autoStart = m_autoStart;
@synthesize autoStartDelayTime = m_autoStartDelayTime;
@synthesize shouldClick = m_shouldClick;
@synthesize clickReplayAnimation = m_clickReplayAnimation;
@synthesize isRetainAnimation = m_isRetainAnimation;
@synthesize interval = m_interval;
@synthesize delegate = m_delegate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		m_index = -1;
		m_count = 0;
    }
    return self;
}

- (void)setAnimations:(NSArray *)animations
{
    if (animations != m_animations) {
        [m_animations release];
        m_animations = [animations retain];
    }
}

// 播放动画
- (void)startAnimating
{
    if (m_count > 1) {
        AnimationView *animationView = nil;
        
        if (!m_isRetainAnimation) {
            NSArray *views = [self subviews];
            for (UIView *view in views) {
                if ([view isKindOfClass:[AnimationView class]]) {
                    animationView = (AnimationView *)view;
                    if ([animationView isAnimating]) {
                        [animationView stopAnimating];
                    }
                    [animationView removeFromSuperview];
                    animationView = nil;
                }
            }
        }
        
        if (m_index >= 0 && m_index < m_count) {
            m_isAnimating = YES;
            animationView = [m_animations objectAtIndex:m_index];
            [animationView setStopSelector:@selector(animationPlayDidFinished:) target:self context:nil];
            [self addSubview:animationView];
            [animationView startAnimating];
        }
    }
}

- (void)setAnimationView
{
    m_index = 0;
    m_count = [m_animations count];
    [self addSubview:[m_animations objectAtIndex:m_index]];
    
    if (m_shouldClick) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)stopAnimations
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (AnimationView *animationView in m_animations) {
        if ([animationView isAnimating]) {
            [animationView stopAnimating];
        }
    }
}

// 动画的个数
- (int)animationCount
{
    return m_count;
}

// 点击播放动画
- (void)clickBtn
{
    if (m_isAnimating) {
        return;
    }
    
    // 点击重新播放动画
    if (m_clickReplayAnimation) {
        if (m_animationPlayFinished) {
            m_animationPlayFinished = NO;
            m_index = 0;
            [self startAnimating];
        }
    } else {
        if (m_count > 1){
            if (m_index >= 0 && m_index < m_count) {
                AnimationView *animationView = [m_animations objectAtIndex:m_index];
                if (animationView) {
                    [animationView startAnimating];
                }
            } else {
                // 播放最后一个动画
                AnimationView *animationView = [m_animations objectAtIndex:m_count-1];
                if (animationView) {
                    [animationView startAnimating];
                }
            }
        }
    }
    
    if (m_delegate && [m_delegate respondsToSelector:@selector(animationPlayerViewClicked:)]) {
        [m_delegate animationPlayerViewClicked:self];
    }
}

- (void)animationPlayDidFinished:(id)context
{
    m_isAnimating = NO;
    
    m_index++;
    if (m_index < m_count) {
        [self performSelector:@selector(startAnimating) withObject:nil afterDelay:m_interval];
//        [self startAnimating];
    } else if (m_index == m_count) {
        m_animationPlayFinished = YES;
    }
}

// 播放指定索引的动画
- (void)playAnimationAtIndex:(int)index
{
    if (index >= 0 && index < m_count) {
        AnimationView *animationView = [m_animations objectAtIndex:index];
        if (animationView) {
            [animationView startAnimating];
        }
    }
}

- (void)dealloc {
	[m_animations release];
    [super dealloc];
}

@end

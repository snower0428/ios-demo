//
//  MultiSwitchAnimationView.m
//  BabyBooks
//
//  Created by 雷 晖 on 12-2-16.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "MultiSwitchAnimationView.h"

@implementation MultiSwitchAnimationView

@synthesize animations = m_animations;
@synthesize isRandom = m_isRandom;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		m_index = -1;
		m_count = 0;
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = self.bounds;
		btn.backgroundColor = [UIColor clearColor];
		[self addSubview:btn];
		[btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
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

- (void)setAnimationView
{
    m_index = 0;
    m_count = [m_animations count];
    [self addSubview:[m_animations objectAtIndex:m_index]];
}

- (void)stopAnimations
{
    for (AnimationView *animationView in m_animations) {
        if ([animationView isAnimating]) {
            [animationView stopAnimating];
        }
    }
}

- (void)clickBtn
{
    if (m_isAnimating) {
        return;
    }
    
	if (m_count > 1)
    {
        AnimationView *animationView = nil;
        
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
        if (m_index >= 0 && m_index < m_count) {
            m_isAnimating = YES;
            animationView = [m_animations objectAtIndex:m_index];
            [animationView setStopSelector:@selector(animationPlayDidFinished:) target:self context:animationView];
            [self addSubview:animationView];
            [animationView startAnimating];
            
            if (m_isRandom) {
                m_index = arc4random()%m_count;
            }else{
                m_index = (m_index+1)%m_count;
            }
        }
	}
}

- (void)animationPlayDidFinished:(id)context
{
    m_isAnimating = NO;
}

- (void)dealloc {
	[m_animations release];
    [super dealloc];
}

@end

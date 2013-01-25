//
//  AnimationPlayerView.h
//  BabyBooks
//
//  Created by 雷 晖 on 12-3-22.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimationPlayerViewDelegate;

@interface AnimationPlayerView : UIView
{
    NSArray         *m_animations;  // 保存动画
    int             m_index;        // 当前动画的索引
    int             m_count;        // 动画的数量
    BOOL            m_isAnimating;  // 是否正在动画中
    
    BOOL			m_autoStart;            // 动画是否自动启动
	NSTimeInterval	m_autoStartDelayTime;   // 动画自动启动的延时时间
    
    BOOL            m_shouldClick;
    BOOL            m_clickReplayAnimation;     // 点击是否重新播放动画
    BOOL            m_isRetainAnimation;        // 是否保留其它的动画
    BOOL            m_animationPlayFinished;    // 动画播放是否完成
    
    CGFloat         m_interval;                 // 两个动画间的时间间隔
    
    id<AnimationPlayerViewDelegate> m_delegate;
}

@property(nonatomic, retain) NSArray *animations;
@property(nonatomic, assign) BOOL autoStart;
@property(nonatomic, assign) NSTimeInterval autoStartDelayTime;
@property(nonatomic, assign) BOOL shouldClick;
@property(nonatomic, assign) BOOL clickReplayAnimation;
@property(nonatomic, assign) BOOL isRetainAnimation;
@property(nonatomic, assign) CGFloat interval;
@property(nonatomic, assign) id<AnimationPlayerViewDelegate> delegate;

- (void)setAnimationView;
- (void)stopAnimations;
- (void)startAnimating;
- (int)animationCount;
- (void)playAnimationAtIndex:(int)index;

@end

@protocol AnimationPlayerViewDelegate <NSObject>

@optional
- (void)animationPlayerViewClicked:(AnimationPlayerView *)animationPlayerView;

@end

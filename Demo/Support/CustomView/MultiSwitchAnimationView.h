//
//  MultiSwitchAnimationView.h
//  BabyBooks
//
//  Created by 雷 晖 on 12-2-16.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSwitchAnimationView : UIView
{
    NSArray         *m_animations;  // 保存动画
    int             m_index;        // 当前动画的索引
    int             m_count;        // 动画的数量
    BOOL            m_isAnimating;  // 是否正在动画中
    BOOL            m_isRandom;     // 是否是随机切换动画
}

@property(nonatomic, retain) NSArray *animations;
@property(nonatomic, assign) BOOL isRandom;

- (void)setAnimationView;
- (void)stopAnimations;

@end

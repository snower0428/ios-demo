//
//  ClickImageView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	============  可点击的静态图片（可以设置是否有手指触摸效果）	================

#import <UIKit/UIKit.h>


@interface ClickImageView : UIImageView {
	UIButton	*m_btn;
	BOOL		m_showsTouchWhenHighlighted;
}

@property(nonatomic)        BOOL            showsTouchWhenHighlighted; 

//	添加点击处理事件和对象
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

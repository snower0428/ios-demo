//
//  ClickImageView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClickImageView.h"


@implementation ClickImageView

@synthesize showsTouchWhenHighlighted = m_showsTouchWhenHighlighted;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btn.frame =  CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		m_btn.backgroundColor = [UIColor clearColor];
		m_btn.tag = self.tag;
		[self addSubview:m_btn];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
	self.userInteractionEnabled = YES;
	
	if (nil == m_btn) {
		m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btn.frame =  self.bounds;
		m_btn.backgroundColor = [UIColor clearColor];
		[self addSubview:m_btn];
	}else {
		if (CGRectEqualToRect(m_btn.frame, CGRectZero)) {
			m_btn.frame =  self.bounds;
		}
	}

	m_btn.showsTouchWhenHighlighted = m_showsTouchWhenHighlighted;
	m_btn.tag = self.tag;
	[m_btn addTarget:target action:action forControlEvents:controlEvents];
}


- (void)setShowsTouchWhenHighlighted:(BOOL)highlight{
	m_showsTouchWhenHighlighted = highlight;
	
	if (m_btn) {
		[m_btn setShowsTouchWhenHighlighted:highlight];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

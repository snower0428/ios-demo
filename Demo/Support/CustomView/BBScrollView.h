//
//  BBScrollView.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-12-5.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView	*m_scrollView;
	UIPageControl	*m_pageControl;
	UIImage			*m_bgImage;
	
	NSDictionary	*m_dataSource;
	NSString		*m_resDirectory;
	id				m_target;
	
	NSInteger		m_pageIndex;
	NSInteger		m_pageCount;
}

- (id)initWithFrame:(CGRect)frame dataSource:(NSDictionary*)dataSource resDirectory:(NSString*)resDirectory;
- (void)addTarget:(id)target;

@end
